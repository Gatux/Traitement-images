function [ code_barre_ligne, x_min, x_max, y_min, y_max ] = get_code_barre_ligne( img_ng, gx, gy, epsilon)

    x_min = fix(min(gx));
    x_max = fix(max(gx));
    y_min = fix(min(gy));
    y_max = fix(max(gy));

    [size_Y, ~] = size(img_ng);

    r_min = sum(img_ng(y_min, x_min:x_max));
    for y=y_min:-1:1
        r = abs(sum(img_ng(y, x_min:x_max))/r_min);
        if r > 1+epsilon || r < 1-epsilon
            y_min = y;
            break;
        end 
    end

    r_max = sum(img_ng(y_max, x_min:x_max));
    for y=y_max:1:size_Y
        r = abs(sum(img_ng(y, x_min:x_max))/r_max);
        if r > 1+epsilon || r < 1-epsilon
            y_max = y;
            break;
        end 
    end

    code_barre = img_ng(y_min:y_max, x_min:x_max);
    N = length(unique(code_barre));
    h = hist(code_barre, N);
    s = sum(h,2);
    h_sum = sum(s);

    w = zeros(N, 1);
    mu = zeros(N, 1);

    for k=1:N
        e = 0;
        for i=1:k
            e = e + i*s(i);
        end
        w(k) = sum(s(1:k))/h_sum;
        mu(k) = e/h_sum;
    end

    crit = zeros(N, 1);
    for k=1:N
        crit(k) = w(k)*(mu(N)-mu(k)).^2+(1-w(k))*mu(k).^2;
    end
    
    [~,i] = max(crit);
    seuil = i/N;
    
    code_barre_ligne = mean(code_barre, 1);
    code_barre_ligne = code_barre_ligne >= seuil;
    code_barre_ligne = abs(code_barre_ligne - 1);
    x_min = find(code_barre_ligne,1,'first');
    x_max = find(code_barre_ligne,1,'last');
    code_barre_ligne = code_barre_ligne(x_min:x_max);
    code_barre_ligne = abs(code_barre_ligne - 1);
end

