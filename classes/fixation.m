classdef fixation

  properties
    win;
    coordinate;
    color;
    center_coordinate;
    center_color;
  end

  methods
    function obj = fixation(constants, center)
      obj.win = constants.win;
      obj.coordinate = [center-constants.fixation_radius*constants.ppd center+constants.fixation_radius*constants.ppd];
      obj.center_coordinate = [center-constants.fixation_center_radius*constants.ppd center+constants.fixation_center_radius*constants.ppd];
      obj.color = constants.black;
      obj.center_color = constants.white;
    end

    function draw(obj)
        Screen('FillOval', obj.win, uint8(obj.color), obj.coordinate);  % draw fixation dot (flip erases it)
        Screen('FillOval', obj.win, uint8(obj.center_color), obj.center_coordinate);  % draw center
    end
  end

end

