clear all
close all

Fg=double(imread('img/foreground.jpg'));
Bg=double(imread('img/background.jpg'));

figure
subplot(1,3,1), imshow(uint8(Fg))
title('Image originale');

R1=Fg(:,:,1);
G1=Fg(:,:,2);
B1=Fg(:,:,3);

R2=Bg(:,:,1);
G2=Bg(:,:,2);
B2=Bg(:,:,3);

Y=0.229*R1+0.587*G1+0.114*B1;
Cb=0.564*(B1-Y)+128;
Cr=0.713*(R1-Y)+128;

subplot(1,3,2), imshow(uint8(Cb));
title('Chrominance bleu')

 for i=1:length(Bg(:,1))
   for j=1:length(Bg)
     if (Cb(i,j)>145)
       R1(i,j)=255;
       G1(i,j)=255;
       B1(i,j)=255;
     else
       R2(i,j) = R1(i,j); 
       G2(i,j) = G1(i,j);
       B2(i,j) = B1(i,j);
     end
   end
 end

subplot(1,3,3), imshow(cat(3,R1/255,G1/255,B1/255));
title('Image sans le ciel');

figure , imshow(cat(3,R2/255,G2/255,B2/255));
title('Chroma-keying');


%% Commentaires

% La representation YCrCb est ici plus adaptee qu'une representation RGB,
% car elle offre une meilleure representation du rouge, du vert et du bleu.
% YCrCb garde l'information sur les autres couleurs, ainsi un bleu pur (0,
% 0, 255) apparaitra blanc sur la repr?sentation YCrCb, alors que du violet
% (255, 0, 255) apparaitra gris?.

