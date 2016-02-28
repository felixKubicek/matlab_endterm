function [ppd, dpp] = pix2va(monitorWidthInCm, monitorXResolution, distanceInCm)
  % compute conversion factors for pixels to degrees visual angle conversion,
  %  given monitorWidthInCm and monitorXResolution
  %  at observer distance distanceInCm
  %  using simplified assumption of central presentation
  % INPUT:
  %   monitorWidthInCm: width of visible display area in cm
  % monitorXResolution: x resolution of monitor
  %   distanceInCm: distance of observer in cm
  %
  % Jochen Laubrock
  pixPerCm = monitorXResolution / monitorWidthInCm;
  sizeInCm = 1 / pixPerCm;        % convert 1 pixel to cm
  dpp = cm2va(sizeInCm, distanceInCm);  % convert cm to va
  ppd = 1 / dpp;
end

function vaInDegrees = cm2va(sizeInCm, distanceInCm)
  % vaInDegrees = cm2va(sizeInCm, distanceInCm)
  % convert sizeInCm at observer distance distanceInCm to degrees visual angle, 
  % using simplified assumption of central presentation
  %
  % INPUT:
  %   sizeInCm: size of object in cm
  %   distanceInCm: distance of observer in cm 
  %   (really only needs to have same unit as sizeInCm)
  % OUTPUT:
  %   visual angle of object in degrees
  %
  % Jochen Laubrock 
  vaInDegrees = 2 * atand( sizeInCm / (2 * distanceInCm) ) ;
end
