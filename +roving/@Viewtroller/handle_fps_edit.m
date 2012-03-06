function handle_fps_edit(self)

new_fps_string=get(gcbo,'String');
new_fps=str2double(new_fps_string);
if (new_fps>0)
  self.model.fs=new_fps;
end
set(gcbo,'String',sprintf('%6.2f',self.model.fs));

end
