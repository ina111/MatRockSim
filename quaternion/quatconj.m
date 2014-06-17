% ----
% 共役クォータニオン
% @param q: クォータニオン (1x4)
% @param o: 共役クォータニオン (1x4)
% ----
function o = quatconj(q)
	o = [q(1) -q(2) -q(3) -q(4)];
end
