function handle_fps_edit(self)

new_fps_string=get(self.FPS_edit_h,'String');
new_fps=str2double(new_fps_string);
if isfinite(new_fps) && (new_fps>0)
  self.model.fs=new_fps;
end
if isfinite(self.model.fs)
  FPS_edit_string=sprintf('%6.2f',self.model.fs);
else
  FPS_edit_string='   ?  ';
end  
set(self.FPS_edit_h,'String',FPS_edit_string);

end
