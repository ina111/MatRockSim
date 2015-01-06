% ===== RocketSim =====
% 6自由度の運動を行う飛翔体の飛翔シミュレータ
% Matlab2014RとOctave3.6.4で動作を確認。
% 
% Copyright (C) 2014, Takahiro Inagawa
% This program is free software under MIT license.
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.
% ======================
% function f = fsolve_altitude( burn_time)

global ROCKET
% addpath ./quaternion
% addpath ./environment
% addpath ./aerodynamics
% addpath ./mapping
% addpath ./gpssim
% addpath ./3dof

% ---- パラメータ設定読み込み ----
% params_test
params_3dof
% params_M3S
% ROCKET.Tend = burn_time;
ROCKET.Tend = 10;

% ---- 常微分方程式 ----
AbsTol = [1e-4; % m
          1e-4; 1e-4; 1e-4; % pos
          1e-4; 1e-4; 1e-4]; % vel
options = odeset('Events', @events_land, 'RelTol', 1e-3, 'AbsTol', AbsTol);
time_end = 1000;

disp('Start Simulation...');

tic
[T, X] = ode23s(@rocket_dynamics_3dof, [0 time_end], x0, options);
toc

max_altitude = max(X(:,2)); % altitude
f = max_altitude - 100000;
