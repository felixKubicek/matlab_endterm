function [single_pressed, secs, keyName] = checkForSingleKey(responseSetCodes)

  % scan only for responseSetCodes -> faster
  [keyIsDown, secs, keyCode] = KbCheck(-1);
  
  % only one key pressed
  single_pressed =  keyIsDown && sum(keyCode) == 1 && any(keyCode(responseSetCodes));
          
  if single_pressed
    keyName = KbName(keyCode);
  else
    keyName = [];
  end

end
