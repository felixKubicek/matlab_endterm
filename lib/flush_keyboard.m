function flush_keyboard()
  % wait (blocking) until all keyboard keys are released
  keyIsDown = true;
  while keyIsDown
    keyIsDown = KbCheck(-1);
  end
end