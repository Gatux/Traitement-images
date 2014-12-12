function [ chiffres, verif ] = methode_perso( code_barre_line_nb )

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
            [~, indx] = max( (codes-kron(mean(codes, 2),ones(1,7)))*(fliplr(chiffres_codes(i-1, :) - mean(chiffres_codes(i-1, :)))'));
            chiffres(i) = mod(indx-1, 10)
            disp('Impossible de reconnaitre le chiffre');
%             chiffres(i) = nan;
            verif = 1;
        else
            if i <= 7
                premier_chiffre(i-1) = fix((indx-1)/10);
            end
            chiffres(i) = mod(indx-1, 10);
        end
    end
    
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
    
    cle = 0
    for i=1:2:12
        chiffres(i)
        cle = cle + chiffres(i) + 3*chiffres(i+1);
    end
    cle
    chiffres(13)
    verif = 0;
    if mod(cle,10) == chiffres(13)
        verif = 1
    end
end

