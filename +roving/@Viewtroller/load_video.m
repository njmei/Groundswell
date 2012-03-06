function load_video(self,data_raw)

% make up a dt, t0
dt=0.050;  % s, => 20 Hz
t0=0;

% set the model
self.model=roving.Model(data_raw,dt,t0);

% sync up the indexed data
data_min=min(self.model.data(:));
data_max=max(self.model.data(:));
self.colorbar_min_string=sprintf('%.4e',data_min);
self.colorbar_max_string=sprintf('%.4e',data_max);
cb_min=str2double(self.colorbar_min_string);
cb_max=str2double(self.colorbar_max_string);
self.indexed_data=uint8(round(255*(self.model.data-cb_min)/...
                                  (cb_max-cb_min)));

% change the colorbar
cb_increment=(cb_max-cb_min)/256;
set(self.colorbar_axes_h,'YLim',[cb_min cb_max]);
set(self.colorbar_h,'YData',[cb_min+0.5*cb_increment...
                             cb_max-0.5*cb_increment]);
                           
% reset the frame index
self.frame_index=1;

% extract the current frame
this_frame=self.indexed_data(:,:,self.frame_index);

% prepare the axes to hold the frame
[n_row,n_col]=size(this_frame);
set(self.image_axes_h,'XLim',[0.5,n_col+0.5],...
                      'YLim',[0.5,n_row+0.5]);

% set the image to the current frame
if self.image_h
  delete(self.image_h)
end  
self.image_h = ...
  image('Parent',self.image_axes_h,...
        'CData',this_frame,...
        'SelectionHighlight','off',...
        'EraseMode','none',...
        'ButtonDownFcn',@(~,~)(self.handle_image_mousing()));
      
% clear the existing ROI border lines, labels
delete(self.border_roi_h);
delete(self.label_roi_h);
      
% init roi state
self.selected_roi_index=zeros(0,1);
self.hide_rois=false;
self.card_birth_roi_next=1;
self.border_roi_h=zeros(0,1);
self.label_roi_h=zeros(0,1);
% self.roi_struct=struct('roi_ids',cell(0,1), ...
%                        'border_h',cell(0,1), ...
%                        'label_h',cell(0,1));
      
% update the frame counter stuff
set(self.FPS_edit_h,'String',sprintf('%6.2f',self.model.fs));
set(self.frame_index_edit_h,'String',sprintf('%d',self.frame_index));
n_frame=size(self.indexed_data,3);
set(self.of_n_frames_text_h,'String',sprintf(' of %d',n_frame));
extent=get(self.of_n_frames_text_h,'Extent');
pos=get(self.of_n_frames_text_h,'Position');
pos_new=[pos(1:2) extent(3:4)];
set(self.of_n_frames_text_h,'Position',pos_new);

% need to set image erase mode to none, since now there are no 
% more lines in front of the image
set(self.image_h,'EraseMode','none');
set(self.delete_all_rois_menu_h,'Enable','off');
set(self.save_rois_to_file_menu_h,'Enable','off');  
set(self.hide_rois_menu_h,'Label','Hide ROIs');
set(self.hide_rois_menu_h,'Enable','off');
% disable the select ROI button
set(self.select_button_h,'Enable','off');
% enable the move all ROIs button
set(self.move_all_button_h,'Enable','off');  

% enable buttons, menus that need enabling
set(self.frame_index_edit_h,'enable','on');
set(self.FPS_edit_h,'enable','on');
set(self.elliptic_roi_button_h,'enable','on');
set(self.rect_roi_button_h,'enable','on');
set(self.zoom_button_h,'enable','on');
set(self.min_max_menu_h,'enable','on');
set(self.five_95_menu_h,'enable','on');
set(self.abs_max_menu_h,'enable','on');
set(self.ninety_symmetric_menu_h,'enable','on');
set(self.rois_menu_h,'enable','on');
set(self.open_rois_menu_h,'enable','on');
set(self.to_start_button_h,'enable','on');
set(self.play_backward_button_h,'enable','on');
set(self.frame_backward_button_h,'enable','on');
set(self.stop_button_h,'enable','on');
set(self.frame_forward_button_h,'enable','on');
set(self.play_forward_button_h,'enable','on');
set(self.to_end_button_h,'enable','on');
set(self.mutation_menu_h,'enable','on');
set(self.motion_correct_menu_h,'enable','on');


%
% change the mode to elliptic_roi
%
new_mode='elliptic_roi';

% untoggle the old mode button
old_button_h=...
  findobj(self.figure_h,'Tag',sprintf('%s_button_h',self.mode));
set(old_button_h,'Value',0);

% check the new menu item
new_button_h=...
  findobj(self.figure_h,'Tag',sprintf('%s_button_h',new_mode));
set(new_button_h,'value',1);

% set the chosen mode
self.mode=new_mode;

% update the fig
set(self.figure_h,'pointer','arrow');
drawnow('update');
drawnow('expose');

end
