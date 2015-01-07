function f = massratio ( mf )
    warning('off','all');
    global ROCKET
    params_6dof
    ROCKET.mf = mf;
    state = 1;
    burn_start = 40;
    burn_end = 150;
    option = optimset('TolX', 5e-3);
    while state == 1
        try
            burn_time = fzero(@fsolve_altitude, [burn_start,burn_end], option);
            state = 0;
        catch
            burn_end = burn_end - 10;
        end
    end
    % ---- èdó åvéZ ----
    ROCKET.m0 = ROCKET.mf + ROCKET.FT * burn_time / ROCKET.Isp / ROCKET.g0;
    
    massratio = ROCKET.m0 / ROCKET.mf;
    disp('***********************')
    disp(['mf: ', num2str(mf)])
    disp(['massraio: ', num2str(massratio)])
    disp('***********************')
    f = - massratio;
end