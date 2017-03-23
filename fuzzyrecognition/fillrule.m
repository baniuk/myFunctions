function [out, actout, compmf]=fillrule(fis, data, mf)
% wypelnia rule na podstawie danych treninggowych i ich przynaleznosci do poszczegolnych MF na wejsciach
% mf - maciez z wspolczynnikami dla mf (w rzedach)
sm=size(mf);
si=size(data);%si(2)=4;
licznikb = 1;
poz = 1;
if nargout == 3
    comp = zeros(si(2)-1,sm(2)/2,si(1));
end
for a=1:si(1)                               % po wszystkich próbkach
    tmpdata = data(a,1:si(2)-1);            % oprócz ostatniej kolumny (out)
    licznikb = licznikb+1;
    for we=1:si(2)-1                             % po wejsiach
        licznik = 1;
        clear wymf;
        for m=1:sm(2)/2                           % po mf  dla gauss /2 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            wymf(m)=evalmf(tmpdata(we),[mf(we,licznik) mf(we,licznik+1)],'gaussmf');        % dla gausa  !!!!!!!!!!!!!!!!!!!!!!!!!!
%             wymf(m)=evalmf(tmpdata(we),[mf(we,licznik) mf(we,licznik+1) mf(we,licznik+2) mf(we,licznik+3)],'gauss2mf');        % dla g2ausa !!!!!!!!!!!!!
            if nargout == 3 comp(we,m,a) = wymf(m); end;
            licznik = licznik+2;                % dla gaussa +2!!!!!!!!!!!!!!!!!!!!!!!!!!!
        end     % of m
%         tm=max(wymf);
%         tf=find(wymf==tm);
%         tu=unique(tf);
        trt = find(wymf==max(wymf));;
        act(poz,we)=trt(1);
%         wymf(act(a,we))=-100;
%         bct(a,we)=unique(find(wymf==max(wymf)));
    end     % of we
%     if licznikb==5000
%         licznikb = 1;
%         act = unique(act,'rows');
%         so=size(act);
%         poz = so(1);
%     end
    poz = poz + 1;
end     % of a

% act = unique([act data(:,si(2))],'rows');
act = unique(act,'rows');
so=size(act);
% act(:,so(2)) = [];
% so=size(act);

for a=1:so(1)
    fis.rule(a).antecedent=act(a,:);
    fis.rule(a).consequent= a;
    fis.rule(a).weight=1;
    fis.rule(a).connection=1;
    fis.output.mf(a).name=sprintf('out%d',a);
    fis.output.mf(a).type = 'constant';
    fis.output.mf(a).params = rand;
end


if nargout==2
    out = fis;
    actout = act;
elseif nargout == 3
    out = fis;
    actout = act;
    compmf = comp;    
else
    out = fis;
end
            
    
