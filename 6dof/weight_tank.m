function tank_weight = weight_tank( prop_weight, radius)
% タンク重量を計算する。
% @params prop_weight 推進剤重量(kg)
% @params radius タンク半径（内径）(m)
% @return tank_weight タンク重量(kg)
    % パラメータ
    of = 1.6; % O/F(-)
    rho_f = 789; % 燃料密度(kg/m3)
    rho_o = 1140; % 酸化剤密度(kg/m3)
    rho_Al = 2780; % アルミ密度(kg/m3)
    t_tank = 0.005; % タンク厚み(m)
    
    % 計算
    % weight_ 重量(kg)
    weight_f = prop_weight * (1 / (of+1));
    weight_o = prop_weight * (of / (of+1));
    % V_ 推進剤体積(m3)
    V_f = weight_f / rho_f;
    V_o = weight_o / rho_o;
    % タンクの形
    if 4/3*pi*radius^3 > V_f
        h_f = 0; % タンクの直線部(m)
    else
        h_f = V_f / pi / radius^2 - 4/3*radius;
    end
    if 4/3*pi*radius^3 > V_o
        h_o = 0; % タンクの直線部(m)
    else
        h_o = V_o / pi / radius^2 - 4/3*radius;
    end 
    % タンク体積(m3)
    V_tank_f = 4/3*pi*((radius+t_tank)^3 - radius^3) + ...
               pi*h_f*(radius+t_tank)^2 - pi*h_f*radius^2;
    V_tank_o = 4/3*pi*((radius+t_tank)^3 - radius^3) + ...
               pi*h_o*(radius+t_tank)^2 - pi*h_o*radius^2;
    % タンク重量(kg)
    tank_weight = (V_tank_f + V_tank_o) * rho_Al;
end