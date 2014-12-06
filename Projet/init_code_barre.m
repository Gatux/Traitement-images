function [ img_out ] = init_code_barre( img_in )

[x, y, z] = size(img_in);

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
peak = houghpeaks(H);
angle = T(peak(2));
img_out = imrotate(img_nb, angle, 'bilinear');

end

