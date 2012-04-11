classdef Controller < handle

  properties
    model;  % the model
    view;  % the view
    card_birth_roi_next;  % the cardinality of the next ROI to be created
                          % e.g. if the next one will be the 1st one, this 
                          % would be one    
  end  % properties
  
  properties (Dependent=true)
    roi_list
  end
  
  methods
    function self=Controller(varargin)
      % Leave the model empty until we load data
      self.model=[];
      
      % Make the view
      self.view=roving.View(self);

      % Init the ROI counter
      self.card_birth_roi_next=[];
      
      % load the data, if given an arg
      if nargin>=1
        if ischar(varargin{1})
          file_name=varargin{1};
          self.load_video_from_file(file_name);
        else
          % Assume the argument is a 3D array
          self.load_video(varargin{1});
        end
      end
    end  % constructor
        
  end  % methods

  methods (Access=private)
  end  % methods
  
end  % classdef
