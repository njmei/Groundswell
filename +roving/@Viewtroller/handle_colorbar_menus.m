function handle_colorbar_menus(self,tag)

% switch on the tag
switch(tag)
  case 'min_max'
    data=self.model.data;
    d_min=min(data(:));
    d_max=max(data(:));
    cb_min_string=sprintf('%.4e',d_min);
    cb_max_string=sprintf('%.4e',d_max);
    self.set_colorbar_bounds(cb_min_string,cb_max_string);     
  case 'five_95'
    data=self.model.data;
    data=data(:);
    n_bins=1000;
    [h,t]=hist(data,n_bins);
    ch=cumsum(h);
    % figure; plot(t,ch);
    cb_min=crossing_times(t,ch,0.05*ch(n_bins));
    cb_max=crossing_times(t,ch,0.95*ch(n_bins));
    cb_min_string=sprintf('%.4e',cb_min);
    cb_max_string=sprintf('%.4e',cb_max);
    self.set_colorbar_bounds(cb_min_string,cb_max_string);
  case 'abs_max'
    data=self.model.data;
    cb_max=max(abs(data(:)));
    cb_min_string=sprintf('%.4e',-cb_max);
    cb_max_string=sprintf('%.4e',+cb_max);
    self.set_colorbar_bounds(cb_min_string,cb_max_string);     
  case 'ninety_symmetric'
    % need to fix this, since what it does now is useless
    data=self.model.data;
    data=abs(data(:));
    n_bins=1000;
    [h,t]=hist(data,n_bins);
    ch=cumsum(h);
    % figure; plot(t,ch);
    cb_max=crossing_times(t,ch,0.9*ch(n_bins));
    cb_min=-cb_max;
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



