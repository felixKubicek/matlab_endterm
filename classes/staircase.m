classdef staircase < handle

  properties(Constant)
    delta_init = 0.2;
    max_coherence = 0.5;
  end

  properties
    coherence_value;
    above_thresh;
    reversals;
    num_correct_responses;
  end
  
    
  methods
    function obj = staircase(coherence_value, above_thresh)
      obj.coherence_value = coherence_value;
      obj.above_thresh = above_thresh;
      obj.num_correct_responses = 0; % save number of last independent correct responses
      obj.reversals = 0;
    end
    
    
    function [reversal_happend, reversal_thresh] = stimulusYes(obj)
      
      % increase correct responses
      ++obj.num_correct_responses;
      
      % 3 times yes -> decrease coherence value
      if obj.num_correct_responses >= 3
        % reset correct responses
        obj.num_correct_responses = 0;
        
        if obj.above_thresh
          reversal_happend = false;
          reversal_thresh = NaN;
        else
          ++obj.reversals;
          obj.above_thresh = true;
          reversal_happend = true;
          reversal_thresh = obj.coherence_value;
        end
        decreaseCoherenceVal(obj);
      else
        reversal_happend = false;
        reversal_thresh = NaN;
      end
      
    end
    
    
    function [reversal_happend, reversal_thresh] = stimulusNo(obj)
      
      % reset correct responses
      obj.num_correct_responses = 0;
      
      if ~obj.above_thresh
        reversal_happend = false;
        reversal_thresh = NaN;
      else
        % above threshold -> reversal
        obj.above_thresh = false;
        ++obj.reversals;
        reversal_happend = true;
        reversal_thresh = obj.coherence_value;
      end
      
      increaseCoherenceVal(obj);
    end
  
  
    function increaseCoherenceVal(obj)
      % increase coherence value (initial delta value is halved every reversal)
      obj.coherence_value = min(obj.coherence_value + (obj.delta_init * (1/(2^obj.reversals))), obj.max_coherence);
    end
    
    
    function decreaseCoherenceVal(obj)
      % decrease coherence value (initial delta value is halved every reversal)
      obj.coherence_value = min(obj.coherence_value - (obj.delta_init * (1/(2^obj.reversals))), obj.max_coherence);
    end
  end
end

