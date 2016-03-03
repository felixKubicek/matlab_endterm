function waitForAnyKey()
  flush_keyboard();
  
  while true
    if KbCheck(-1) 
      break;
    end
  end
end