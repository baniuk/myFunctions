function h = PlotCrop(poz)
% rysuje ramk� na bierzacym obrazie zgodn� z formatem imcrop:
% [x y sizx sizy]

hold on

k_start = poz(1);
k_stop = poz(1)+poz(3);
r_start = poz(2);
r_stop = poz(2)+poz(4);

XY = [  k_start r_stop;
        k_stop r_stop;
        k_stop r_start;
        k_start r_start;
        k_start r_stop];

h = line(XY(:,1), XY(:,2));

hold off