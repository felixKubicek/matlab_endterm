classdef constants < handle
  properties (Constant)
    mon_dist = 60;    % viewing distance (cm)
    mon_width = 29;   % horizontal dimension of viewable screen (cm)
    num_dots = 500;   % number of dots
    waitframes = 1; % Show new dot-images at each waitframes'th monitor refresh.
    bg_color = [120 120 120];
    red = [255, 77, 77]; % red (color of dot group 1)
    green = [136, 252, 69]; % green (color of dot group 1)
    dot_width = 0.18; % width in degrees
    dot_speed = 2; % speed (degrees/sec)
    fixation_radius = 0.3;  % radius of fixation point
    fixation_center_radius = 0.1;
    apperture_min_radius = 0.5; % minimum radius of annulus in degrees
    apperture_max_radius = 5; % maximum radius of annulus in degrees
    coherent_fraction_thresh = 0.5; % fixed coherent fraction threshold
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
    % directions (within aperture)
    lr; % lower-right 
    ll; % lower-left
    ul; % upper-left
    ur; % upper-right
    % 2 sequences (choice of frequent/infrequent sequence depends on patient number)
    sequence_a;
    sequence_b;
  end
  
  methods
    function obj = constants()
      obj.lr = pi/4;     
      obj.ll = (3*pi)/4; 
      obj.ul = (5*pi)/4; 
      obj.ur = (7*pi)/4; 
      obj.sequence_a = [obj.ur obj.lr obj.ul obj.ll]
      obj.sequence_b = [obj.ur obj.ll obj.ul obj.lr]
    end
  end
  
end

