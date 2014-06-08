% ----
% matlab odeのイベント
% options = odeset('Events', @events_land);
% のように使用。MathWorksの例を参照のこと。
% @param t: odeの中の時刻（おまじない）
% @param x: odeの中の状態（おまじない）
% @return value: イベント発生判定する状態量（水平座標系の高さ方向）
% @return isterminal: value=0のときにシミュレーションを停止(1)するか継続するか(0)
% @return direction: 求めるゼロ交差の方向(-1:負からのみ, 0:両方から, 1:正からのみ)
% ----
function [value,isterminal,direction] = events_land(t,x)
	value = x(2);
	isterminal = 1;
	direction = -1;
end