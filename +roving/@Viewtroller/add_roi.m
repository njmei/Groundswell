function add_roi(self,this_line_h)

% how many rois currently?
n_rois_old=length(self.model.roi);

% calc the center-of-mass for this ROI
r_border=[get(this_line_h,'XData'); ...
          get(this_line_h,'YData')];
com=roving.border_com(r_border);

% figure out what the label for this ROI will be
i=self.card_birth_roi_next;
while 1
  tentative_label=roving.alphabetic_label_from_int(i);
  if ~self.label_in_use(tentative_label)
    label_this=tentative_label;
    break;
  end
  i=i+1;
end

% make the label for this ROI
this_label_h=...
  text('Parent',self.image_axes_h,...
       'Position',[com(1) com(2) 2],...
       'String',label_this,...
       'HorizontalAlignment','center',...
       'VerticalAlignment','middle',...
       'Color',[0 0 1],...
       'Tag','label_h',...
       'Clipping','on',...         
       'ButtonDownFcn',@(src,event)(self.handle_image_mousing()));

% % change roi_struct
% roi_struct(n_rois_old+1,1).roi_ids=this_roi_id;
% roi_struct(n_rois_old+1,1).border_h=this_line_h;
% roi_struct(n_rois_old+1,1).label_h=this_label_h;

% change the model
self.model.add_roi(r_border,label_this);

% % check that roi_struct is the right shape
% if ~all(size(roi_struct)==[n_rois_old+1 1])
%   error('roi_struct is the wrong shape');
% end

% commit the changes to the figure variables
self.card_birth_roi_next=self.card_birth_roi_next+1;
self.border_roi_h(end+1)=this_line_h;
self.label_roi_h(end+1)=this_label_h;
%self.roi_struct=roi_struct;

% select the just-created ROI
self.select_roi(n_rois_old+1);

% if this is the first ROI, need to do some stuff
if n_rois_old==0
  % need to set image erase mode to normal, since now there's something
  % other than the image in that image axes
  set(self.image_h,'EraseMode','normal');
  set(self.delete_all_rois_menu_h,'Enable','on');
  set(self.save_rois_to_file_menu_h,'Enable','on');
  set(self.hide_rois_menu_h,'Enable','on');
  self.set_hide_rois(false);
  set(self.select_button_h,'Enable','on');
  set(self.move_all_button_h,'Enable','on');
  set(self.export_to_tcs_menu_h,'Enable','on');  
end  

end
