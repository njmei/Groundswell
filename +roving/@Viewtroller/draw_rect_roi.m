function draw_rect_roi(self,action)

persistent figure_h;
persistent image_axes_h;
persistent anchor;
persistent rect_h;

switch(action)
  case 'start'
    figure_h=self.figure_h;
    image_axes_h=self.image_axes_h;
    cp=get(image_axes_h,'CurrentPoint');
    point=cp(1,1:2); 
    anchor=point;
    % create a new rectangle
    rect_h=...
      line('Parent',image_axes_h,...
           'Color',[1 0 0],...
           'Tag','border_h',...
           'XData',[anchor(1) anchor(1) point(1) point(1)  anchor(1)],...
           'YData',[anchor(2) point(2)  point(2) anchor(2) anchor(2)],...
           'ZData',[2 2 2 2 2],...
           'ButtonDownFcn',@(src,event)(self.handle_image_mousing()));
    % set the callbacks for the drag
    set(figure_h,'WindowButtonMotionFcn',...
                 @(src,event)(self.draw_rect_roi('move')));
    set(figure_h,'WindowButtonUpFcn',...
                 @(src,event)(self.draw_rect_roi('stop')));
  case 'move'
    cp=get(image_axes_h,'CurrentPoint');
    point=cp(1,1:2); 
    set(rect_h,...
        'XData',[anchor(1) anchor(1) point(1) point(1)  anchor(1)]);
    set(rect_h,...
        'YData',[anchor(2) point(2)  point(2) anchor(2) anchor(2)]);
  case 'stop'
    % change the move and buttonup calbacks
    set(figure_h,'WindowButtonMotionFcn',@(src,event)(self.update_pointer()));
    set(figure_h,'WindowButtonUpFcn',[]);
    % now do the stuff we'd do for a move also
    cp=get(image_axes_h,'CurrentPoint');
    point=cp(1,1:2); 
    set(rect_h,...
        'XData',[anchor(1) anchor(1) point(1) point(1)  anchor(1)]);
    set(rect_h,...
        'YData',[anchor(2) point(2)  point(2) anchor(2) anchor(2)]);
    % clear the persistents
    figure_h=[];
    image_axes_h=[];
    % now add the roi to the list
    self.add_roi(rect_h);
end  % switch






