function pow = mFillPolyCoord(vert,edges,tab)
% Dla zadaych wsp�rz�dnych, sprawdza kt�ra z nich miesci si� wewn�trz powierzchni
% zdefiniowanej� przez vert i edges
% tab - tablica [Nx2] wsp�rz�dbych do przetestowania
% Zwraca te wsp�rz�dne kt�re si� mieszcz�.
% 
% P = [0 0;
%      10 0;
%      10 10;
%      0 10];
% E = [1 2;
%      2 3;
%      3 4;
%      4 1];
%  
%  plotFigure(P,E); % figura testowa
%  
%  xp = linspace(-1,11,5);
%  yp = linspace(-1,11,5);
%  
%  [X Y] = meshgrid(xp,yp);
%  X = reshape(X,[],1); Y = reshape(Y,[],1);
%  
%  Pp = [X Y];
%  pow = mFillPolyCoord(P,E,Pp);
%  hold on
% plot(pow(:,1),pow(:,2),'ro')
%  clear FillPolyCoord_debug
 
licznik = 1;
for a=1:length(edges)
    out(licznik,:) = vert(edges(a,1),:);
    out(licznik+1,:) = vert(edges(a,2),:);
    licznik = licznik + 2;
end

xv = out(:,1)';
yv = out(:,2)';
xp = tab(:,1)';
yp = tab(:,2)';

pow = FillPolyCoord(xp,yp,xv,yv)';
clear FillPolyCoord

