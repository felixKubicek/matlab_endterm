classdef experiment1 < handle
  
  properties
    constants = constants();
    design_gen; % generates experimental designs
    logger; % writes certain experimental results to output file
  end

  methods
  
    function obj = experiment1(patient_num)
      obj.design_gen = design_generator(obj.constants, patient_num);
      obj.logger = logger(patient_num);
    end
    
    
    function coherenceThreshold = getCohDisThresh(obj)
      % pre-training -> determine coherence discrimination threshold
      num_blocks = 1;
      num_trails = 120;
      reversals_per_staircase = 10;
      
      responseSetCodes = KbName(obj.constants.color_keys); % respond to colors
      
      % staircase from above and below
      staircases = {staircase(0.5, true), staircase(0, false)};
      
      % if reversal of staircase threshold is saved here
      reversal_thresholds = [];
      
      for block_num = 1:num_blocks
        block_design = generatePreTrainingBlock(obj.design_gen, num_trails);
        disp_block_intro(obj, block_num, responseSetCodes);
        
        for trail_num = 1:size(block_design, 1)
        
          % choose randomly one of 2 staircases
          which_staircase_ind = randi(length(staircases));
          which_staircase = staircases{which_staircase_ind};
          
          targetColor = block_design(trail_num, 1);
          direction = block_design(trail_num, 2);
          coherentFraction = which_staircase.coherence_value;
          timeout = 100; % 100 sec
          
          [rt, timeout_exp, correct] = presentStimulus(obj, targetColor, coherentFraction, direction, timeout, responseSetCodes);
          
          if correct
            [reversal_happend, reversal_thresh] = stimulusYes(which_staircase);
          else
            [reversal_happend, reversal_thresh] = stimulusNo(which_staircase);
          end
          
          if reversal_happend
            reversal_thresholds(end+1) = reversal_thresh;
          end
          
          logStaircase(obj.logger, correct, which_staircase_ind, which_staircase);
          
          if (staircases{1}.reversals >= reversals_per_staircase) && (staircases{2}.reversals >= reversals_per_staircase)
            break;
          end
        end
        
        if (staircases{1}.reversals >= 10) && (staircases{2}.reversals >= 10)
          % linke in the paper -> if more than 10 reversals per staircase -> use mean of final 6 reversals
          coherenceThreshold = mean(reversal_thresholds(end-5:end));
          informCalcThresh(obj.logger, coherenceThreshold);
        else
          % simplification -> just use estimation of threshold
          coherenceThreshold = obj.constants.estimated_coherent_fraction_thresh;
          informEstThresh(obj.logger, coherenceThreshold);
        end
      end
    
    end
    
    
    function training_phase(obj, coherentFraction)
      % 8 blocks, 100 trails each
      % timeout 20.000 ms -> trial invalid
      % 4 response keys ("d", "f", "x", "c")
      % randomized target color
      
      announceTraining(obj.logger);
      responseSetCodes = KbName(obj.constants.direction_keys); % set direction keys as response set
      
      num_blocks = 2; % 8;
      num_trails = 5; % 100;
      
      for block_num = 1:num_blocks
        block_design = generateTrainingBlock(obj.design_gen, num_trails);
        disp_block_intro(obj, block_num, responseSetCodes);
        
        for trail_num = 1:size(block_design, 1)
          targetColor = block_design(trail_num, 1);
          direction = block_design(trail_num, 2);
          
          [rt, timeout_exp, correct] = presentStimulus(obj, targetColor, coherentFraction, direction, 10, responseSetCodes);
          logTrainigTrail(obj.logger, block_num, trail_num, rt, timeout_exp, correct);
        end
      end
    end
    
    
    function disp_block_intro(obj, block_num, responseSetCodes)
      pause_text =  sprintf ('Pause\nBLOCK %d \nPlease press any Button!\n\n', block_num);
      
      if isequal(responseSetCodes, KbName(obj.constants.direction_keys))
        ul_help = sprintf('upper_left:  %c\n', obj.constants.direction_keys{constants.ul});
        ll_help = sprintf('lower_left:  %c\n', obj.constants.direction_keys{constants.ll});
        ur_help = sprintf('upper_right: %c\n', obj.constants.direction_keys{constants.ur});
        lr_help = sprintf('lower_right: %c\n', obj.constants.direction_keys{constants.lr});
        key_help_text = strcat('Direction key mappings:\n', ul_help, ll_help, ur_help, lr_help);
      elseif isequal(responseSetCodes, KbName(obj.constants.color_keys))
        red_help   = sprintf('red:    %c\n', obj.constants.color_keys{constants.red});
        green_help = sprintf('green:  %c\n', obj.constants.color_keys{constants.green});
        key_help_text = strcat('Color key mappings:\n', red_help, green_help);
      else
        key_help_text = '';
      end
      
      [nx, ny] = DrawFormattedText(obj.constants.win, pause_text, obj.constants.winRect(4)/3, 'center', obj.constants.white);
      DrawFormattedText(obj.constants.win, key_help_text, nx, ny, obj.constants.white);
      
      Screen('Flip', obj.constants.win);
      waitForAnyKey();
    end
  
  
    function do_experiment(obj)
      try
        init_display(obj);
        % display now initialized
        % determine coherence discrimination threshold
        coherenceThresh = getCohDisThresh(obj);
        % perform training
        training_phase(obj, coherenceThresh);
        ShowCursor;
        Screen('CloseAll');
        close_file(obj.logger);
      catch
        Priority(0);
        ShowCursor
        Screen('CloseAll');
        close_file(obj.logger);
        rethrow (lasterror);
      end
    end


    function init_display(obj)
        Screen('Preference', 'SkipSyncTests', 1);
        Screen('Preference','SuppressAllWarnings', 1);
    
        screens = Screen('Screens');
        obj.constants.screenNumber = max(screens);
                   
        [obj.constants.win, obj.constants.winRect] = Screen('OpenWindow', obj.constants.screenNumber, obj.constants.bg_color,[], 32, 2);
        
        obj.constants.black = BlackIndex(obj.constants.win);
        obj.constants.white = WhiteIndex(obj.constants.win);
        
        monitorXResolution = obj.constants.winRect(3)-obj.constants.winRect(1);
        obj.constants.ppd = pix2va(constants.mon_width, monitorXResolution, constants.mon_dist);
                    
        % Enable alpha blending with proper blend-function. We need it for drawing of smoothed points:
        Screen('BlendFunction', obj.constants.win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
        obj.constants.fps = Screen('FrameRate', obj.constants.win);      % frames per second
        obj.constants.ifi = Screen('GetFlipInterval', obj.constants.win);

        if obj.constants.fps==0
          obj.constants.fps = 1/obj.constants.ifi;
        end;
        
        HideCursor; % Hide the mouse cursor

        Priority(MaxPriority(obj.constants.win));
        
        % Do initial flip...
        vbl = Screen('Flip', obj.constants.win);
    end
    
    function [rt, timeout_exp, correct] = presentStimulus(obj, targetColor, coherentFraction, direction, timeout, responseSetCodes)
      
      apperture = aperture(obj.constants, targetColor, coherentFraction, direction);
      
      % draw only fixation in the beginning and wait for 1 s
      apperture.fixation.draw()
      Screen('Flip', obj.constants.win);
      WaitSecs(1.0);
      
      vbl_0 = 0;
      vbl = 0;
      
      flush_keyboard();
    
      while true
    
        if vbl > 0
          draw(apperture);
          Screen('DrawingFinished', obj.constants.win); % Tell PTB that no further drawing commands will follow before Screen('Flip')
        end
          
        % timeout happened
        if vbl - vbl_0 >= timeout
          timeout_exp = true;      
          rt = NaN;
          correct = NaN;
          break;
        end
        
        [single_pressed, secs, keyName] = checkForSingleKey(responseSetCodes);
        
        % user pressed a valid key
        if single_pressed
          timeout_exp = false;
          rt = secs - vbl_0;
          correct = evaluateResponse(obj, keyName, targetColor, direction, responseSetCodes);
          break;
        end
        
        move_dots(apperture, targetColor, coherentFraction, direction);
        
        vbl = Screen('Flip', obj.constants.win, vbl + (constants.waitframes-0.5)*obj.constants.ifi);
        
        if vbl_0 == 0
          vbl_0 = vbl;
        end
      end
      % clear screen
      Screen('Flip', obj.constants.win);
    end
    
    
    function correct = evaluateResponse(obj, keyName, targetColor, direction, responseSetCodes)
      if isequal(responseSetCodes, KbName(obj.constants.direction_keys))
        correct = obj.constants.direction_keys{direction} == keyName;
      elseif isequal(responseSetCodes, KbName(obj.constants.color_keys))
        correct = obj.constants.color_keys{targetColor} == keyName;
      else
        correct = NaN;
      end
    end

  end
end

