function handle_image_mousing(self)

% get the current mode
mode=self.mode;
% switch on the current roi mode appropriately
switch(mode)
  case 'rect_roi'
    self.draw_rect_roi('start');
  case 'elliptic_roi'
    self.draw_elliptic_roi('start');
  case 'select'
    roi_index=self.find_roi(gcbo);
    if ~isempty(roi_index)
      if roi_index==self.selected_roi_index
        self.unselect_selected_roi();
      else
        self.select_roi(roi_index);
        self.move_roi('start',roi_index);
      end
    end
  case 'zoom'
    sel_type=get(self.figure_h,'SelectionType');
    switch sel_type
      case 'extend'
        self.zoom_out();
      case 'alternate'
        self.zoom_out();
      case 'open'
        self.zoom_out();
      otherwise
        self.draw_zoom_rect('start');
    end
  case 'move_all'
    self.move_all('start');
end

end
