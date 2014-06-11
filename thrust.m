% ----
% „—Í—š—ğ
% @param t: Œ»İ[sec] (1x1)
% @param Tend: ”RÄI—¹[sec] (1x1)
% @param FT: „—Í[N] (1x1)
% @return ft: „—Í[N] (1x1)
% ----
function ft = thrust(t, Tends, FT)
	ft = 0.0;
	if t < Tends
		ft = FT;
	end
end
