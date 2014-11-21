%% Affichage du code barre

img_filename = 'img/code1.bmp';

figure
imshow(img_filename);

% Ouverture de l'image
code_barre = imread(img_filename);

% Récupération des coordonnées 
[x, y] = ginput(2);

x_min = min(x);
x_max = max(x);
y_min = min(y);
y_max = max(y);

r_min = sum(code_barre(y_min, :));

for y=ymin:-1:1
    r = sum()
end

code_barre = code_barre(y(1):y(2), x(1):x(2));
imshow(code_barre);