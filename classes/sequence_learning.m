classdef sequence_learning < handle

  properties (Constant)
    mon_width = 29;   % horizontal dimension of viewable screen (cm)
    mon_dist = 60;    % viewing distance (cm)
    waitframes = 1; % Show new dot-images at each waitframes'th monitor refresh.
  end
  
  properties
    black;
    white;
    ppd; % visual density of the screen (pixels per visual angle degree)
    screenNumber;
    win;
    winRect;
    ifi;
    fps;
    apperture;
  end

  methods
    function do_experiment(obj)
      
      try
        init_display(obj);

        obj.apperture = aperture(obj.win, obj.winRect, obj.ppd, obj.fps, obj.white, obj.white)
        
        % display initialized
        presentStimulus(obj, NaN, NaN, NaN);
    
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
        obj.screenNumber = max(screens);
           
        [obj.win, obj.winRect] = Screen('OpenWindow', obj.screenNumber, 0,[], 32, 2);

        monitorXResolution = obj.winRect(3)-obj.winRect(1);
        obj.ppd = pix2va(obj.mon_width, monitorXResolution, obj.mon_dist);
    
        obj.black = BlackIndex(obj.win);
        obj.white = WhiteIndex(obj.win);
                
        % Enable alpha blending with proper blend-function. We need it for drawing of smoothed points:
        Screen('BlendFunction', obj.win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
        obj.fps = Screen('FrameRate', obj.win);      % frames per second
        obj.ifi = Screen('GetFlipInterval', obj.win);
    
        if obj.fps==0
          obj.fps = 1/obj.ifi;
        end;
    
        HideCursor; % Hide the mouse cursor

        Priority(MaxPriority(obj.win));
        
        % Do initial flip...
        vbl = Screen('Flip', obj.win);
    end
    
    
    function presentStimulus(obj, targetColor, coherentFraction, direction)
    
      vbl = 0;
    
      while true
    
        if vbl > 0
          draw(obj.apperture);
          Screen('DrawingFinished', obj.win); % Tell PTB that no further drawing commands will follow before Screen('Flip')
        end;
    
        if KbCheck 
          break;
        end;
        
        move_dots(obj.apperture);
      
        vbl = Screen('Flip', obj.win, vbl + (obj.waitframes-0.5)*obj.ifi);
    
      end
    end

  end
end

