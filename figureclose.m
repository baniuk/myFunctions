function figureclose(h)
% zamyka figury z macierzy f

for a=1:length(h)
    if ishandle(h(a))
        close(h)
    end
end