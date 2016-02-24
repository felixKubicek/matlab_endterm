classdef aperture < handle

  properties
    center;
    fixation;
  end

  methods
    function obj = aperture(winRect, ppd, fixation_color)

      [x y] = RectCenter(winRect);
      obj.center(1) = x;
      obj.center(2) = y;

      obj.fixation = fixation_point(obj.center, constants.fixation_radius, ppd, fixation_color);
    end

    function draw(obj, win)
      draw(obj.fixation, win);
    end

  end

end


