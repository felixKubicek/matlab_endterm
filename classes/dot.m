classdef dot < handle

  properties  
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

    function obj = dot(win, color, width, pfs, rmin, rmax, center)
      obj.win = win;
      obj.color = color;
      obj.width = width;
      obj.pfs = pfs;
      obj.rmin = rmin;
      obj.rmax = rmax;
      obj.center = center;
      % set initial position and direction for dot
      setPosition(obj);
      setDirection(obj);
    end

    function setPosition(obj)

      rho = obj.rmax * sqrt(rand()); 
      
      if rho < obj.rmin 
        rho = obj.rmin;
      end

      theta = 2*pi*rand();

      [obj.x obj.y] = pol2cart(theta, rho); 
    end

    function setDirection(obj)

      [obj.dx obj.dy] = pol2cart(2*pi*rand(), obj.pfs);
    end
    
    function move(obj)
      
      obj.x = obj.x + obj.dx;
      obj.y = obj.y + obj.dy;
    
      [new_theta, new_rho] = cart2pol(obj.x, obj.y);

      if  new_rho < obj.rmin || new_rho > obj.rmax
        setPosition(obj); % choose new position
        setDirection(obj); % choose new direction
      end
    end

    function draw(obj)
      % draw dot (dot coordinate relative to center)
      Screen('DrawDots', obj.win, [obj.x; obj.y], obj.width, uint8(obj.color), obj.center, 1);  % change 1 to 0 to draw square dots
    end

  end

end
