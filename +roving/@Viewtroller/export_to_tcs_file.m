function export_to_tcs_file(self)

% throw up the dialog box to get file name
[file_name,dir_name]=uiputfile('*.tcs','Export ROIs to file...');
if isnumeric(file_name) || isnumeric(dir_name)
  % this happens if user hits Cancel
  return;
end
file_name_abs=fullfile(dir_name,file_name);

% could take a while
set(self.figure_h,'pointer','watch');
drawnow('update');  drawnow('expose');

try
  % get stuff from the model
  optical=self.model.data;
  roi_list=self.model.roi;

  % calc a roi_stack from the roi_list, and get labels
  [n_row,n_col,~]=size(optical);
  [roi_stack,roi_label]= ...
    roving.roi_list_to_stack(roi_list,n_row,n_col);

  % calc the ROI dF/Fs
  roi_mean=roving.mean_over_roi(optical,roi_stack);

  % save to .tcs file
  t=self.model.t;  % s
  roving.write_o_to_tcs(file_name_abs,...
                          t,roi_mean,roi_label);
catch excp
  set(self.figure_h,'pointer','arrow');
  drawnow('update');  drawnow('expose');
  rethrow(excp);
end

% back to usual pointer
set(self.figure_h,'pointer','arrow');
drawnow('update');  drawnow('expose');
                      
end
