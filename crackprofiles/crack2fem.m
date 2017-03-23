function out=crack2fem(w,step,sizepoints,sizes,config)
% w maciez z matryc¹ wady (1)
% step - jak ma sie wada przesowac (co ile kratek)
% sizepoints - rozmiar punktu [x,y]
% sizes - rozmiar obszery [x,y]
% config - parami gdzie i co (subdomeny) w cell. Pierwszy element to
% wartoœæ której jest najwiêcej. 

numpoints = sizes./sizepoints;

% nn = 96
nn = numpoints(1);
z=zeros(numpoints)';
sw = size(w);
sz = size(z);
stale = 0; % ile elementów jest stalych (cewki itp)

%147 - CL 163 - R 194 - CP 225 - CLM 266 - CPM 292 - CL 338 - CP 
% 5 - rdzen
% 2 - inconell
% 1 - otocz
% 3 - +
% 4 - -
% przyk³ad
% >> config{1}=2                            % tego najwiecej
% >> config{2}=1                            % wada
% >> config{3}=[147 292];config{4}=3;
% >> config{5}=163;config{6}=5;
% >> config{7}=[194 338];config{8}=4;
% >> config{9}=225;config{10}=1;
% >> config{11}=266;config{12}=1;
% >> config{13}=1;config{14}=1;
config{length(config)+1} = 1;               % definicja otoczenia
config{length(config)+1} = config{2};     % wada to tez otoczenie
licznik = 1;
for a=3:2:length(config)-1
    stale(licznik:licznik+length(config{a})-1,1) = config{a}';
    stale(licznik:licznik+length(config{a})-1,2) = config{a+1};
    licznik = licznik + length(config{a});
end
[zera,unused] = find(stale==0);
stale(zera,:) = [];         % kasowanie zer (niewypelnione pola w okienku)
sss = size(stale);
outtmp(1,:)= config{1}*ones(1,sss(1)+prod(numpoints));
licznik = 1;
for a=1:sss(1)
    outtmp(1,stale(a,1)) = stale(a,2);
end
stale = sortrows(stale);
for a=1:sz(2)
    z=zeros(numpoints(2),nn+sw(2)-1);
    z((sz(1)-sw(1)+1):sz(1),a:a+sw(2)-1) = w;
    z=z(:,sw(2):nn+sw(2)-1);
    z = fliplr(z);
    if a==1
        old = z;
    end;
    tmp = reshape(z,1,numpoints(2)*length(z));
    tmp = fliplr(tmp);
    
    for c=1:length(tmp)
        if tmp(c)==0
            tmp(c) = config{1};
        elseif tmp(c)==1
            tmp(c) = config{2};
        end
    end
    
    tmp2 = config{1}*ones(1,length(tmp)+sss(1));
    tmp2(1:length(tmp)) = tmp;
    koniec = length(tmp);
    for aa=1:sss(1)
        tmp2(stale(aa,1)+1:koniec+1) = tmp2(stale(aa,1):koniec);
        tmp2(stale(aa,1)) = stale(aa,2);
        koniec = koniec + 1;
    end
    outtmp(a+1,1:length(tmp2))=tmp2;
    clear tmp tmp1 tmp2 
    
end

outtmp(2:sw(2),:) = [];
sz = size(outtmp);
out = outtmp([1,2:step:sz(1)],:);
% figure;pcolor(out');figure;pcolor(old)