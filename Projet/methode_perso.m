function [ chiffres, verif ] = methode_perso( code_barre_line_nb )

    nb_elem = 7*12+3*2+5;
    code_barre_code = zeros(1, nb_elem);
    step = length(code_barre_line_nb) / nb_elem;
    i = 1; 

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

    chiffres = zeros(1, 13);
    verif = 1;

    for i=2:13
        [~,indx] = ismember(chiffres_codes(i-1, :),codes,'rows');
        if(indx == 0)
            disp('Impossible de reconnaitre le chiffre');
            chiffres(i) = nan;
            verif = 0;
        else
        chiffres(i) = mod(indx-1, 10);
        end
    end
    chiffres(1) = nan; %TODO
end

