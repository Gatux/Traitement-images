%% Vermeulen Gabreil - Peterlin Maxime
% TP - Traitement d'images
% Partie 3
clear all
close all

%% Q1

Sx=(1/8)*[1 0 -1;2 0 -2;1 0 -1];
Sy=(1/8)*[1 2 1;0 0 0;-1 -2 -1];

Hx=(1/2)*[1 0 -1];
Hy=(1/4)*[1;2;1];

A=double(imread('img/batiment.bmp'));
figure;
subplot(1,4,1);
imshow(uint8(A));
title('Image d`origine');

Dx=conv2(A,Sx,'same');
Dy=conv2(A,Sy,'same');

Dequid=(Dx.*Dx+Dy.*Dy).^0.5;

displayX = (Dx-min(min(Dx)))/(max(max(Dx))-min(min(Dx)));
displayY = (Dy-min(min(Dy)))/(max(max(Dy))-min(min(Dy)));
displayE = (Dequid-min(min(Dequid)))/(max(max(Dequid))-min(min(Dequid)));

subplot(1,4,2);
imshow(displayX)
title('Derivee horizontale');

subplot(1,4,3);
imshow(displayY)
title('Derivee verticale');

subplot(1,4,4);
imshow(1-displayE)
title('Detection des contours');

%% Q2
img = double(imread('img/batiment.bmp'));

L = [ 1 1 1; 1 -8 1; 1 1 1];

img2 = conv2(img, L);
img2(:, 1) = [];
img2(:, length(img2)) = [];
img2(1, :) = [];
img2(length(img2(:, 1)), :) = [];
img2 = img-img2;

imshow(uint8(img2));