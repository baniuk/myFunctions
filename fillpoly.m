function out = fillpoly(in,vert,edges)
% funkcja wype³nia powierzchniê in wartoœciami 1 zgodnie z definicj¹
% polygiou danego jako vert [Nx2] i edges [N+1x2]
% wspó³rzêdne w vert musz¹ byæ wyrazone w wsp³rzêdnych obrazu 1...M 1...N



out = in;
for x=1:size(in,2)
    for y = 1:size(in,1)
        if isInside([x,y],vert,edges)==1
            out(y,x) = 1;
        end
    end
end