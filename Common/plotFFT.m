function plotFFT(in)
%plotFFT plots FFT spectrum

figure;
imagesc(log(1+abs(fftshift(in))));
axis equal;