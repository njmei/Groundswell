classdef Text_overlay

  properties
    x;
    y;
    string;
    color;
  end  % properties
  
  properties (Dependent=true)
  end
  
  methods
    function self=Text_overlay(x,y,string,color)
      self.x=x;
      self.y=y;
      self.string=string;
      self.color=color;
    end
            
    function h=draw_into_axes(self,axes_h)
      h=text('parent',axes_h,...
             'position',[self.x self.y], ...
             'string',self.string, ...
             'color',self.color);
    end
    
  end  % methods

end  % classdef
