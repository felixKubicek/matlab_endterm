classdef logger < handle
  properties
    result_filename;
    result_file;
  end
    
  methods
    function obj = logger(patient_num)
      % timestr = strftime('%T_%b_%d\n', localtime(time()));
      obj.result_filename = sprintf('patient_%d.txt', patient_num);
      obj.result_file = fopen(obj.result_filename, 'w');
    end
    
    
    function announceTraining(obj)
      logLine(obj, 'start of training phase');
    end
    
    function logTrainigTrail(obj, block_id, trail_id, rt, timeout_exp, correct);
      t_line = sprintf('block: %d; trail: %d; rt: %f; valid: %d; correct: %d', block_id, trail_id, rt, ~timeout_exp, correct);
      logLine(obj, t_line);
    end
    
    function logStaircase(obj, correct, staircase_num, staircase)
      t_line = sprintf('id: %d; correct: %d; reversals: %d; coherence: %f; correct_responses: %d', staircase_num, correct, staircase.reversals, staircase.coherence_value, staircase.num_correct_responses);
      logLine(obj, t_line);
    end
    
    
    function logLine(obj, log_str)
      fprintf(obj.result_file, '%s\n', log_str);
    end
    
    function close_file(obj)
      fclose ('all');
      printf('results logged to %s\n', obj.result_filename);
    end
  end
  
end

