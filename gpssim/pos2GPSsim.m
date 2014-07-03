% ----
% pos2GPSsimの動作
% 1. UEN系の位置情報からECEF位置を計算
% 2. GPS信号を補足するために射点に固定されている時間帯を追加
% 3. 数値微分によって，速度，加速度，ジャークを計算
% 4. quaternionsから，NED系に対する姿勢角を計算
% 5. 数値微分によって，角速度，角加速度，角ジャークを計算
% 6. GPSシミュレータのMOTフォーマット（マニュアル5.10.1節）で出力
% 7. 確認のためにグラフ表示
% ----
function [] = pos2GPSsim ( filename, time, X, xr, yr, zr )

% open file
fileaddress = strcat('output/',filename,'.ucd');
[fid, msg] = fopen(fileaddress, 'w');

% convert uen position into ecef coordinates
u = X(:,2);
e = X(:,3);
n = X(:,4);

[ecef_x, ecef_y, ecef_z] = launch2ecef(u, e, n, xr, yr, zr);
[lat, lon, hgt] = ecef2blh(ecef_x, ecef_y, ecef_z);

% local tangential coordinate matrix at launch pad
Rad = pi/180;
R = ltcmat(lat(1)*Rad, lon(1)*Rad);

% stay at launch pad for gps signal acquisition
dt = time(2) - time(1);
time = time - time(1);

t0 = 180; % in second
ts = (0:dt:(t0-dt))';
ns = length(ts);

t = [ts; time+t0];
n = length(t);

% position
pos_x = [ones(ns,1)*ecef_x(1); ecef_x];
pos_y = [ones(ns,1)*ecef_y(1); ecef_y];
pos_z = [ones(ns,1)*ecef_z(1); ecef_z];
pos = [pos_x, pos_y, pos_z];

% velocity
vel = numdiff3(pos, dt);

% acceleration
acc = numdiff3(vel, dt);

% jerk
jrk = numdiff3(acc, dt);

% convert quaternions to Euler angle z-y-x rotation w.r.t uen local frame
e0 = X(:,8);
e1 = X(:,9);
e2 = X(:,10);
e3 = X(:,11);

roll = atan2(e2.*e3 + e0.*e1, 0.5 - (e1.*e1 + e2.*e2));
pitch = asin(-2*(e1.*e3 - e0.*e2));
yaw = atan2(e1.*e2 + e0.*e3, 0.5 - (e2.*e2 + e3.*e3));

% convert up-east-north into north-east-down coordinates
phi = -yaw;
theta = -pitch;
psi = roll;

att_x = [ones(ns,1)*phi(1); phi];
att_y = [ones(ns,1)*theta(1); theta];
att_z = [ones(ns,1)*psi(1); psi];

att = [att_x att_y att_z]; % [roll pitch yaw] in ned coordinates

% Euler angular rate
att_dot = numdiff3(att, dt);

% angular velocity
phi_dot = att_dot(:,1);
theta_dot = att_dot(:,2);
psi_dot = att_dot(:,3);

s_phi = sin(att_x);
c_phi = cos(att_x);
s_theta = sin(att_y);
c_theta = cos(att_y);

w_x = -s_theta.*psi_dot + phi_dot;
w_y = c_theta.*s_phi.*psi_dot + c_phi.*theta_dot;
w_z = c_theta.*c_phi.*psi_dot - s_phi.*theta_dot;

att_v = [w_x w_y w_z];

% angualr acceleration
att_a = numdiff3(att_v, dt);

% angular jerk
att_j = numdiff3(att_a, dt);

% initial position
fprintf(fid, '-,INIT_POS,v1_m1,%.6f,%.6f,%.3f\n', lat(1), lon(1), hgt(1));

% arm and run
fprintf(fid, 'RU\n');

