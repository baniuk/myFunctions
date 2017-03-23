function h = plotFigure(vert,edges,varargin)
% rysuje figur� zdefiniowan� jako macierz wierzcho�k�w [Nx2] oraz macierz po��cze� pomi�dzy nimi [Nx2]

% zmiana parametr�w obrazu
% l=findobj(h,'Type','Line')
% set(l(1),'linewidth',4)
% set(l(1),'MArker','v')
% ...

h = plot(vert(:,1),vert(:,2),varargin{:});
grid on; hold on    

for e=1:size(edges,1)
    p1 = vert(edges(e,1),:);
    p2 = vert(edges(e,2),:);
    X(e,:) = [p1(1) p2(1)];
    Y(e,:) = [p1(2) p2(2)];
end
X = reshape(X',numel(X),1);
Y = reshape(Y',numel(Y),1);
line(X,Y)
hold off