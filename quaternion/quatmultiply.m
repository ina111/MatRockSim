% ----
% クォータニオン積
% @param q: クォータニオン (1x4)
% @param p: クォータニオン (1x4)
% @param o: クォータニオン積 (1x4)
% ----
function o = quatmultiply(q, p)
% QUATMULTIPLY �N�H�[�^�j�I����
% 	@param q: �N�H�[�^�j�I�� (1x4)
% 	@param p: �N�H�[�^�j�I�� (1x4)
% 	@param o: �N�H�[�^�j�I���� (1x4)
	o1 = q(1)*p(1)-q(2)*p(2)-q(3)*p(3)-q(4)*p(4);
	o2 = q(2)*p(1)+q(1)*p(2)-q(4)*p(3)+q(3)*p(4);
	o3 = q(3)*p(1)+q(4)*p(2)+q(1)*p(3)-q(2)*p(4);
	o4 = q(4)*p(1)-q(3)*p(2)+q(2)*p(3)+q(1)*p(4);
	o = [o1 o2 o3 o4];
end