% mot command
for i = 1:n
	hh = floor(t(i)/3600);
    mm = mod(floor(t(i)/60),60);
    secs = mod(t(i),60);
    
    fprintf(fid, '0 %02d:%02d:%06.3f,mot,v1_m1,%+.12e,%+.12e,%+.12e,%+.12e,%+.12e,%+.12e,%+.12e,%+.12e,%+.12e,%+.12e,%+.12e,%+.12e,',...
        hh, mm, secs, pos(i,1), pos(i,2), pos(i,3), vel(i,1), vel(i,2), vel(i,3),...
        acc(i,1), acc(i,2), acc(i,3), jrk(i,1), jrk(i,2), jrk(i,3));
    
    fprintf(fid, '%+.12e,%+.12e,%+.12e,%+.12e,%+.12e,%+.12e,%+.12e,%+.12e,%+.12e,%+.12e,%+.12e,%+.12e\n',...
        att(i,3), att(i,2), att(i,1),... % heading (yaw), elevation (pitch), bank (roll)
        att_v(i,1), att_v(i,2), att_v(i,3),... % w_x, w_y, w_z
        att_a(i,1), att_a(i,2), att_a(i,3), att_j(i,1), att_j(i,2), att_j(i,3));
end

% stop scenario
fprintf(fid, '-,EN\n');

% close file
fclose(fid);

% map into local tangential coordinates
pos(:,1) = pos(:,1) - xr;
pos(:,2) = pos(:,2) - yr;
pos(:,3) = pos(:,3) - zr;
pos = pos*R';
vel = vel*R';
acc = acc*R';
jrk = jrk*R';

% plot
figure(10),plot(t,pos/1000,'.-'),grid
xlabel('Time [sec]'),ylabel('Position [km]')
legend('Up','East','North')
figure(11),plot(t,vel,'.-'),grid
xlabel('Time [sec]'),ylabel('Velocity [m/s]')
figure(12),plot(t,acc/9.8,'.-'),grid
xlabel('Time [sec]'),ylabel('Acceleration [G]')
figure(13),plot(t,jrk/9.8,'.-'),grid
xlabel('Time [sec]'),ylabel('Jerk [G/s]')

Deg = 180/pi;
figure(20),plot(t,att*Deg,'.-'),grid
xlabel('Time [sec]'),ylabel('Attitude [deg]')
legend('Roll (phi)', 'Pitch (theta)', 'Yaw (psi)')
figure(21),plot(t,att_v*Deg,'.-'),grid
xlabel('Time [sec]'),ylabel('Angular Velocity [deg/s]')
figure(22),plot(t,att_a*Deg,'.-'),grid
xlabel('Time [sec]'),ylabel('Angular Acceleration [deg/s^2]')
figure(23),plot(t,att_j*Deg,'.-'),grid
xlabel('Time [sec]'),ylabel('Angular Jaerk [deg/s^3]')

end % end of pos2GPSsim

%
% Lagrange' interpolating polynomial
%

function y = laginterp(x, h, n)

if n==1
    y = (-3*x(1)+4*x(2)-x(3))/2/h;
elseif n==3
    y = (x(1)-4*x(2)+3*x(3))/2/h;
else
    y = (-x(1)+x(3))/2/h;
end
end % end of laginterp

%
% Numerical differenciation for nx3 row vectors
%

function dx = numdiff3(x, h)

[n,m] = size(x);

dx = zeros(n,3);

dx(1,1) = laginterp(x(1:3,1),h,1);
dx(1,2) = laginterp(x(1:3,2),h,1);
dx(1,3) = laginterp(x(1:3,3),h,1);

for i=2:(n-1)
    dx(i,1) = laginterp(x((i-1):(i+1),1),h,2);
    dx(i,2) = laginterp(x((i-1):(i+1),2),h,2);
    dx(i,3) = laginterp(x((i-1):(i+1),3),h,2);
end

dx(n,1) = laginterp(x((n-2):n,1),h,3);
dx(n,2) = laginterp(x((n-2):n,2),h,3);
dx(n,3) = laginterp(x((n-2):n,3),h,3);

end % end of numdiff3

%
% local tangential coordinate matrix
%

function R = ltcmat(lat,lon)

lambda = lon;
phi = lat;

C = cos(-phi);
S = sin(-phi);
Ry = [C 0 -S; 0 1 0; S 0 C];

C = cos(lambda);
S = sin(lambda);
Rz = [C S 0; -S C 0; 0 0 1];

R = Ry*Rz; % Up-East-North coordinates

end % end of ltcmat
