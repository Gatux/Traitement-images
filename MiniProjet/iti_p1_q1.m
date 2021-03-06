A = double(imread('img/pool.tif'));
R=A(:,:,1);
G=A(:,:,2);
B=A(:,:,3);

Y=0.229*R+0.587*G+0.114*B;
Cb=0.564*(B-Y)+128;
Cr=0.713*(R-Y)+128;

figure,
subplot(3,3,8),imshow(uint8(A))
title('Couleurs vrais');
subplot(3,3,1), imshow(uint8(R))
title('Composante R');
subplot(3,3,2), imshow(uint8(G))
title('Composante G');
subplot(3,3,3), imshow(uint8(B))
title('Composante B');
subplot(3,3,5), imshow(uint8(Y))
title('Composante Y');
subplot(3,3,6), imshow(uint8(Cb))
title('Composante Cb');
subplot(3,3,4), imshow(uint8(Cr))
title('Composante Cr');


%% Commentaires

% Sur les images qui representent les composantes R, G et B, on remarque
% que la boule blanche apparait blanche sur les trois images.

% Sur les images qui representent les composantes Y, Cr, et Cb, on remarque
% que la boule blanche apparait blanche uniquement sur l'image de la
% luminance. De plus, les boules ayant une couleur a forte dominante rouge
% ou bleu apparaissent respectivement blanches sur les images de la
% crominance rouge ou bleu.
