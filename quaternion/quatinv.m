% ----
% 騾�繧ｯ繧ｩ繝ｼ繧ｿ繝九が繝ｳ
% @param q: 繧ｯ繧ｩ繝ｼ繧ｿ繝九が繝ｳ (1x4)
% @param o: 騾�繧ｯ繧ｩ繝ｼ繧ｿ繝九が繝ｳ (1x4)
% ----
function o = quatinv(p)
% QUATINV 逆クォータニオン
% 	@param q: クォータニオン (1x4)
% 	@param o: 逆クォータニオン (1x4)
  o = quatconj(p) / (quatnorm(p)^2);
end
