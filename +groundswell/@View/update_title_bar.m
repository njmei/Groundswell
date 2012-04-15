function update_title_bar(self)

[~,base_name,ext]=fileparts(self.model.filename_abs);
filename_local=[base_name ext];
title_string='Groundswell';
if ~isempty(self.model.filename_abs)
  title_string=[title_string ' - ' filename_local];
  if ~self.model.saved
    title_string=[title_string '*'];
  end
end
set(self.fig_h,'name',title_string);

end
