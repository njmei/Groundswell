classdef View < handle

% This is View, a class to represent the main window of
% the groundswell application.

  properties
    controller=[];
    model=[];
    
    %n_chan=[];
    
    tl_view=[];
    
    r=1;
    t_sub=[];
    data_sub_min=[];
    data_sub_max=[];
    
    i_selected=zeros(1,0);  % row vector

    fig_h=[];
    axes_hs=[];
    
    colors=[];
    x_units='time_s';
    
    %filename='';
    
    % keep handles for all the widgets
    file_menu_h
    open_menu_h
    import_menu_h
    add_synced_data_menu_item_h
    add_synced_data_ft_menu_item_h
    %add_presynched_traces_menu_item_h
    close_menu_h
    save_menu_h
    save_as_menu_h
    quit_menu_h

    edit_menu_h
    select_all_menu_h
    select_none_menu_h
    invert_selection_menu_h

    % the x-axis menu
    x_axis_menu_h
    time_ms_menu_h
    time_s_menu_h
    time_min_menu_h
    time_hr_menu_h
    edit_t_bounds_menu_h
    % the y-axis menu
    y_axis_menu_h
    edit_y_bounds_menu_h
    optimize_selected_y_menu_h
    optimize_all_y_menu_h
    % the mutation menu
    mutation_menu_h
    change_fs_menu_h
    center_menu_h
    rectify_menu_h
    dx_over_x_menu_h
    % the analysis menu
    analysis_menu_h
    power_spectrum_menu_h
    spectrogram_menu_h
    coherency_menu_h
    coherency_at_f_probe_menu_h
    coherogram_menu_h
    transfer_function_menu_h
    play_as_audio_menu_h
    count_ttl_edges_menu_h
    % scroll buttons
    to_start_button_h
    page_left_button_h
    step_left_button_h
    step_right_button_h
    page_right_button_h
    to_end_button_h
    % zoom buttons
    zoom_way_out_button_h
    zoom_out_button_h
    zoom_in_button_h
  end  % properties
  
  methods
    function self=View(controller)      
      self.controller=controller;
      self.model=[];
      
      % get the screen size so we can position the figure window
      root_units=get(0,'Units');
      set(0,'Units','pixels');
      screen_dims=get(0,'ScreenSize');
      screen_width=screen_dims(3);
      screen_height=screen_dims(4); 
      set(0,'Units',root_units);



      %
      % spec out the layout of the figure
      %

      % layout of the figure on the screen
      screen_left_pad_size=60;
      screen_right_pad_size=60;
      screen_top_pad_size=60;
      screen_bottom_pad_size=60;

      % the figure
      figure_width=screen_width-screen_left_pad_size-screen_right_pad_size;
      figure_height=screen_height-screen_top_pad_size-screen_bottom_pad_size;

      % pick the figure BG color based on the platform
      % except that for now, all platforms are the same
      %clr=0.8*ones(1,3);  % gray
      
      %
      % make the figure
      %
      self.fig_h = ...
        figure('Tag','groundswell_figure_h',...
               'Position',[screen_left_pad_size,...
                           screen_bottom_pad_size,...
                           figure_width,figure_height],...
               'Name','Groundswell',...
               'NumberTitle','off',...
               'Resize','off',...
               'MenuBar','none',...
               'PaperPositionMode','auto',...
               'Renderer','zbuffer',...
               'WindowKeyPressFcn', ...
                 @(src,event)(controller.handle_key_press(event)),...
               'WindowKeyReleaseFcn', ...
                 @(src,event)(controller.handle_key_release(event)),...               
               'ResizeFcn',@(src,event)(self.resize()),...
               'color',get(0,'defaultUicontrolBackgroundColor'), ...
               'CloseRequestFcn',@(src,event)(controller.quit()), ...
               'Resize','on');
            
      % Want to know when we get/lose focus, so have to do some hacking.
      drawnow('update');
      drawnow('expose');
      if ismac
        fpj=get(handle(self.fig_h),'JavaFrame');
        jw=fpj.fHG1Client.getWindow;
        jcb=handle(jw,'CallbackProperties');
        set(jcb,'WindowGainedFocusCallback', ...
            @(src,event)(controller.handle_focus_gained()));
        %set(jcb,'WindowLostFocusCallback', ...
        %    @(src,event)(controller.handle_focus_lost()));
        clear fpj jw jcb;
      end  



      %
      % add some menus
      %

      % the file menu
      self.file_menu_h=...
        uimenu(self.fig_h,...
               'Tag','file_menu_h',...
               'Label','File');
      self.open_menu_h=...
        uimenu(self.file_menu_h,...
               'Label','Open...',...
               'Accelerator','o',...
               'Tag','open_menu_h');
      self.import_menu_h=...
        uimenu(self.file_menu_h,...
               'Label','Import...',...
               'Accelerator','i',...
               'Tag','import_menu_h');
      self.close_menu_h=...
        uimenu(self.file_menu_h,...
               'enable','off', ...
               'Label','Close',...
               'Tag','close_menu_h');
      self.add_synced_data_menu_item_h=...
        uimenu(self.file_menu_h,...
               'Separator','on',...
               'enable','off', ...
               'Label','Add Synced Data...',...
               'Tag','add_synced_data_menu_item_h');
      self.add_synced_data_ft_menu_item_h=...
        uimenu(self.file_menu_h,...
               'enable','off', ...
               'Label','Add Synced Data (FT)...',...
               'Tag','add_synced_data_ft_menu_item_h');
