function domena = FindDomainNumber(cp,fem)
% znajduje numer domeny w kt�rej jest punkt kontrolny cp
% punkt kontrolny jet punktem nale��cym do danej domeny, kt�ry jest
% okreslany w momencie modelawania geometrii. Jest to punkt wirtualny,
% czyli nie wyst�puje on w modelu.
% Funkcja zwraca numer domenz lub �� je�li punkt nie lez w adnzm elemencie
% siatki

% cp = [3.1;4.9];  % punkt kontrolny
el = get(fem.mesh,'el');
p = get(fem.mesh,'p');
% w el{3}.elem s� indeksy punkt�w z p dla kt�rych zdefiniowane sa tr�jk�ty

E = [1 2;
     2 3;
     3 1]; % tr�jk�t
% sprawdzam wszystkie tr�jk�ty
tr = size(el{3}.elem,2);
h = waitbar(0,'Please wait...');
domena = [];
for a=1:tr
    P = p(:,el{3}.elem(:,a))';
    ret = isInside(cp,P,E);
    waitbar(a/tr);
    if ret==1
        domena = el{3}.dom(a);
        break;
    end
end
close(h);
if isempty(domena)
    fprintf('Nie znaleziono\n');
else
    domena
end
