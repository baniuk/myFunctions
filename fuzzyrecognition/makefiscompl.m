function [out,actout,compmf]=makefiscompl(ilwe,nummfmf,mf,trn)
% tworzy kompletnegi fisa
% we - ilosc wejsc
% nummf ilosc mf
% trn dane treningowe
% punkt przeciecia mf (0-1)
% mf ztruktura mf

tmp = mf;
% tmp wyjcie

fis=newfis('qfisg','sugeno','prod','probor','prod','max','wtaver');
for a=1:ilwe
    name=sprintf('we%d',a);
    fis=addvar(fis,'input',name,[min(min(trn)) max(max(trn(:,1:ilwe)))]);
end
fis=addvar(fis,'output','wy',[0 1]);
licznik=1;
for a=1:ilwe
    for b=1:nummfmf
        fis=addmf(fis,'input',a,sprintf('we%dmf%d',a,b),'gaussmf',[tmp(a,licznik) tmp(a,licznik+1)]);       % dla gauss
%         fis=addmf(fis,'input',a,sprintf('we%dmf%d',a,b),'gauss2mf',[tmp(a,licznik) tmp(a,licznik+1) tmp(a,licznik+2) tmp(a,licznik+3)]);       % dla 2gauss
        licznik=licznik+2;                              % zmiana dla gauus +2 !!!!!!!!!!!!!!!!!!!!!!!!11
    end
licznik=1;
end

if nargout == 3
    [fis, act, comp] = fillrule(fis,trn,tmp);
else
    [fis, act] = fillrule(fis,trn,tmp);
end

sss=sprintf('%d rules',length(fis.rule));
disp(sss);


if nargout==2
    out = fis;
    actout = act;
elseif nargout==3
    out = fis;
    actout = act;
    compmf = comp;    
else
    out=fis;
end