%       self.add_presynched_traces_menu_item_h=...
%         uimenu(self.file_menu_h,...
%                'enable','off', ...
%                'Label','Add Pre-synched Traces...',...
%                'Tag','add_presynched_traces_menu_item_h');
      self.save_menu_h=...
        uimenu(self.file_menu_h,...
               'enable','off', ...
               'Separator','on',...
               'Label','Save',...
               'Accelerator','s',...
               'Tag','save_menu_h');
      self.save_as_menu_h=...
        uimenu(self.file_menu_h,...
               'enable','off', ...
               'Label','Save As...',...
               'Tag','save_as_menu_h');
      % uimenu(file_menu_h,...
      %        'Separator','on',...
      %        'Label','Print Preview...',...
      %        'Tag','print_preview_menu_h',...
      %        'Callback',@(src,event)(self.callback()));
      % uimenu(file_menu_h,...
      %        'Label','Print...',...
      %        'Tag','print_menu_h',...
      %        'Accelerator','p',...
      %        'Callback',@(src,event)(self.callback()));
      self.quit_menu_h=...
        uimenu(self.file_menu_h,...
               'Separator','on',...
               'Label','Quit',...
               'Accelerator','q',...
               'Tag','quit_menu_h');

      % The Edit menu
      self.edit_menu_h= ...
        uimenu(self.fig_h,...
               'Label','Edit');
      self.select_all_menu_h= ...
        uimenu(self.edit_menu_h,...
               'Label','Select All',...
               'Accelerator','a',...
               'enable','off',...
               'Callback', ...
                 @(~,~)(controller.select_all()));            
      self.select_none_menu_h= ...
        uimenu(self.edit_menu_h,...
               'Label','Select None',...
               'enable','off',...
               'Callback', ...
                 @(~,~)(controller.select_none()));            
      self.invert_selection_menu_h= ...
        uimenu(self.edit_menu_h,...
               'Label','Invert Selection',...
               'enable','off',...
               'Callback', ...
                 @(~,~)(controller.invert_selection()));            
             
      % the x-axis menu
      self.x_axis_menu_h=uimenu(self.fig_h,...
                          'Tag','x_axis_menu_h',...
                          'Label','X Axis');
      self.time_ms_menu_h=...
        uimenu(self.x_axis_menu_h,...
               'Tag','time_ms_menu_h',...
               'Label','Time (ms)',...
               'Checked','off',...
               'Enable','off');
      self.time_s_menu_h=...
        uimenu(self.x_axis_menu_h,...
               'Tag','time_s_menu_h',...
               'Label','Time (s)',...
               'Enable','off',...
               'Checked','on');
      self.time_min_menu_h=...
        uimenu(self.x_axis_menu_h,...
               'Tag','time_min_menu_h',...
               'Label','Time (min)',...
               'Checked','off',...
               'Enable','off');
      self.time_hr_menu_h=...
        uimenu(self.x_axis_menu_h,...
               'Tag','time_hr_menu_h',...
               'Label','Time (hr)',...
               'Checked','off',...
               'Enable','off');
      self.edit_t_bounds_menu_h=...
        uimenu(self.x_axis_menu_h,...
               'Separator','on',...
               'Tag','edit_t_bounds_menu_h',...
               'Label','Set Range...',...
               'Enable','off');

      % the y-axis menu
      self.y_axis_menu_h=uimenu(self.fig_h,...
                          'Tag','y_axis_menu_h',...
                          'Label','Y Axis');
      self.edit_y_bounds_menu_h=uimenu(self.y_axis_menu_h,...
                                  'Tag','edit_y_bounds_menu_h',...
                                  'Label','Set Range...',...
                                  'Enable','off',...
                                  'Callback',@(src,event)(gsmc.edit_y_bounds()));
      self.optimize_selected_y_menu_h=uimenu(self.y_axis_menu_h,...
                                        'Tag','optimize_selected_y_menu_h',...
                                        'Label','Optimize Range of Selected',...
                                        'Enable','off');
      self.optimize_all_y_menu_h=uimenu(self.y_axis_menu_h,...
                                   'Tag','optimize_all_y_menu_h',...
                                   'Label','Optimize Range of All',...
                                   'Enable','off');

      % the mutation menu
      self.mutation_menu_h=uimenu(self.fig_h,...
                             'Tag','mutation_menu_h',...
                             'Label','Mutation');
      self.change_fs_menu_h=...
        uimenu(self.mutation_menu_h,...
               'Label','Change Sampling Frequency...', ...
               'Enable','off');
      self.center_menu_h=uimenu(self.mutation_menu_h,...
                           'Tag','center_menu_h',...
                           'Label','Center',...
                           'Enable','off');
      self.rectify_menu_h=uimenu(self.mutation_menu_h,...
                           'Tag','rectify_menu_h',...
                           'Label','Rectify',...
                           'Enable','off');
      self.dx_over_x_menu_h=uimenu(self.mutation_menu_h,...
                                  'Tag','dx_over_x_menu_h',...
                                  'Label','Delta Over Mean (%)',...
                                  'Enable','off');

      % the analysis menu
      self.analysis_menu_h=uimenu(self.fig_h,...
                             'Tag','analysis_menu_h',...
                             'Label','Analysis');
      self.power_spectrum_menu_h=uimenu(self.analysis_menu_h,...
             'Label','Power Spectrum...',...
             'Enable','off',...
             'Tag','power_spectrum_menu_h');
      self.spectrogram_menu_h=uimenu(self.analysis_menu_h,...
             'Label','Spectrogram...',...
             'Enable','off',...
             'Tag','spectrogram_menu_h');
      self.coherency_menu_h=uimenu(self.analysis_menu_h,...
             'Label','Coherency...',...
             'Enable','off',...
             'Tag','coherency_menu_h');
      self.coherency_at_f_probe_menu_h=uimenu(self.analysis_menu_h,...
             'Label','Coherency at One Frequency...',...
             'Enable','off');
      self.coherogram_menu_h=uimenu(self.analysis_menu_h,...
             'Label','Coherogram...',...
             'Enable','off',...
             'Tag','coherogram_menu_h');
      self.transfer_function_menu_h=uimenu(self.analysis_menu_h,...
             'Label','Transfer Function...',...
             'Enable','off',...
             'Tag','transfer_function_menu_h');
      self.play_as_audio_menu_h=uimenu(self.analysis_menu_h,...
                                       'Label','Play as Audio',...
                                       'Visible','on',...
                                       'Enable','off');
      self.count_ttl_edges_menu_h=uimenu(self.analysis_menu_h,...
                                         'Separator','on',...
                                         'Label','Count TTL Edges',...
                                         'Visible','on',...
                                         'Enable','off');



      %
      % add some buttons
      %
      % scroll buttons
      self.to_start_button_h = ...
        uicontrol('Parent',self.fig_h,...
                  'Style','pushbutton',...
                  'String','|<',...
                  'Enable','off',...
                  'Tag','to_start_button_h');
      self.page_left_button_h = ...
        uicontrol('Parent',self.fig_h,...
                  'Style','pushbutton',...
                  'String','<<',...
                  'Enable','off',...
                  'Tag','page_left_button_h');
      self.step_left_button_h = ...
        uicontrol('Parent',self.fig_h,...
                  'Style','pushbutton',...
                  'String','<',...
                  'Enable','off',...
                  'Tag','step_left_button_h');
      self.step_right_button_h = ...
        uicontrol('Parent',self.fig_h,...
                  'Style','pushbutton',...
                  'String','>',...
                  'Enable','off',...
                  'Tag','step_right_button_h');
      self.page_right_button_h = ...
        uicontrol('Parent',self.fig_h,...
                  'Style','pushbutton',...
                  'String','>>',...
                  'Enable','off',...
                  'Tag','page_right_button_h');
      self.to_end_button_h = ...
        uicontrol('Parent',self.fig_h,...
                  'Style','pushbutton',...
                  'String','>|',...
                  'Enable','off',...
                  'Tag','to_end_button_h');

      % zoom buttons
      self.zoom_way_out_button_h = ...
        uicontrol('Parent',self.fig_h,...
                  'Style','pushbutton',...
                  'String','--',...
                  'Enable','off',...
                  'Tag','zoom_way_out_button_h');
      self.zoom_out_button_h = ...
        uicontrol('Parent',self.fig_h,...
                  'Style','pushbutton',...
                  'String','-',...
                  'Enable','off',...
                  'Tag','zoom_out_button_h');
      self.zoom_in_button_h = ...
        uicontrol('Parent',self.fig_h,...
                  'Style','pushbutton',...
                  'String','+',...
                  'Enable','off',...
                  'Tag','zoom_in_button_h');

      % set up the instance variables that are non-trivial to init
      self.colors=groundswell.make_color_sequence();
      
      % register the callbacks
      self.set_hg_callbacks(controller);
    end  % constructor
    
  end  % methods

  methods (Access=private)
    set_hg_callbacks(self,controller);
  end  % methods
  
end  % classdef
