function [ chiffres, verif ] = methode1( code_barre_line_nb )

    nb_elem = 7*12+3*2+5;
    code_barre_code = zeros(1, nb_elem);
    step = length(code_barre_line_nb) / nb_elem;
    i = 1; 

    for j=1:nb_elem
        last = fix(i);
        next = fix(i+step);
        code_barre_code(j) = sum(code_barre_line_nb(last:next-1))/step >= 0.5;
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

    chiffres = zeros(1, 13);
    verif = 1;

    premier_chiffre = zeros(1, 6);
    
    for i=2:13
        [~,indx] = ismember(chiffres_codes(i-1, :),codes,'rows');   
            
        if indx == 0
            mat_mean_codes = codes-kron(mean(codes, 2),ones(1,7));
            mat_norm_codes = arrayfun(@(idx) norm(mat_mean_codes(idx,:)), 1:size(mat_mean_codes,1))';
            vect_mean = fliplr(chiffres_codes(i-1, :) - mean(chiffres_codes(i-1, :)))';
            vect_norm = norm(vect_mean);
            [~, indx] = max( (mat_mean_codes*vect_mean)./mat_norm_codes )
            chiffres(i) = mod(indx-1, 10)
%             disp('Impossible de reconnaitre le chiffre');
%             chiffres(i) = nan;
            verif = 1;
            if i <= 7
                premier_chiffre(i-1) = fix((indx-1)/10);
            end
        else
            chiffres(i) = mod(indx-1, 10);
        end
        
        if i <= 7
            premier_chiffre(i-1) = fix((indx-1)/10);
        end
    end
    
    premier_chiffre
    premier_codes = [
        0 0 0 0 0 0;
        0 0 1 0 1 1;
        0 0 1 1 0 1;
        0 0 1 1 1 0;
        0 1 0 0 1 1;
        0 1 1 0 0 1;
        0 1 1 1 0 0;
        0 1 0 1 0 1;
        0 1 0 1 1 0;
        0 1 1 0 1 0;
       ];
    [~,indx] = ismember(premier_chiffre,premier_codes,'rows');
    chiffres(1) = indx-1; %TODO
    
    cle = 0;
    for i=1:2:12
        chiffres(i)
        cle = cle + chiffres(i) + 3*chiffres(i+1);
    end
    chiffres(13)
    verif = 0;
    if mod(cle,10) == 10-chiffres(13)
        verif = 1;
    end
    lilil = cle
    lalal = mod(cle, 10)
    lolol = 10-chiffres(13)
end

