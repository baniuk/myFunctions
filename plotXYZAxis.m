function plotXYZAxis(start,len,fontsize,LineWidth,names)
% ryzuje osie xyz o pocz¹tku start = [x,y,z] i d³ugoœci len. names
% definiuj¹ napisy przy osiach w kolejnoœci rysowania dziêki czemu mo¿na
% dowolnie je nazywaæ nie koniecznie zgodnie z prawdziwym uk³adem.
% len = 3;
% start = [14 0 0];
% LineWidth = 2;
% names = {'z','y','x'};
% fontsize = 10;

endx = start + [len 0 0];
endy = start + [0 len 0];
endz = start + [0 0 len];

hold on
% line([start(1) endx(1)],[start(2) endx(2)], [start(3) endx(3)],'Linewidth',LineWidth,'color','b');
% line([start(1) endy(1)],[start(2) endy(2)], [start(3) endy(3)],'Linewidth',LineWidth,'color','r');
% line([start(1) endz(1)],[start(2) endz(2)], [start(3) endz(3)],'Linewidth',LineWidth,'color','g');

arrow(start,endx,'Width',1,'Length',10)
arrow(start,endy,'Width',1,'Length',10)
arrow(start,endz,'Width',1,'Length',10)
hold off

text(endx(1),endx(2),endx(3),['\bf' names{1}],'fontsize',fontsize,'Horizontalalignment','center','VerticalAlignment','top')
text(endy(1),endy(2),endy(3),['\bf' names{2}],'fontsize',fontsize,'Horizontalalignment','center','VerticalAlignment','top')
text(endz(1)+0.3,endz(2),endz(3),['\bf' names{3}],'fontsize',fontsize,'Horizontalalignment','left','VerticalAlignment','top')