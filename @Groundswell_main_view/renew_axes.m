function renew_axes(gsmv)

% called when the number of signals has changed, and the number of axes 
% needs to be changed to reflect this
% we assume all the gsmv data-related instance vars are up-to-date and 
% consistemt

% get instance vars we need
axes_hs=gsmv.axes_hs;
colors=gsmv.colors;
t=gsmv.model.t;
data=gsmv.model.data;
names=gsmv.model.names;
units=gsmv.model.units;

% get dims
[n_t,n_signals,n_sweeps]=size(data);
tl=[t(1) t(end)];

% delete any axes that currently exist
delete(axes_hs);

% make new axes
axes_hs=zeros(n_signals,1);
for i=1:n_signals
  tag=sprintf('axes_hs(%d)',i);
  axes_hs(i)=axes('Parent',gsmv.fig_h,...
                  'Tag',tag,...
                  'Units','pixels',...
                  'Box','on',...
                  'Layer','Top',...
                  'visible','off',...
                  'color','w',...
                  'ButtonDownFcn',...
                    @(src,evt)(gsmv.draw_zoom_limits('start')));
  if i<n_signals
    set(gca,'XTickLabel',{});
  else
    xlabel('Time (s)','tag','x_axis_label')
  end
end

% store the axes in the object
gsmv.axes_hs=axes_hs;

% put dummy signals in the axes
y_label_h=zeros(n_signals,1);
for i=1:n_signals
  set(axes_hs(i),'XLim',tl);
  data_this=reshape(data(:,i,:),[n_t n_sweeps]);
  y_min=min(min(data_this));  y_max=max(max(data_this));
  y_mid=(y_min+y_max)/2;  y_radius=(y_max-y_min)/2;
  if y_radius==0
    y_radius=1;
  end
  y_lo=y_mid-1.1*y_radius;  y_hi=y_mid+1.1*y_radius;
  set(axes_hs(i),'YLim',[y_lo y_hi]);
  set(gsmv.fig_h,'currentaxes',axes_hs(i));
  if isempty(units{i})
    label_str=names{i};
  else
    label_str=sprintf('%s (%s)',names{i},units{i});
  end
  y_label_h(i)=ylabel(label_str,...
                      'interpreter','none',...
                      'tag','y_axis_label',...
                      'verticalalignment','baseline',...
                      'units','pixels',...
                      'buttondownfcn',@(src,evt)(gsmv.controller.handle_axes_selection(src)));
  n_sweeps=size(data_this,2);
  for j=1:n_sweeps
    line('Parent',axes_hs(i),...
         'XData',tl,...
         'YData',zeros(size(tl)),...
         'Color',colors(i,:),...
         'Tag','trace',...
         'visible','off');
  end
end
drawnow;

% nothing is selected, since everything is new
gsmv.i_selected=zeros(0,1);

% set to subsampling-related instance vars to "undefined"
gsmv.r=1;
gsmv.t_sub=[];
gsmv.data_sub_min=[];
gsmv.data_sub_max=[];
