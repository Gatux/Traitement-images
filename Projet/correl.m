function [ i_ligne ] = correl( codes, ligne )

r = [];

for i=1:length(codes)
    r = [ r; conv(ligne, codes(i,:))];
end

i_ligne = max(r, [], 2);
%[~, i] = max(r, [], 2);

%i_ligne = i;

end

