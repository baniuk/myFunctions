function out = rescaleimage(im,siz)
% przeskalowuje obrazek do rozmiaru siz [row col]

si = size(im);
X = linspace(1,si(2),si(2));
Y = linspace(1,si(1),si(1));
[XX,YY] = meshgrid(X,Y);

Xi = linspace(1,si(2),siz(2));
Yi = linspace(1,si(1),siz(1));
[Xii,Yii] = meshgrid(Xi,Yi);

out = interp2(XX,YY,im,Xii,Yii,'cubic');