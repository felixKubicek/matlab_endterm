classdef aperture < handle

  properties
    center;
    fixation;
    dots;
    radius_min;
    radius_max;
  end

  methods
    function obj = aperture(win, winRect, ppd, fps, fixation_color, dot_color)

      obj.radius_min = constants.apperture_min_radius * ppd;
      obj.radius_max = constants.apperture_max_radius * ppd;

      [obj.center(1) obj.center(2)] = RectCenter(winRect);

      obj.fixation = fixation_point(win, obj.center, constants.fixation_radius, ppd, fixation_color);
      
      dot_width = constants.dot_width * ppd;
      dot_pfs = constants.dot_speed * ppd / fps;
      
      for i = 1:constants.num_dots
          dots(i) = dot(win, dot_color, dot_width, dot_pfs, obj.radius_min, obj.radius_max, obj.center);
      end
      obj.dots = dots;
      
      class(obj.dots)
    end

    function draw(obj)
      draw(obj.fixation);
      
      for i = 1:constants.num_dots
          draw(obj.dots(i));
      end
    end
    
    function move_dots(obj)
        for i = 1:constants.num_dots
            move(obj.dots(i))
        end
    end

  end

end


