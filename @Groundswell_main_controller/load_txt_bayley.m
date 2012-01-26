function [t,data,trace_name]=load_txt_bayley(filename)

f_s=30;  % Hz
data_fid = fopen(filename,'r');
first_line=fgetl(data_fid);
trace_name=textscan(first_line,'%s');
trace_name=trace_name{1}';
n_col=length(trace_name);
data_trans=fscanf(data_fid,'%f',[n_col inf]);
data=data_trans';
i_frame=data(:,1);
data=data(:,2:end);
t=(i_frame-1)/f_s;
trace_name=trace_name(2:end);
fclose(data_fid);

end

