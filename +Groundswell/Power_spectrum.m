classdef Power_spectrum < handle
% This is a class to represent a window showing a power spectrum in
% Groundswell.  It is controller, model, and view all rolled into one.
  
properties
  % HG handles
  fig;
  plot;
  line;
  line_ci1;
  line_ci2;
  ylabel;
  title;
  menu_y_axis;
  item_y_power;
  item_y_amplitude;
  item_y_linear;
  item_y_log10;
  item_y_raw;
  item_y_normed;
  %item_y_wn_unit;
  
  % model stuff
  f;
  S_log;
  S_log_ci;
  name;
  units;
  F_keep;
  f_res_diam;
  N_fft;
  mode_pa='power';  % power, amplitude
  mode_ll='linear';  % linear, log10
  mode_rn='raw';  % raw, normed
end  % properties

methods
  function self=Power_spectrum(f,S_log,S_log_ci,name,units, ...
                               F_keep,f_res_diam,N_fft)
    % define colors
    blue=[0 0 1];
    light_blue=[0.8 0.8 1];

    % make HG objects
    self.fig=figure('name',sprintf('Spectrum of %s',name), ...
                    'color','w');
    self.plot=axes('parent',self.fig,...
                   'layer','top',...
                   'box','on');
    self.line_ci1=line('parent',self.plot,...
                       'xdata',[],...
                       'ydata',[],...
                       'color',light_blue);  %#ok
    self.line_ci2=line('parent',self.plot,...
                       'xdata',[],...
                       'ydata',[],...
                       'color',light_blue);  %#ok
    self.line=line('parent',self.plot,...
                   'xdata',[],...
                   'ydata',[],...
                   'color',blue);  %#ok
    self.ylabel=ylabel(self.plot,'');  %#ok
    self.title=title(self.plot,...
                     sprintf('Spectrum of %s',name), ...
                     'interpreter','none');  %#ok
    text(1,1.005, ...
         sprintf('f_res: %0.3f Hz',f_res_diam), ...
                 'units','normalized', ...
                 'horizontalalignment','right', ...
                 'verticalalignment','bottom', ...
                 'interpreter','none');
    text(0,1.005, ...
         sprintf('N_fft: %d',N_fft), ...
                 'units','normalized', ...
                 'horizontalalignment','left', ...
                 'verticalalignment','bottom', ...
                 'interpreter','none');
       
    % add custom menus
    self.menu_y_axis=uimenu(self.fig,'label','Y axis');
    self.item_y_power= ...
      uimenu(self.menu_y_axis, ...
             'label','Power', ...
             'Callback',@(~,~)(self.set_mode_pa('power')));
    self.item_y_amplitude= ...
      uimenu(self.menu_y_axis, ...
             'label','Amplitude', ...
             'Callback',@(~,~)(self.set_mode_pa('amplitude')));
    self.item_y_linear= ...
      uimenu(self.menu_y_axis, ...
             'label','Linear', ...
             'separator','on', ...
             'Callback',@(~,~)(self.set_mode_ll('linear')));
    self.item_y_log10= ...
      uimenu(self.menu_y_axis, ...
             'label','Logarithmic', ...
             'Callback',@(~,~)(self.set_mode_ll('log10')));
    self.item_y_raw= ...
      uimenu(self.menu_y_axis, ...
             'label','Raw', ...
             'separator','on', ...
             'Callback',@(~,~)(self.set_mode_rn('raw')));
    self.item_y_normed= ...
      uimenu(self.menu_y_axis, ...
             'label','Z-scored', ...
             'Callback',@(~,~)(self.set_mode_rn('normed')));
%     self.item_y_wn_unit= ...
%       uimenu(self.menu_y_axis, ...
%              'label','WN is unit density', ...
%              'Callback',@(~,~)(self.set_mode_rn('wn_unit')));
     
