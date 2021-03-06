% TP Traitement d'image
% Maxime PETERLIN - Gabriel VERMEULEN
%% Etape 0
clear all
close all

img=double(imread('img/monument.bmp'));

[h,w]=size(img);

fx=linspace(-0.5,0.5-1/w,w);
fy=linspace(-0.5,0.5-1/h,h);

% Representation frequentielle de l'image
IfA=fftshift(log10(abs(fft2(img))));
figure(1);
imagesc(fx,fy,IfA);
title('Representation frequentielle de l`image');

%% Etape 1
sx=-100:100;
sy=-100:100;
% Representation spatiale du filtre Gaussien
[X,Y]=meshgrid(sx,sy);
sigma=10;
H1=exp(-(X.^2+Y.^2)/(2*sigma^2))/(2*pi*sigma*sigma);

figure(2);
subplot(1,2,1);
mesh(H1);
title('Representation spatiale du filtre Gaussien');

% Representation frequentielle d'un filtre Gaussien
IfH1 = fftshift(log10(abs(fft2(H1))));
subplot(1,2,2);
imagesc(fx,fy,IfH1);
title('Representation frequentielle du filtre Gaussien');

%% Etape 2
Fx=0.0992;
Fy=-0.3996;
H2 = H1 .* 2.* cos(2*pi*Fx*X + 2*pi*Fy*Y);

% Representation spatiale du filtre passe-bande
figure(3);
subplot(1,2,1);
mesh(H2);
title('Representation spatiale du filtre Gaussien');

% Representation frequentielle du filtre passe-bande
IfH2 = fftshift(log10(abs(fft2(H2))));
subplot(1,2,2);
imagesc(fx,fy,IfH2);
title('Representation frequentielle du filtre Gaussien');

%% Etape 3
tx = length(sx);
ty = length(sy);
dirac = zeros(ty,tx);
dirac(fix(ty/2 +0.5), fix(tx/2 +0.5)) = 1; 

H3 = dirac - H2;

% Representation spatiale du filtre coupe-bande
figure(4);
subplot(1,2,1);
mesh(H3);
title('Representation spatiale du filtre Gaussien');

% Representation frequentielle du filtre coupe-bande
IfH3 = fftshift(log10(abs(fft2(H3))));
subplot(1,2,2);
imagesc(fx,fy,IfH3);
title('Representation frequentielle du filtre Gaussien');

%% Etape 4

img_filtree = conv2(img, H3, 'same');

figure(5);
imshow(img_filtree/255);

figure(6)
IfH4 = fftshift(log10(abs(fft2(img_filtree))));
imagesc(fx,fy,IfH4);





