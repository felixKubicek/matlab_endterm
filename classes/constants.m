classdef constants < handle

  properties (Constant)
    num_dots = 50;   % number of dots
    dot_width = 0.18; % width in degrees
    dot_speed = 2; % speed (degrees/sec)
    fixation_radius = 0.15;  % radius of fixation point
    apperture_min_radius = 0.5; % minimum radius of annulus in degrees
    apperture_max_radius = 5; % maximum radius of annulus in degrees
  end
end

