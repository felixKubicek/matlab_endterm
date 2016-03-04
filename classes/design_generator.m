classdef design_generator < handle

  properties
    seq_fsm; % generator for directions using sequences 
    target_colors;
  end


  methods
    function obj = design_generator(constants, patient_num)
      obj.seq_fsm = sequence_fsm(constants, patient_num);
      obj.target_colors = constants.dot_colors;
    end
    
    function colors = generateColors(obj, num_colors)
      colors = randi(length(obj.target_colors), num_colors, 1);
    end
    
    function tblock = generateTrainingBlock(obj, num_trails)
      directions = generateRegularSeq(obj.seq_fsm, num_trails);
      targetColors = generateColors(obj, num_trails);
      tblock = [targetColors directions];
    end
    
    function ptblock = generatePreTrainingBlock(obj, num_trails)
      directions = generateRandomSeq(obj.seq_fsm, num_trails);
      targetColors = generateColors(obj, num_trails);
      ptblock = [targetColors directions];
    end
    
  end
  
end

