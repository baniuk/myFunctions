function out = isInside(point,points,edges)
% point - testowany punkt
% points - macierz punktów figury
% edges po³¹czenia pomiêdzy punktami jako indeksy w macierzy r x 2

count = 0;
for a=1:size(edges,1)
    p0 = points(edges(a,1),:);   % pierwwszy punkt odcinka
    p1 = points(edges(a,2),:);   % drugi punkt odcinka
    count = count + prvTestInside(point,p0,p1);
    
end;
out = mod(count,2)==1;

function out = prvTestInside(point,p0,p1)
% odcinek poziomy
    if p1(2)==p0(2)
        out = 0;
        return;
    end
    % sortowanie
    if p0(2)>p1(2)
        tmp = p0;
        p0 = p1;
        p1 = tmp;
    end
    % odcinek A
    if (p0(2)<point(2)) & (p1(2)<=point(2))
        out = 0;
        return;
    end
    if (p0(2)>point(2)) & (p1(2)>point(2))
        out = 0;
        return
    end;
    % odcinek B
    if (p0(1)<point(1)) & (p1(1)<point(1))
        out = 0;
        return;
    end;
    % odcinek C
    if (p0(1)>=point(1)) & (p1(1)>=point(1))
        out = 1;
        return
    end;
    % odcinek D
    % punkt przeciêcia
    t = (point(2)-p0(2))/(p1(2)-p0(2));
    xp = p0(1)+t*(p1(1)-p0(1));
    if xp>=point(1)
        out = 1;
        return;
    else
        out = 0;
        return
    end;