clear all
close all

% Affichage du code barre

img_filename = 'img/code3.jpg';

% vid = videoinput('winvideo', 1);
% set(vid, 'ReturnedColorSpace', 'RGB');
% img = getsnapshot(vid);
% imshow(img)

% Ouverture de l'image
code_barre_src = imread(img_filename);
code_barre_src = imrotate(code_barre_src, 70);

figure
imshow(code_barre_src);

R = double(code_barre_src(:,:,1));
G = double(code_barre_src(:,:,2));
B = double(code_barre_src(:,:,3));

code_barre_nb = (R+G+B)/3/255;

code_barre_cont = edge(code_barre_nb, 'sobel');
[H,T,R] = hough(code_barre_cont);
peak = houghpeaks(H);

angle = T(peak(2))
code_barre_nb = imrotate(code_barre_nb, angle-90, 'bilinear');

figure
imshow(code_barre_nb);

% Récupération des coordonnées 
[gx, gy] = ginput(2);

x_min = fix(min(gx));
x_max = fix(max(gx));
y_min = fix(min(gy));
y_max = fix(max(gy));

epsilon = 0.1;

[size_Y, size_X] = size(code_barre_nb);

r_min = sum(code_barre_nb(y_min, x_min:x_max));
for y=y_min:-1:1
    r = abs(sum(code_barre_nb(y, x_min:x_max))/r_min);
    if r > 1+epsilon || r < 1-epsilon
        y_min = y;
        break;
    end 
end

r_max = sum(code_barre_nb(y_max, x_min:x_max));
for y=y_max:1:size_Y
    r = abs(sum(code_barre_nb(y, x_min:x_max))/r_max);
    if r > 1+epsilon || r < 1-epsilon
        y_max = y;
        break;
    end 
end

line([x_min, x_min], [0, size_Y]);
line([x_max, x_max], [0, size_Y]);
line([0, size_X], [y_min, y_min]);
line([0, size_X], [y_max, y_max]);

code_barre = code_barre_nb(y_min:y_max, x_min:x_max);
%imshow(code_barre);

N = 256;
h = hist(code_barre, N);
s = sum(h,2);
h_sum = sum(s);

w = zeros(256, 1);
mu = zeros(256, 1);

for k=1:256
    e = 0;
    for i=1:k
        e = e + i*s(i);
    end
    w(k) = sum(s(1:k))/h_sum;
    mu(k) = e/h_sum;
end

crit = zeros(256, 1);
for k=1:256
    crit(k) = w(k)*(mu(N)-mu(k)).^2+(1-w(k))*mu(k).^2;
end

[v,i] = max(crit);
seuil = i/N;

code_barre_line = mean(code_barre, 1);
code_barre_line = code_barre_line > seuil;
code_barre_line = abs(code_barre_line - 1);
code_barre_line = code_barre_line(find(code_barre_line,1,'first'):find(code_barre_line,1,'last'));
code_barre_line_nb = abs(code_barre_line - 1);

nb_elem = 7*12+3*2+5;
code_barre_code = zeros(1, nb_elem);
step = length(code_barre_line_nb) / nb_elem;
i = 1;
last = i;
j = 1;

for j=1:nb_elem
    last = fix(i);
    next = fix(i+step);
    code_barre_code(j) = sum(code_barre_line_nb(last:next-1))/step > 0.5;
    i = i + step;
end

codes = [
    1,1,1,0,0,1,0;
    1,1,0,0,1,1,0;
    1,1,0,1,1,0,0;
    1,0,0,0,0,1,0;
    1,0,1,1,1,0,0;
    1,0,0,1,1,1,0;
    1,0,1,0,0,0,0;
    1,0,0,0,1,0,0;
    1,0,0,1,0,0,0;
    1,1,1,0,1,0,0;
    
    1,0,1,1,0,0,0;
    1,0,0,1,1,0,0;
    1,1,0,0,1,0,0;
    1,0,1,1,1,1,0;
    1,1,0,0,0,1,0;
    1,0,0,0,1,1,0;
    1,1,1,1,0,1,0;
    1,1,0,1,1,1,0;
    1,1,1,0,1,1,0;
    1,1,0,1,0,0,0;
    
    0,0,0,1,1,0,1;
    0,0,1,1,0,0,1;
    0,0,1,0,0,1,1;
    0,1,1,1,1,0,1;
    0,1,0,0,0,1,1;
    0,1,1,0,0,0,1;
    0,1,0,1,1,1,1;
    0,1,1,1,0,1,1;
    0,1,1,0,1,1,1;
    0,0,0,1,0,1,1;];

chiffres_codes = zeros(12, 7);

for i=1:6
    chiffres_codes(i, :) = code_barre_code(4+(i-1)*7:3+i*7);
    chiffres_codes(i+6, :) = code_barre_code(4+7*6+5+(i-1)*7:3+7*6+5+i*7);
end

chiffres = zeros(1, 12);

for i=1:12
    [~,indx] = ismember(chiffres_codes(i, :),codes,'rows');
    chiffres(i) = mod(indx-1, 10);
end

chiffres

% 
% figure
% imshow(code_barre_line_nb);

%%
find(code_barre_line,1,'first')
%code_barre_line = code_barre_line(find(code_barre_line,1,'first'):find(code_barre_line,1,'last'));

figure
imshow(code_barre_line);
