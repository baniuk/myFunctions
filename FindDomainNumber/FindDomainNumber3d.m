function out = FindDomainNumber3d(cp,fem)
% znajduje numer domeny w kt�rej jest punkt kontrolny cp
% punkt kontrolny jet punktem nale��cym do danej domeny, kt�ry jest
% okreslany w momencie modelawania geometrii. Jest to punkt wirtualny,
% czyli nie wyst�puje on w modelu.
% Funkcja zwraca numer domenz lub �� je�li punkt nie lez w adnzm elemencie
% siatki

% wersja dla 3D - mesh Tetrahedron
% cp punkty testowe [Px3]

el = get(fem.mesh,'el');
p = get(fem.mesh,'p');
% w el{4}.elem s� indeksy punkt�w z p dla kt�rych zdefiniowane sa
% tetrahedrony

% sprawdzam wszystkie tetra
% http://steve.hollasch.net/cgindex/geometry/ptintet.html
tr = size(el{4}.elem,2);
h = waitbar(0,'Please wait...');
d = zeros(1,size(cp,1));
licz = 1;
for cpp=1:size(cp,1)
    for a=1:tr
        P = p(:,el{4}.elem(:,a));   % punkty w kolumnach
        D0 = [P' [1 1 1 1]'];
        D1 = D0; D1(1,1:3) = cp;
        D2 = D0; D2(2,1:3) = cp;
        D3 = D0; D3(3,1:3) = cp;
        D4 = D0; D4(4,1:3) = cp;
        dD0 = det(D0);
        dD1 = det(D1);
        dD2 = det(D2);
        dD3 = det(D3);
        dD4 = det(D4);

        if(dD0==0)
            fprintf('Degenerated mesh\n');
            break;
        end
        zD = sign([dD1 dD2 dD3 dD4]);
        zD0 = sign(dD0);
        zD(zD==0) = []; % je�li co� lezy na �ciance
        if(all(zD==zD0))
            d(cpp) = a;
            break;
        end
        waitbar(licz/(tr*size(cp,1)));
        licz = licz+1;
    end
end
close(h);
for a=1:length(d)
    out(a) = find(d==a);
end

