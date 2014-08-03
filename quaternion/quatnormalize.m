function qout = quatnormalize( q )
%  QUATNORMALIZE クォータニオンの正規化.
%
%   Examples:
%
%   Normalize q = [1 0 1 0]:
%      normal = quatnormalize([1 0 1 0])

qout = q./(quatnorm( q )* ones(1,4));
