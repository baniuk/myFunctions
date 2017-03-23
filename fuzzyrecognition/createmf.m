function out=createmf(ilwe,nummfmf,trn,przec)

for we=1:ilwe
    licznik=1;
    [c,u] = fcm(trn(:,we), nummfmf,[1.5 500 1e-7 0]);
%     c=[0; 0.2;0.4;0.6;0.8;1];
    si=size(c);
    maxU=max(u);
    for a=1:si(1)
        index = find(u(a,:)==maxU);
        punkty=trn(index,we);
        if ~isempty(punkty)
            xmin=unique(min(punkty));
            xmax=unique(max(punkty));
%             cs = c(a);
            cs = (xmin+xmax)/2;
            smin=sqrt(-(xmin-cs)^2/(2*log(przec)));
            smax=sqrt(-(xmax-cs)^2/(2*log(przec)));
            sig=min([smin smax]);
            if sig==0
                sig=0.1;        % 0.1
            end;
        else
            sig=0.1;
        end
            tmp(we,licznik)=sig;
            tmp(we,licznik+1)=cs;
            licznik = licznik+2;      
    end
end

out=tmp;