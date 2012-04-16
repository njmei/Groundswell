function handle_colorbar_menus(self,tag)

% switch on the tag
switch(tag)
  case 'min_max'
    self.hourglass();
    [d_min,d_max]=self.model.data_bounds();
    self.unhourglass();
    cb_min_string=sprintf('%.4e',d_min);
    cb_max_string=sprintf('%.4e',d_max);
    self.set_colorbar_bounds(cb_min_string,cb_max_string);     
  case 'five_95'
    self.hourglass();
    [d_05,d_95]=self.model.five_95();
    self.unhourglass();
    % figure; plot(t,ch);
    cb_min_string=sprintf('%.4e',d_05);
    cb_max_string=sprintf('%.4e',d_95);
    self.set_colorbar_bounds(cb_min_string,cb_max_string);
  case 'abs_max'
    self.hourglass();
    cb_max=self.model.max_abs();
    self.unhourglass();
    cb_min_string=sprintf('%.4e',-cb_max);
    cb_max_string=sprintf('%.4e',+cb_max);
    self.set_colorbar_bounds(cb_min_string,cb_max_string);     
  case 'ninety_symmetric'
    % need to fix this, since what it does now is useless
    self.hourglass();
    cb_max=self.model.abs_90();
    cb_min=-cb_max; 
    self.unhourglass();
    cb_min_string=sprintf('%.4e',cb_min);
    cb_max_string=sprintf('%.4e',cb_max);
    self.set_colorbar_bounds(cb_min_string,cb_max_string);
  case 'colorbar_edit_bounds'
    % get the current y min and y max strings
    cb_min_string=self.colorbar_min_string;
    cb_max_string=self.colorbar_max_string;    
    % throw up the dialog box
    bounds=inputdlg({ 'Colorbar Maximum:' , 'Colorbar Minimum:' },...
                    'Edit Colorbar Bounds...',...
                    1,...
                    { cb_max_string , cb_min_string },...
                    'off');
    if isempty(bounds) 
      return; 
    end
    % break out the returned cell array                
    new_cb_max_string=bounds{1};
    new_cb_min_string=bounds{2};
    % convert all these strings to real numbers
    %cb_min=str2double(cb_min_string);
    %cb_max=str2double(cb_max_string);
    new_cb_min=str2double(new_cb_min_string);
    new_cb_max=str2double(new_cb_max_string);
    % if new values are kosher, change colorbar bounds
    if ~isempty(new_cb_min) && ~isempty(new_cb_max) && ...
       isfinite(new_cb_min) && isfinite(new_cb_max) && ...
       (new_cb_max>new_cb_min)
      self.set_colorbar_bounds(new_cb_min_string,new_cb_max_string);
    end
end  



