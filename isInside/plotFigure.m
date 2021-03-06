function h = plotFigure(vert,edges,varargin)
% rysuje figurę zdefiniowaną jako macierz wierzchołków [Nx2] oraz macierz połączeń pomiędzy nimi [Nx2]

% zmiana parametrów obrazu
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