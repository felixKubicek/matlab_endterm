classdef experiment1 < handle
  
  properties
    constants = constants();
    seq_gen;
  end

  methods
  
  function obj = experiment1(patient_num)
    obj.seq_gen = sequence_fsm(obj.constants, patient_num);
    %debug_here();
  end
  
  function training_phase(obj)
    % 8 blocks, 100 trails each
    % timeout 20.000 ms -> trial invalid
    % 4 response keys ("ö", "ä", ".", "-")
    % feedback in case of wrong answer
    % randomized target color
    
    num_blocks = 8;
    num_trails = 100;
    %target_colors = []
    
    
    
    
    
    %for curr_block = 1:num_blocks
    %end
  end
  
  %function generate_design(with_sequence, num_trails)
    % generate desing with either with completely random transitions
    % or with mixture of frequent/infrequent sequence
    %target_color = round(rand(num_trails, 1));
    %coherent_fraction = constants.init_coherent_fraction * ones(num_trails, 1);
    %end
  
  
  
    function do_experiment(obj)
            
      try
        init_display(obj);
        
        % display initialized
        presentStimulus(obj, constants.green, 0.5, obj.constants.ul);
    
        ShowCursor;
        Screen('CloseAll');
    
      catch
        Priority(0);
        ShowCursor
        Screen('CloseAll');
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
    
    function presentStimulus(obj, targetColor, coherentFraction, direction)
      
      apperture = aperture(obj.constants, targetColor, coherentFraction, direction);
    
      vbl = 0;
    
      while true
    
        if vbl > 0
          draw(apperture);
          Screen('DrawingFinished', obj.constants.win); % Tell PTB that no further drawing commands will follow before Screen('Flip')
        end;
    
        if KbCheck 
          break;
        end;
        
        move_dots(apperture, targetColor, coherentFraction, direction);
      
        vbl = Screen('Flip', obj.constants.win, vbl + (constants.waitframes-0.5)*obj.constants.ifi);
    
      end
    end

  end
end

