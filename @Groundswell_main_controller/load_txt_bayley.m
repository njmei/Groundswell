function [t,data,trace_name,units]=load_txt_bayley(filename,s)

% s is a scaling factor, in um/pixel
% units in the file are pixels, and we convert before returning

f_s=30;  % Hz
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
data=s*data;  % pixels->um
t=(i_frame-1)/f_s;
trace_name=trace_name(2:end);
n_chan=size(data,2);
units=cell(1,n_chan);
for i=1:n_chan
  units{i}='um';
end

end

