function o = quatinv(p)
% QUATINV 逆クォータニオン
% 	@param q: クォータニオン (1x4)
% 	@param o: 逆クォータニオン (1x4)
	o = quatconj(p) / (norm(p)^2);
end
