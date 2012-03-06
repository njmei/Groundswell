function quit(self)

self.stop_playing();
pause(0.01);
delete(self.figure_h);
self.figure_h=[];

end
