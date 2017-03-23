function pow = fillpolyC(vert,edges,maxx)
% wype�nie powierzchni� zdefin iowan� przez vert i edges skanuj�c obszar
% 0:maxx(1) 0:maxx(2). Jesli powierzchnia znajdzie si� w tym obszarze to
% zostanie wype�niona 1, reszta zerami
% kompatybilne z fillpoly, 



licznik = 1;
for a=1:length(edges)
    out(licznik,:) = vert(edges(a,1),:);
    out(licznik+1,:) = vert(edges(a,2),:);
    licznik = licznik + 2;
end

x = out(:,1)';
y = out(:,2)';

pow = isinsideC(x,y,maxx(1),maxx(2));
pow = reshape(pow,maxx(2),maxx(1));

