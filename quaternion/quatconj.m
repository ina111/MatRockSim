% ----
% 蜈ｱ蠖ｹ繧ｯ繧ｩ繝ｼ繧ｿ繝九が繝ｳ
% @param q: 繧ｯ繧ｩ繝ｼ繧ｿ繝九が繝ｳ (1x4)
% @param o: 蜈ｱ蠖ｹ繧ｯ繧ｩ繝ｼ繧ｿ繝九が繝ｳ (1x4)
% ----
function o = quatconj(q)
% QUATCONJ 共役クォータニオン
% 	@param q: クォータニオン (1x4)
% 	@param o: 共役クォータニオン (1x4)
	o = [q(1) -q(2) -q(3) -q(4)];
end
