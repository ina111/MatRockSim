% ドライ重量をパラメータにして、高度100kmを達成するためのロケットのサイジングを行う。
% 
function [dry, prop, all, ratio] = sizing_plot( Isp, diameter)

warning('off','all');
global ROCKET
params_ROCKETinit_6dof

ROCKET.Isp =Isp;
ROCKET.Area = diameter^2 /4 * pi;

params_6dof
div = 4;
weight_dry = linspace(50,180,div);
weight_prop = zeros(1,length(weight_dry));
weight_all = zeros(1,length(weight_dry));
massratio = zeros(1,length(weight_dry));

for i = 1:div
    ROCKET.mf = weight_dry(i);
    state = 1;
    burn_start = 40;
    burn_end = 150;
    option = optimset('TolX', 5e-3);
    burn_time = 0;
    while state == 1
        try
            burn_time = fzero(@fsolve_altitude, [burn_start,burn_end], option);
            state = 0;
        catch
            burn_end = burn_end - 10;
            if burn_end <= burn_start
                state = 0;
            end
        end
    end
    % ---- 重量計算 ----
    ROCKET.m0 = ROCKET.mf + ROCKET.FT * burn_time / ROCKET.Isp / ROCKET.g0;
    weight_dry(i) = ROCKET.mf;
    weight_prop(i) = ROCKET.m0 - ROCKET.mf;
    weight_all(i) = ROCKET.m0;
    massratio(i) = ROCKET.m0 / ROCKET.mf;
    disp('***********************')
    disp(['mf: ', num2str(weight_dry(i))])
    disp(['massraio: ', num2str(massratio(i))])
    disp('***********************')
end

dry = weight_dry;
prop = weight_prop;
all = weight_all;
ratio = massratio;

end