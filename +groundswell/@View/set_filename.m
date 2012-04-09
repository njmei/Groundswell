function set_filename(self,filename)

if isempty(filename)
  title_string='Groundswell';
else
  title_string=sprintf('Groundswell - %s',filename);
end
set(self.fig_h,'name',title_string);

end
