classdef aperture < handle

  properties
    center;
    radius_min;
    radius_max;
    fixation;
    red_dots;
    green_dots;
  end

  methods
    function obj = aperture(constants, targetColorID, coherentFraction, coherentDirection)
        
      obj.radius_min = constants.apperture_min_radius * constants.ppd;
      obj.radius_max = constants.apperture_max_radius * constants.ppd;

      % calculate center of aperture
      [obj.center(1) obj.center(2)] = RectCenter(constants.winRect);

      obj.fixation = fixation(constants, obj.center);
      
      
      redCoherentDots = greenCoherentDots = 0;
      % coherent fraction refers to only one dot color ( 0 <= fraction <= 0.5)
      numCoherentDots = min(round(coherentFraction*(constants.num_dots)), constants.num_dots/2);
      
      if targetColorID == constants.red
        redCoherentDots = numCoherentDots;
      else
        greenCoherentDots = numCoherentDots;
      end
      
      obj.red_dots = dotArray(constants, constants.num_dots/2, constants.red, obj.radius_min,
                              obj.radius_max, obj.center, redCoherentDots, coherentDirection);
                            
      obj.green_dots = dotArray(constants, constants.num_dots/2, constants.green, obj.radius_min,
                                obj.radius_max, obj.center, greenCoherentDots, coherentDirection);
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


