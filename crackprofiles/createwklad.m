function out=createwklad(w,grubosc)
% tworzy zarys wady na podstawie macierzy 0-1

[sw,unused] = size(w);
s = sum(w)/sw;
out = s*grubosc;
