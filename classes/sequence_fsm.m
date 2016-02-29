classdef sequence_fsm < handle

  properties (Constant)
    prob_freq_seq = 0.8; % probability for choosing frequent sequence
  end

  properties
    freq_seq;
    infreq_seq;
  end
  
    
  methods(Static)
    function next_direction = nextDirection(direction, sequence)
      dir_indx = find(sequence == direction);
      next_dir_indx = mod(dir_indx,length(sequence)) + 1;
      next_direction = sequence(next_dir_indx);
    end
  end
  
  methods
    function obj = sequence_fsm(constants, patient_num)
      % 2 patient groups with opposite frequent/infrequent sequences
      if mod(patient_num, 2)
        obj.freq_seq = constants.sequence_a;
        obj.infreq_seq = constants.sequence_b;
      else
        obj.freq_seq = constants.sequence_b;
        obj.infreq_seq = constants.sequence_a;
      end
    end
    
    function directions = generateRegularSeq(obj, num_trails)
      
      % first direction completely random
      rand_direction = obj.freq_seq(randi(length(obj.freq_seq)));
      
      calc_directions = [rand_direction];
      
      for trail = 1:(num_trails-1)
        if rand() > obj.prob_freq_seq
          % choose infrequent sequence in 20 % of cases
          next_sequence = obj.infreq_seq;
        else
          % choose frequent sequence in 80 % of cases
          next_sequence = obj.freq_seq;
        end
        
        last_direction = calc_directions(end);
        next_direction = sequence_fsm.nextDirection(last_direction, next_sequence);
        calc_directions = [calc_directions next_direction];
      end
      directions = calc_directions';
    end
    
  end
  
end

