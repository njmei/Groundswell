function play(self,direction)

% get handles of figs
figure_h=self.figure_h;

% play the movie
indexed_data=self.indexed_data;
start_frame_index=self.frame_index;
n_frames=size(indexed_data,3);
frame_index_edit_h=findobj(figure_h,'Tag','frame_index_edit_h');
image_h = self.image_h;
n_rois=length(self.model.roi);
if (n_rois>0)
  set(image_h,'EraseMode','none');
end
fps=self.model.fs;
spf=1/fps;
if (direction>0)
  frame_sequence=start_frame_index:n_frames;
else
  frame_sequence=start_frame_index:-1:1;
end
self.stop_button_hit=false;
for frame_index=frame_sequence
  tic;
  this_frame = indexed_data(:,:,frame_index);
  set(image_h,'CData',this_frame);
  set(frame_index_edit_h,'String',num2str(frame_index));
  drawnow;
  while (toc < spf)
  end
  if self.stop_button_hit
    break;
  end
end
self.stop_button_hit=false;
self.frame_index=frame_index;
if (n_rois>0)
  set(image_h,'EraseMode','normal');
end

