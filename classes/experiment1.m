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
    
    
    %function obj = getCohDisThresh(obj)
    %end
    
    
    
    
    function training_phase(obj)
      % 8 blocks, 100 trails each
      % timeout 20.000 ms -> trial invalid
      % 4 response keys ("d", "f", "x", "c")
      % feedback in case of wrong answer
      % randomized target color
      announceTraining(obj.logger);
      
      num_blocks = 2;
      num_trails = 5;
      
      for block_num = 1:num_blocks
        block_design = generateTrainingBlock(obj.design_gen, num_trails);
        disp_block_intro(obj, block_num);
        
        for trail_num = 1:size(block_design, 1)
          targetColor = block_design(trail_num, 1);
          coherentFraction = block_design(trail_num, 2);
          direction = block_design(trail_num, 3);
          responseSetCodes = KbName(obj.constants.direction_keys);
          
          [rt, timeout_exp, correct] = presentStimulus(obj, targetColor, coherentFraction, direction, 10, responseSetCodes);
          logTrainigTrail(obj.logger, block_num, trail_num, rt, timeout_exp, correct);
        end
      end
    end
    
    
    function disp_block_intro(obj, block_num)
      pause_text =  sprintf ('Pause\nBLOCK %d \nPlease press any Button!\n\n', block_num);
         
      ul_help = sprintf('upper_left:  %c\n', obj.constants.direction_keys{constants.ul});
      ll_help = sprintf('lower_left:  %c\n', obj.constants.direction_keys{constants.ll});
      ur_help = sprintf('upper_right: %c\n', obj.constants.direction_keys{constants.ur});
      lr_help = sprintf('lower_right: %c\n', obj.constants.direction_keys{constants.lr});
      key_help_text = strcat('Direction to key mappings:\n', ul_help, ll_help, ur_help, lr_help);
      
      [nx, ny] = DrawFormattedText(obj.constants.win, pause_text, obj.constants.winRect(4)/3, 'center', obj.constants.white);
      DrawFormattedText(obj.constants.win, key_help_text, nx, ny, obj.constants.white);
      
      Screen('Flip', obj.constants.win);
      waitForAnyKey();
    end
  
  
    function do_experiment(obj)
      try
        init_display(obj);
        % display now initialized
        training_phase(obj);
        
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

