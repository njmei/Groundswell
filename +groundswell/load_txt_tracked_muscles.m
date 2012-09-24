function [t,data,trace_name,units]=load_txt_tracked_muscles(filename)

data_fid = fopen(filename,'r');
first_line=fgetl(data_fid);
trace_name=textscan(first_line,'%s');
trace_name=trace_name{1}';
n_col=length(trace_name);
data_trans=fscanf(data_fid,'%f',[n_col inf]);
fclose(data_fid);
data=data_trans';
i_frame=data(:,1);
data=data(:,2:end);
n_t=length(i_frame);
t=nan(n_t,1);
trace_name=trace_name(2:end);
n_chan=size(data,2);
units=cell(1,n_chan);
for i=1:n_chan
  units{i}='pixels';
end

end

