function draw_rect_roi(self,action)

persistent figure_h;
persistent image_axes_h;
persistent anchor;
persistent rect_h;
persistent square;

switch(action)
  case 'start'
    figure_h=self.figure_h;
    image_axes_h=self.image_axes_h;
    cp=get(image_axes_h,'CurrentPoint');
    point=cp(1,1:2); 
    anchor=point;
    square=strcmp(get(figure_h,'selectiontype'),'extend');
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
    w=(point(1)-anchor(1));
    h=(point(2)-anchor(2));
    if square
      s=max(abs(w),(h));
      w=sign(w)*s;
      h=sign(h)*s;
    end
    set(rect_h,...
        'XData',anchor(1)+[0 w w 0 0]);
    set(rect_h,...
        'YData',anchor(2)+[0 0 h h 0]);
  case 'stop'
    % change the move and buttonup calbacks
    set(figure_h,'WindowButtonMotionFcn',@(src,event)(self.update_pointer()));
    set(figure_h,'WindowButtonUpFcn',[]);
    % now do the stuff we'd do for a move also
    cp=get(image_axes_h,'CurrentPoint');
    point=cp(1,1:2); 
    w=(point(1)-anchor(1));
    h=(point(2)-anchor(2));
    if square
      s=max(abs(w),(h));
      w=sign(w)*s;
      h=sign(h)*s;
    end
    set(rect_h,...
        'XData',anchor(1)+[0 w w 0 0]);
    set(rect_h,...
        'YData',anchor(2)+[0 0 h h 0]);
    % clear the persistents
    figure_h=[];
    image_axes_h=[];
    % now add the roi to the list
    self.controller.add_roi_given_line_gh(rect_h);
end  % switch
