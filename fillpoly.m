function out = fillpoly(in,vert,edges)
% funkcja wype�nia powierzchni� in warto�ciami 1 zgodnie z definicj�
% polygiou danego jako vert [Nx2] i edges [N+1x2]
% wsp�rz�dne w vert musz� by� wyrazone w wsp�rz�dnych obrazu 1...M 1...N



out = in;
for x=1:size(in,2)
    for y = 1:size(in,1)
        if isInside([x,y],vert,edges)==1
            out(y,x) = 1;
        end
    end
end