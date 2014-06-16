function n = quatnorm( q )
%  QUATNORM クォータニオンのノルム.
%
%   Examples:
%
%   Determine the norm of q = [1 0 1 0]:
%      n = quatnorm([1 0 1 0])
%      n = 1.4142

n = norm(q);
