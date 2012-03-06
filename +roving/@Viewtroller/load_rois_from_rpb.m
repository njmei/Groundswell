function load_rois_from_rpb(self,filename,pathname)

%
% load in the ROI data from the file, w/ error checking
%

% open the file
full_filename=strcat(pathname,filename);
fid=fopen(full_filename,'r','ieee-be');
if (fid == -1)
  errordlg(sprintf('Unable to open file %s',filename),...
           'File Error');
  return;
end

% read the number of rois
[n_rois,count]=fread(fid,1,'uint32');
%n_rois
if (count ~= 1)
  errordlg(sprintf('Error loading ROIs from file %s',filename),...
           'File Error');
  fclose(fid);
  return;
end

% dimension cell arrays to hold the ROI labels and vertex lists
labels=cell(n_rois,1);
borders=cell(n_rois,1);

% for each ROI, read the label and the vertex list
for j=1:n_rois
  % the label
  [n_chars,count]=fread(fid,1,'uint32');
  if (count ~= 1)
    errordlg(sprintf('Error loading ROIs from file %s',filename),...
             'Show File Error');
    fclose(fid);
    return;
  end
  [temp,count]=fread(fid,[1 n_chars],'uchar');
  if (count ~= n_chars)
    errordlg(sprintf('Error loading ROIs from file %s',filename),...
             'Show File Error');
    fclose(fid);
    return;
  end
  labels{j}=char(temp);
  % the vertex list
  [n_vertices,count]=fread(fid,1,'uint32');
  if (count ~= 1)
    errordlg(sprintf('Error loading ROIs from file %s',filename),...
             'Show File Error');
    fclose(fid);
    return;
  end
  %this_border=zeros(2,n_vertices);
  [this_border,count]=fread(fid,[2 n_vertices],'float32');
  %this_border
  if (count ~= 2*n_vertices)
    errordlg(sprintf('Error loading ROIs from file %s',filename),...
             'Show File Error');
    fclose(fid);
    return;
  end
  borders{j}=this_border;
end

% close the file
fclose(fid);

% clear the old roi borders & labels
% .roi_struct
if self.border_roi_h  % if nonempty
  delete(self.border_roi_h);
  delete(self.label_roi_h);
end

% put the new rois in the model
self.model.set_roi(borders,labels);

% generate graphics objects for the new ROIs
label_h=zeros(n_rois,1);
border_h=zeros(n_rois,1);
for j=1:n_rois
  border_this=borders{j};
  com=roving.border_com(border_this);
  label_h(j)=...
    text('Parent',self.image_axes_h,...
         'Position',[com(1) com(2) 1],...
         'String',labels{j},...
         'HorizontalAlignment','center',...
         'VerticalAlignment','middle',...
         'Color',[0 0 1],...
         'Tag','label_h',...
         'Clipping','on',...
         'ButtonDownFcn',@(~,~)(self.handle_image_mousing()) );
  border_h(j)=...
    line('Parent',self.image_axes_h,...
         'Color',[0 0 1],...
         'Tag','border_h',...
         'XData',border_this(1,:),...
         'YData',border_this(2,:),...
         'ZData',ones([1 size(border_this,2)]),...
         'ButtonDownFcn',@(~,~)(self.handle_image_mousing()) );
end
   
% write the new ROI into the figure state
self.selected_roi_index=zeros(0,1);
self.card_birth_roi_next=n_rois+1;
self.border_roi_h=border_h;
self.label_roi_h=label_h;
% self.roi_struct=struct('roi_ids',roi_ids, ...
%                        'border_h',border_h, ...
%                        'label_h',label_h);
                     
% modify ancillary crap
if n_rois>0
  % need to set image erase mode to normal, since now there's something
  % other than the image in that image axes
  set(self.image_h,'EraseMode','normal');
  set(self.delete_roi_menu_h,'Enable','off');
  set(self.delete_all_rois_menu_h,'Enable','on');
  set(self.save_rois_to_file_menu_h,'Enable','on');
  set(self.hide_rois_menu_h,'Enable','on');
  self.set_hide_rois(false);
  set(self.select_button_h,'Enable','on');
  set(self.move_all_button_h,'Enable','on');
  set(self.export_to_tcs_menu_h,'Enable','on');
end  
