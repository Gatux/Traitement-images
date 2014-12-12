function [ img_out ] = init_code_barre( img_in )

[~, ~, z] = size(img_in);

if z == 3
    R = double(img_in(:,:,1));
    G = double(img_in(:,:,2));
    B = double(img_in(:,:,3));
    img_nb = (R+G+B)/3/255;
else
    img_nb = double(img_in/255);
end

img_edge = edge(img_nb, 'sobel');
[H,T,~] = hough(img_edge);
peak = houghpeaks(H, 30);
[m, r] = max(peak(:, 1));
if m ~= 1
    angle = T(peak(r,2));
    img_out = imrotate(img_nb, angle);
else
    img_out = img_nb;
end

end

