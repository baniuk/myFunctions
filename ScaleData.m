function out = ScaleData(in,scale)
% funkcja powiêksza dane 2D o wsó³czynnik x. Mo¿e czasami skalowaæ z ma³ym
% b³êdem wynikaj¹cym z zaokr¹glania
si = size(in);
xi = linspace(1,si(2),round(scale*si(2)));
yi = linspace(1,si(1),round(scale*si(1)));

[X,Y] = meshgrid(1:si(2),1:si(1));
[XI,YI] = meshgrid(yi,xi);
w = interp2(1:si(2),1:si(1),in,YI,XI,'cubic');
out = w';