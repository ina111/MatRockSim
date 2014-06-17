% ----
% 逆クォータニオン
% @param q: クォータニオン (1x4)
% @param o: 逆クォータニオン (1x4)
% ----
function o = quatinv(p)
  o = quatconj(p) / (quatnorm(p)^2);
end
