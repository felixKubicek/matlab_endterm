classdef constants < handle
  properties (Constant)
    mon_dist = 60;    % viewing distance (cm)
    mon_width = 29;   % horizontal dimension of viewable screen (cm)
    num_dots = 500;   % number of dots
    waitframes = 1; % Show new dot-images at each waitframes'th monitor refresh.
    bg_color = [120 120 120];
    red = 1; % red (color id for red)
    green = 2; % green (color id for green)
    dot_width = 0.18; % width in degrees
    dot_speed = 2; % speed (degrees/sec)
    dot_max_age = 200; % maximal dot age (ms)
    fixation_radius = 0.3;  % radius of fixation point
    fixation_center_radius = 0.08;
    apperture_min_radius = 0.5; % minimum radius of annulus in degrees
    apperture_max_radius = 5; % maximum radius of annulus in degrees
    coherent_fraction_thresh = 0.5; % fixed coherent fraction threshold
    % directions (within aperture)
    lr = 1; % lower-right 
    ll = 2; % lower-left
    ul = 3; % upper-left
    ur = 4; % upper-right
  end
  
  properties
    ppd; % visual density of the screen (pixels per visual angle degree)
    screenNumber;
    win;
    winRect;
    ifi;
    fps; % frames per second
    black;
    white;
    direction_values; % mapping of direction ids to real float direction (rad)
    direction_keys; % mapping of direciton ids to key names
    color_keys; % mapping of color ids to key names
    % 2 sequences (choice of frequent/infrequent sequence depends on patient number)
    sequence_a;
    sequence_b;
    dot_colors; % colors of dot arrays
  end
  
  methods
    function obj = constants()
      obj.direction_values(constants.ul) = (5*pi)/4;
      obj.direction_values(constants.ll) = (3*pi)/4;
      obj.direction_values(constants.ur) = (7*pi)/4; 
      obj.direction_values(constants.lr) = pi/4;
      
      obj.direction_keys{constants.ul} = 'd';
      obj.direction_keys{constants.ll} = 'x';
      obj.direction_keys{constants.ur} = 'f';
      obj.direction_keys{constants.lr} = 'c';
      
      obj.color_keys{constants.red} = 'r';
      obj.color_keys{constants.green} = 't';
      
      obj.sequence_a = [obj.ur obj.lr obj.ul obj.ll];
      obj.sequence_b = [obj.ur obj.ll obj.ul obj.lr];
      % set specific colors for dots
      obj.dot_colors{constants.red} = [255, 77, 77];
      obj.dot_colors{constants.green} = [136, 252, 69];
      
    end
  end
  
end

