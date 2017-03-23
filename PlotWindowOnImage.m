function h = PlotWindowOnImage(im,poz)
% Funkcja rysuje okno na obrazku im. Okno zdefiniowane jako zakres:
% poz = [r_start r_stop;
%        k_start k_stop]

h = figure;
imshow(im,[]);
hold on

k_start = poz(2,1);
k_stop = poz(2,2);
r_start = poz(1,1);
r_stop = poz(1,2);

XY = [  k_start r_stop;
        k_stop r_stop;
        k_stop r_start;
        k_start r_start;
        k_start r_stop];

line(XY(:,1), XY(:,2));
