function handle_key(self,event)

% handle the key
if strcmp(event.Character,',') || strcmp(event.Character,'<')
  self.change_frame_rel(-1);
elseif strcmp(event.Character,'.') || strcmp(event.Character,'>')
  self.change_frame_rel(+1);
elseif strcmp(event.Character,'p')    
  self.play(+1);
elseif strcmp(event.Key,'delete') || strcmp(event.Key,'backspace')
  self.delete_selected_roi();  
end

end
