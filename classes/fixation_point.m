classdef fixation_point

  properties
    coordinate;
    color;
  end

  methods
    function obj = fixation_point(center, radius, ppd, color)
      obj.coordinate = [center-radius*ppd center+radius*ppd];
      obj.color = color;
    end

    function draw(obj, win)
        Screen('FillOval', win, uint8(obj.color), obj.coordinate);  % draw fixation dot (flip erases it)
    end
  end

end

