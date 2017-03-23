function out = ScaleData(in,scale)
% funkcja powi�ksza dane 2D o ws�czynnik x. Mo�e czasami skalowa� z ma�ym
% b��dem wynikaj�cym z zaokr�glania
si = size(in);
xi = linspace(1,si(2),round(scale*si(2)));
yi = linspace(1,si(1),round(scale*si(1)));

[X,Y] = meshgrid(1:si(2),1:si(1));
[XI,YI] = meshgrid(yi,xi);
w = interp2(1:si(2),1:si(1),in,YI,XI,'cubic');
out = w';