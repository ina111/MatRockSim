% -----
% This calculate the derivative of quaternion.
% dq/dt = - 1/2 * [0 omega] * q
% -----
function dquat = deltaquat(quat, omega)
dquat = -0.5 * quatmultiply([0 omega'], quat);
end
