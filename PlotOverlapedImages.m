function h = PlotOverlapedImages(im1,im2,tr)
% funkcja rysuje na³o¿one obrazki

transp = tr*ones(size(im1));

c_m = gray(256);
im1sc = round(255*Scale01(im1));
im2sc = round(255*Scale01(im2));
im1rgb = ind2rgb(im1sc,c_m);
im2rgb = ind2rgb(im2sc,c_m);
h_im1 = image(im1rgb);

hold on
h_im2 = image(im2rgb);
set(h_im2,'AlphaData',transp);


axis off
axis image