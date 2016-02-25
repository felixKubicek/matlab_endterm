classdef fixation_point

  properties
    win;
    coordinate;
    color;
  end

  methods
    function obj = fixation_point(win, center, radius, ppd, color)
      obj.win = win;
      obj.coordinate = [center-radius*ppd center+radius*ppd];
      obj.color = color;
    end

    function draw(obj)
        Screen('FillOval', obj.win, uint8(obj.color), obj.coordinate);  % draw fixation dot (flip erases it)
    end
  end

end

