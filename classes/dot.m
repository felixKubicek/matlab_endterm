classdef dot < handle

  properties
    color;
    age;
    x;
    y;
    dx;
    dy;
    width; % actual dot width
    pfs; % dot speed per frame
  end

  methods
    function dot(obj, win, color, width, pfs)
      obj.color = color;
      obj.width = width;
      obj.pfs = pfs;
    end
    
    function setPosition(obj, rmin, rmax)

      rho = rmax * sqrt(rand()); 
      
      if rho<rmin 
        rho= rmin;
      end

      theta = 2*pi*rand();

      [obj.x obj.y] = pol2cart(theta, rho); 
    end

    function setDirection(obj)

      [obj.dx obj.dy] = pol2cart(2*pi*rand(), obj.pfs);
    end
    
    function move(obj, rmin, rmax)
      
      obj.x = obj.x + obj.dx;
      obj.y = obj.y + obj.dy;
    

      [new_theta, new_rho] = cart2pol(obj.x, obj.y);

      if  new_rho < rmin || new_rho > rmax
        setPosition(obj, rmin, rmax); % choose new position
        setDirection(obj); % choose new direction
      end
    end

    function draw(obj, win, center)
      % draw dot (dot coordinate relative to center)
      Screen('DrawDots', win, [obj.x; obj.y], obj.width, uint8(obj.color), center, 1);  % change 1 to 0 to draw square dots
    end

  end

end
