classdef staircase < handle

  properties(Constant)
    delta_init = 0.2; % initial delta value to increase/decrease coherence_value
    max_coherence = 0.5; % maximum coherence possible
    min_coherence = 0.01; % minimum coherence (5 dots)
  end

  properties
    coherence_value;
    above_thresh; % either above or below threshold
    reversals;
    num_correct_responses; % save number of last independent correct responses
  end
  
    
  methods
    function obj = staircase(coherence_value, above_thresh)
      obj.coherence_value = coherence_value;
      obj.above_thresh = above_thresh;
      obj.num_correct_responses = 0; 
      obj.reversals = 0;
    end
    
    
    function [reversal_happend, reversal_thresh] = stimulusYes(obj)
      
      % increase correct responses
      ++obj.num_correct_responses;
      
      % 3 correct responses in row -> decrease coherence value
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
      % increase coherence value (initial delta value decreases linearly)
      obj.coherence_value = min(obj.coherence_value + (obj.delta_init * (1/(obj.reversals+1))), obj.max_coherence);
    end
    
    
    function decreaseCoherenceVal(obj)
      % decrease coherence value (initial delta value decreases linearly)
      obj.coherence_value = max(obj.coherence_value - (obj.delta_init * (1/(obj.reversals+1))), obj.min_coherence);
    end
  end
end

