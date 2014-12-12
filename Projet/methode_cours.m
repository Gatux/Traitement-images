function [ chiffres, verif ] = methode_cours( code_barre_line_nb )

    nb_elem = 7*12+3*2+5;
    code_barre_len_elem = zeros(1, nb_elem);
    step = length(code_barre_line_nb) / nb_elem;
    i = 1;  

    for j=1:nb_elem
        last = fix(i);
        next = fix(i+step);
        code_barre_len_elem(j) = length(code_barre_line_nb(last:next-1));
        i = i + step;
    end
end

