function center(gsmm,i_to_change)

% i_to_change can be a vector

% center the selected signals
n_t=size(gsmm.data,1);
for i=i_to_change
  gsmm.data(:,i,:)=gsmm.data(:,i,:)-...
                   repmat(mean(gsmm.data(:,i,:),1),[n_t 1 1]);
end

