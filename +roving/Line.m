classdef Line

  properties
    x;
    y;
    width;
    color;
  end  % properties
  
  properties (Dependent=true)
  end
  
  methods
    function self=Line(x,y,width,color)
      self.x=x;
      self.y=y;
      self.width=width;
      self.color=color;
    end
        
    function h=draw_into_axes(self,axes_h)
      h=line('parent',axes_h, ...
             'xdata',self.x, ...
             'ydata',self.y, ...
             'linewidth',self.width, ...
             'color',self.color);
    end
    
  end  % methods

end  % classdef