%     % default modes
%     self.mode_pa='power';
%     self.mode_ll='linear';
%     self.mode_rn='raw';
    
    % store stuff
    self.f=f;
    self.S_log=S_log;
    self.S_log_ci=S_log_ci;
    self.name=name;
    self.units=units;
    self.F_keep=F_keep;
    self.f_res_diam=f_res_diam;
    self.N_fft=N_fft;
     
    % initial sync of the figure
    self.sync_view()
  end  % constructor  

  function set.mode_pa(self,mode_new)
    self.mode_pa=mode_new;
    self.sync_view();    
  end

  function set.mode_ll(self,mode_new)
    self.mode_ll=mode_new;
    self.sync_view();    
  end

  function set.mode_rn(self,mode_new)
    self.mode_rn=mode_new;
    self.sync_view();    
  end

  % this exists only because "self.set_mode_pa(whatever)" can be used
  % inside an anon function, but "self.mode_pa=whatever" can't
  function set_mode_pa(self,mode_new)
    self.mode_pa=mode_new;
  end

  function set_mode_ll(self,mode_new)
    self.mode_ll=mode_new;
  end

  function set_mode_rn(self,mode_new)
    self.mode_rn=mode_new;
  end

  function sync_view(self)
    % calculate y, y CI
    f=self.f;
    y=self.S_log;
    y_ci=self.S_log_ci;
    if strcmp(self.mode_rn,'normed')
      df=(f(end)-f(1))/(length(f)-1);
      S=exp(self.S_log);
      S_int=df*sum(S);
      offset=-log(S_int);
        % adding this in log-space == dividing by S_int
      y=y+offset;
      y_ci=y_ci+offset;
    end
    if strcmp(self.mode_pa,'amplitude')
      y=0.5*y;
      y_ci=0.5*y_ci;
    end
    if strcmp(self.mode_ll,'linear')
      y=exp(y);
      y_ci=exp(y_ci);
    elseif strcmp(self.mode_ll,'log10')
      % convert nat log to log10
      y=y./log(10);
      y_ci=y_ci./log(10);
    end

    % figure out y axis limits
    y_max=max(max(y),max(max(y_ci)));
    switch self.mode_ll
      case 'linear'
        yl=[0 1.05*y_max];
      case 'log10'
        y_min=min(min(y),min(min(y_ci)));
        y_mid=(y_max+y_min)/2;
        y_radius=(y_max-y_min)/2;
        yl=y_mid+1.05*y_radius*[-1 +1];
    end
    
    % build the units string for the spectrum
    units=self.units;
    if isempty(units)
      units_str='?';
    else
      units_str=units;
    end
    if strcmp(self.mode_rn,'normed')
      units_str='1';
    else
      % raw
      if strcmp(self.mode_pa,'power')
        units_str=[units_str '^2'];
      end
    end
    units_str=[units_str '/Hz'];
    if strcmp(self.mode_pa,'amplitude')
      units_str=[units_str '^{0.5}'];
    end
    
    % build y-axis label
    if strcmp(self.mode_pa,'power') && strcmp(self.mode_ll,'linear')
      y_str=sprintf('Power density (%s)',units_str);
    elseif strcmp(self.mode_pa,'amplitude') && strcmp(self.mode_ll,'linear')
      y_str=sprintf('Amplitude density (%s)',units_str);
    elseif strcmp(self.mode_pa,'power') && strcmp(self.mode_ll,'log10')
      y_str=sprintf('log_{10} power density (%s)',units_str);
    elseif strcmp(self.mode_pa,'amplitude') && strcmp(self.mode_ll,'log10')
      y_str=sprintf('log_{10} amplitude density (%s)',units_str);
    end
    
    % sync each plot object
    set(self.line,'xdata',f,'ydata',y);
    set(self.line_ci1,'xdata',f,'ydata',y_ci(:,1));
    set(self.line_ci2,'xdata',f,'ydata',y_ci(:,2));
    set(self.plot,'xlim',[0 self.F_keep]);
    set(self.plot,'ylim',yl);
    set(self.ylabel,'string',y_str);
    
    % sync the checkboxes to the model mode variables
    switch self.mode_pa
      case 'power'
        set(self.item_y_power,'checked','on');
        set(self.item_y_amplitude,'checked','off');
      case 'amplitude'
        set(self.item_y_power,'checked','off');
        set(self.item_y_amplitude,'checked','on');
    end
    switch self.mode_ll
      case 'linear'
        set(self.item_y_linear,'checked','on');
        set(self.item_y_log10,'checked','off');
      case 'log10'
        set(self.item_y_linear,'checked','off');
        set(self.item_y_log10,'checked','on');
    end
    switch self.mode_rn
      case 'raw'
        set(self.item_y_raw,'checked','on');
        set(self.item_y_normed,'checked','off');
      case 'normed'
        set(self.item_y_raw,'checked','off');
        set(self.item_y_normed,'checked','on');
    end
    
  end
  
end  % methods
    
end  % classdef
