function change_frame_rel(self,di)

% Get state variables.
indexed_data=self.indexed_data;
n_frames=size(indexed_data,3);
image_h = self.image_h;
frame_index_edit_h=self.frame_index_edit_h;
% Determine the new frame index.
frame_index=self.frame_index;
new_frame_index_raw=frame_index+di;
new_frame_index=min(max(new_frame_index_raw,1),n_frames);
% Change things to accord with the new frame index, assuming it's
% different from the current frame index.
if new_frame_index~=frame_index
  self.frame_index=new_frame_index;
  set(frame_index_edit_h,'String',sprintf('%d',new_frame_index));
  this_frame = indexed_data(:,:,new_frame_index);
  set(image_h,'CData',this_frame);
end

end
