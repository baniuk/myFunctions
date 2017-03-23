function out = fillwada(wada)
% zamalowuje wade dan¹ jako zamkniety profil

sw = size(wada);
for r=1:sw(1)       % po wszystkich rzedach
    tmp = wada(r,:);
    d = diff([tmp 1]);
    x = find(tmp==1);
    xs = find(tmp==1 & d==-1);
    if ~isempty(x)
        tmp(xs(1):x(end)) = 1;
    end
    wada(r,:) = tmp;
end
out = wada;