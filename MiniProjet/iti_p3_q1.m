clear all
close all

img = double(imread('img/batiment.bmp'));

L = [ 1 1 1; 1 -8 1; 1 1 1];

img2 = conv2(img, L);
img2(:, 1) = [];
img2(:, length(img2)) = [];
img2(1, :) = [];
img2(length(img2(:, 1)), :) = [];
img2 = img-img2;

imshow(uint8(img2));