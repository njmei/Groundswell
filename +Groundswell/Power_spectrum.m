classdef Power_spectrum < handle
% This is a class to represent a window showing a power spectrum in
% Groundswell.  It is controller, model, and view all rolled into one.
  
properties
  fig_hg;
  f;
  S_log;
  S_log_ci;
  name;
  units;
  F_keep;
  f_res_diam;
  N_fft;
end  % properties

methods
  function self=Power_spectrum(f,S_log,S_log_ci,name,units, ...
                               F_keep,f_res_diam,N_fft)
    % untransform spectrum, ci
    S=exp(S_log);
    S_ci=exp(S_log_ci);
    
    % make figure
    blue=[0 0 1];
    light_blue=[0.8 0.8 1];
    label=name;
    self.fig_hg=...
      figure('name',sprintf('Power spectrum of %s',label), ...
             'color','w');
    axes;
    line(f,S_ci(:,1),'color',light_blue);
    line(f,S_ci(:,2),'color',light_blue);
    line(f,S,'color',blue);
    xlim([0 F_keep]);
    if isempty(units)
      ylabel('Power density (?^2/Hz)');
    else
      ylabel(sprintf('Power density (%s^2/Hz)',units));
    end
    title(sprintf('Power spectrum of %s',label),'interpreter','none');
    box on;
    text(1,1.005,...
         sprintf('f_res: %0.3f Hz\nN_fft: %d',f_res_diam,N_fft),...
         'units','normalized',...
         'horizontalalignment','right',...
         'verticalalignment','bottom',...
         'interpreter','none');
       
     % store stuff
     self.f=f;
     self.S_log=S_log;
     self.S_log_ci=S_log_ci;
     self.name=name;
     self.units=units;
     self.F_keep=F_keep;
     self.f_res_diam=f_res_diam;
     self.N_fft=N_fft;
  end  % constructor  
  
end  % methods
    
end  % classdef
