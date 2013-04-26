function load_rois_from_rpb(self,full_filename)

%
% load in the ROI data from the file, w/ error checking
%

% open the file
%full_filename=strcat(pathname,filename);
[~,basename,ext]=fileparts(full_filename);
filename=[basename ext];
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

% put the new rois in the model
self.model.set_roi(borders,labels);

% notify the view
self.view.all_new_rois();

% modify self as needed
n_rois=self.model.n_rois;
self.card_birth_roi_next=n_rois+1;

end
