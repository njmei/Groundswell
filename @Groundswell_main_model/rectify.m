function rectify(gsmm,i_to_change)

% i_to_change can be a vector

% rectify the selected signals
for i=i_to_change
  gsmm.data(:,i,:)=abs(gsmm.data(:,i,:));
end
