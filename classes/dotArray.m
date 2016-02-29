classdef dotArray < handle

  properties
    num_dots; % number of dots in array
    win;
    color;
    age;
    x;
    y;
    dx;
    dy;
    width; % actual dot width
    pfs; % dot speed per frame
    center; % dot is relative drawn to center 
    rmin; % minimal radius of dot from center
    rmax; % maximal radius of dot from center
  end


  methods
  
    function obj = dotArray(constants, num_dots, color, rmin, rmax, center, numCoherentDots, coherentDirection)
      obj.win = constants.win;
      disp('sdfsdf')
      obj.num_dots = num_dots;
      obj.color = color;
      obj.width = constants.dot_width * constants.ppd;
      obj.pfs = constants.dot_speed * constants.ppd / constants.fps;
      obj.rmin = rmin;
      obj.rmax = rmax;
      obj.center = center;
      
      % set initial position and direction for all dots
      [obj.x obj.y] = getPositions(obj, num_dots);
      [obj.dx obj.dy] = getDirections(obj, num_dots);
      
      % set same direction for coherent dots
      if numCoherentDots
        [obj.dx(1:numCoherentDots) obj.dy(1:numCoherentDots)] = pol2cart(coherentDirection*ones(1, numCoherentDots),
                                                                         obj.pfs*ones(1, numCoherentDots));
      end
    end

    function [x, y] = getPositions(obj, num_positions)
    
      rho = obj.rmax * sqrt(rand(1, num_positions)); 
      rho(rho < obj.rmin) = obj.rmin;
    
      theta = 2*pi*rand(1, num_positions);
    
      [x y] = pol2cart(theta, rho); 
    end
    
    function [dx, dy] = getDirections(obj, num_directions)
      [dx dy] = pol2cart(2*pi*rand(1, num_directions), obj.pfs*ones(1, num_directions));
    end

    function move(obj)
      obj.x = obj.x + obj.dx;
      obj.y = obj.y + obj.dy;
      
      [new_theta, new_rho] = cart2pol(obj.x, obj.y);
      
      % update positions and directions of points
      to_update = find(new_rho < obj.rmin | new_rho > obj.rmax);
      if to_update
        [obj.x(to_update) obj.y(to_update)] = getPositions(obj, length(to_update));
        %[obj.dx(to_update) obj.dy(to_update)] = getDirections(obj, length(to_update));
      end
    end

    function draw(obj)
        Screen('DrawDots', obj.win, [obj.x; obj.y], obj.width, obj.color, obj.center, 1);  % change 1 to 0 to draw square dots
    end

  end

end
