function out=calcfire(ilwe,nummfmf,mf,trn,rule,varargin)
% oblicza watosc na wyjsciu z regul, mf - ilosc mf przec przeciecie mf

si = size(trn);
tmp = mf;

if nargin<6
    for a=1:si(1)
        for we=1:ilwe
            licznik = 1;
            for m=1:nummfmf
                zzzz(we,m,a)=evalmf(trn(a,we),[tmp(we,licznik) tmp(we,licznik+1)],'gaussmf');
                licznik = licznik+2;
            end
        end
    end
else
    zzzz = varargin{1};
end

% fis=newfis('qfisg','sugeno','prod','probor','prod','max','wtaver'); % tylko do kompatybilnosci z fillrule
% fis = fillrule(fis,trn,tmp);

sr = size(rule);

% for a=1:sr(2)
%     rules(a,:)=fis.rule(a).antecedent;
% end

for a=1:si(1)
    for c=1:sr(1)
        for b=1:ilwe
            wect(b)=zzzz(b,rule(c,b),a);
        end
        wectout(c,a)=prod(wect);
    end
end

out = wectout;