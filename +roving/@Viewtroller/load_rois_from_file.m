function load_rois_from_file(self)

% throw up the dialog box
[filename,pathname]=uigetfile('*.rpb','Load ROIs from File...');
if isnumeric(filename) || isnumeric(pathname)
  % this happens if user hits Cancel
  return;
end

% call the appropriate loader
self.load_rois_from_rpb(filename,pathname);
