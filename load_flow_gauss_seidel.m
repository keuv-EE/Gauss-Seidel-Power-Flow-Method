clear
clc

n_barras = input("Quantidade de Barras 'n': ");

V = zeros(1,n_barras);

for i = 1:n_barras
    V(i) = input(sprintf('Tensão na barra %d: ', i));
end

V_PV = zeros(1, n_barras);

% V1 = 1.05;
% V2 = 1;
% V3 = 1;

y_p_barra = n_barras + 1;

Y = zeros(n_barras, y_p_barra);

for i = 1:n_barras
    for j = 1:y_p_barra
        Y(i,j) = input(sprintf('y_{%d, %d}: ', i, j-1));
    end
end

% y12 = 10 - 20i; y21 = y12;
% y13 = 10 - 30i; y31 = y13;
% y23 = 16 - 32i; y32 = y23;

S = zeros(1, n_barras);

for i = 1:n_barras
    S(i) = input(sprintf('Potência na barra %d: ', i));
end

% S2 = - 2.566 - 1.102i;
% S3 = - 1.386 - 0.452i;

sc_r = zeros(1, n_barras);     %   real part stop condition

for i = 1:n_barras
    sc_r(i) = 5e-5;
end

sc_img = zeros(1, n_barras);     %   img part stop condition

for i = 1:n_barras
    sc_img(i) = 1e-4;
end

err_r = zeros(1, n_barras);

for i = 1:n_barras
    err_r(i) = 1e5;
end

err_img = zeros(1, n_barras);

for i = 1:n_barras
    err_img(i) = 1e5;
end

% err2 = 1e5;
% err3 = 1e5;

Yii = zeros(1, n_barras);

for i = 1:n_barras
    for j = 1:y_p_barra
        Yii(i) = Y(i,j) + Yii(i);
    end
end

tipo_barra = string(zeros(1, n_barras));
for i = 1:n_barras
    tipo_barra(i) = input(sprintf("Qual é o tipo da barra %d? ", i), "s");
end

iter = 1;     % numero de iteracoes

for i = 1:n_barras
    if tipo_barra(i) == "PV"
        V_PV(i) = V(i);
    end
end

while any(err_r > sc_r) || any(err_img > sc_img)
    V_ant = V;

    for i = 2:n_barras
        if tipo_barra(i) == "PQ"
            conec_p_barra = 0;
            for j = 2:y_p_barra
                if i == (j-1)
                    continue;     % saltar a iteracao da soma somente uma vez, ou seja, i != j
                end
                conec_p_barra = Y(i,j) * V(j-1) + conec_p_barra;
            end
            V(i) = ((conj(S(i))/conj(V(i))) + conec_p_barra)/Yii(i);
        end

        if tipo_barra(i) == "PV"
            conec_p_barra = 0;
            for j = 2:y_p_barra
                if i == (j-1)
                    continue;     % saltar a iteracao da soma somente uma vez, ou seja, i != j
                end
                conec_p_barra = Y(i,j) * V(j-1) + conec_p_barra;
            end
            S(i) = real(S(i)) - imag((conj(V(i)))*((V(i))*(Yii(i)) - conec_p_barra))*1i;

            V_intrmd = ((conj(S(i))/conj(V(i))) + conec_p_barra)/(Yii(i));

            V(i) = sqrt((V_PV(i))^2 - (imag(V_intrmd))^2) + imag(V_intrmd)*1i;
        end
    end
    
    % V2_k1 = ( (conj(S2)/conj(V2)) + (y21 * V1) + (y23 * V3) )/(y21 + y23);
    % V3_k1 = ( (conj(S3)/conj(V3)) + (y31 * V1) + (y32 * V2_k1) )/(y31 + y32);

    for i = 1:n_barras
        err_r(i) = abs(real(V(i)) - real(V_ant(i)));
    end

    for i = 1:n_barras
        err_img(i) = abs(imag(V(i)) - imag(V_ant(i)));
    end

    % err2 = abs(V2_k1 - V2);
    % err3 = abs(V3_k1 - V3);

    % V2 = V2_k1;
    % V3 = V3_k1;

    iter = iter + 1;
    
    if all(err_r < sc_r) && all(err_img < sc_img)
        fprintf('Iter: %d\n', iter);
        for i = 1:n_barras
            fprintf('Tensao V%d: %.5f %.5fi\n', i, real(V(i)), imag(V(i)));
        end
    end

end