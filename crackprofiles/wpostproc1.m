function out=wpostproc1(nazwa,F,wada)
% nowy postproc laczocy pliki w jedna struktutre
% Funkcja wchodzi w sklad oprogramowania do generacji wad. Na podstawie
% struktur cell zwroconych przez program i wyników obliczen zwroceonych
% prezez liczwady30 generuje strukture zawierajaca:
%   param   - cell
%   spec    - spektrogram
%   specw   - wzgledny spec
%   F       - wektor czestotliwosci
% Sk³adania:
% W10_40=wpostproc1(W10_40,F,W);
% W10_40=wpostproc1(W10_40,F,[]); W dobiera automatycznie
% wpostproc1(W10_40,F,[]); ta sama nazwa wyjscia co wejscia

sF=length(F);
if isstruct(nazwa)
    nazwa = nazwa.param;
end
c = nazwa;


if isempty(wada)
    swtmp = size(c{2});
    sw = swtmp(1);
    wada = 1:sw;
else
    sw=length(wada);
end


for f=1:sF
    for w=1:sw
        nazwaload = sprintf('%s_%d_%d.mat',nazwa{8},F(f),wada(w));
        data = open(nazwaload);
        data=data.m;
        m = real((data));
        tmp(w,f) = abs(m(1)+m(2));
      
    end
end


str = sprintf('%s.param = c;',nazwa{8});
str1 = sprintf('%s.spec = tmp;',nazwa{8});
str2 = sprintf('%s.specw = CreateWzgl(%s.spec);',nazwa{8},nazwa{8});
str3 = sprintf('%s.F = F;',nazwa{8});
eval(str);
eval(str1);
eval(str2);
eval(str3);
    
if nargout==1
    str=sprintf('out=%s;',nazwa{8});
    eval(str);
else
    assignin('base',nazwa{8},eval(nazwa{8}));
end

function y = CreateWzgl(data)
% zwraca wartosc wzgledna z macierzy [x y z], x - punkty; y - polozenie
% wadyl z - czestotliwosc
a=size(data);
    for i=1:a(1)
        wzgl(i,:)=(data(i,:)-data(1,:))./data(1,:);
    end;
y=wzgl;