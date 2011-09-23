function groundswell()

% This is groundswell, a function for browsing multi-channel 
% electrophysiology data.

% make the groundswell MVC triad.
gsmm=Groundswell_main_model();
gsmv=Groundswell_main_view(gsmm);
gsmc=Groundswell_main_controller(gsmm,gsmv);
gsmv.register_controller(gsmc);
