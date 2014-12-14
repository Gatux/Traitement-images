img_raw = imread('img/code3.jpg');
figure;
imshow(img_raw);
img = init_code_barre(img_raw);
figure;
imshow(img);


L = length(img(:,1));
R = zeros(length(img(:,1)), 1);
l = length(img);
for i = 1:L-1
   R(i,1) = sum(img(i+1,:)-img(i,:));
end

m = find(R == min(R));
M = find(R == max(R));

line([0 l], [m m]);
line([0 l], [M M]);

%%

gx = [20; length(img)-20];
    gy = [m+20; M-20];
  %[gx, gy] = ginput(2);  
    [ code_barre_ligne, x_min, x_max, y_min, y_max ] = get_code_barre_ligne( img, gx, gy, 0.1);
    figure(2)
    line([x_min+gx(1), x_max+gx(1)], [y_min, y_min], 'Color', 'red');
    line([x_min+gx(1), x_max+gx(1)], [y_max, y_max], 'Color', 'red');
    line([x_min+gx(1), x_min+gx(1)], [y_min, y_max], 'Color', 'red');
    line([x_max+gx(1), x_max+gx(1)], [y_min, y_max], 'Color', 'red');
    
    
   [ chiffres, verif ] = methode1( code_barre_ligne );
   
   chiffres
   verif
   %%
   figure,
   imshow(code_barre_ligne)