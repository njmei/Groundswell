file_name='sine_cosine.txt';
dt=0.001;  % s
T=10;
n_t=round(T/dt)+1;
t=dt*(0:(n_t-1))';
f0=5;  % Hz
x=sin(2*pi*f0*t);
y=cos(2*pi*f0*t);
data=[x y];

save(file_name,'data','-ascii');

