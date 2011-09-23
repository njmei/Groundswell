function tl=get_tl(gsmm)

t=gsmm.t;
if isempty(t)
  tl=[];
else
  tl=[t(1) t(end)];
end
