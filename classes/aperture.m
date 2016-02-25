classdef aperture < handle

  properties
    win;
    center;
    fixation;
    red_dots;
    green_dots;
    radius_min;
    radius_max;
  end

  methods
    function obj = aperture(win, winRect, ppd, fps, fixation_color)
        
      obj.win = win;

      obj.radius_min = constants.apperture_min_radius * ppd;
      obj.radius_max = constants.apperture_max_radius * ppd;

      [obj.center(1) obj.center(2)] = RectCenter(winRect);

      obj.fixation = fixation_point(win, obj.center, constants.fixation_radius, ppd, fixation_color);
      
      dot_width = constants.dot_width * ppd;
      dot_pfs = constants.dot_speed * ppd / fps;
      
      obj.red_dots = dotArray(constants.num_dots/2, win, constants.red, dot_width,
                              dot_pfs, obj.radius_min, obj.radius_max, obj.center);
                              
      obj.green_dots = dotArray(constants.num_dots/2, win, constants.green, dot_width,
                                dot_pfs, obj.radius_min, obj.radius_max, obj.center);
    end

    function draw(obj)
      draw(obj.fixation);
      draw(obj.red_dots);
      draw(obj.green_dots);
    end
    
    function move_dots(obj)
        move(obj.red_dots);
        move(obj.green_dots);
    end

  end

end


