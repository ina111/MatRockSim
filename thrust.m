% ----
% 推力履歴
% @param t: 現在時刻[sec] (1x1)
% @param Tend: 燃焼終了時刻[sec] (1x1)
% @param FT: 推力[N] (1x1)
% @return ft: 推力[N] (1x1)
% ----
function ft = thrust(t, Tends, FT)
	ft = 0.0;
	if t < Tends
		ft = FT;
	end
end
