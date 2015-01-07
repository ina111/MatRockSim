function output = cd_Rocket(Mach)
% CD_ROCKET マッハ数依存の抗力係数
% サンプルとしてM-Vロケットの空力特性の論文の抗力係数をいれている。
% @param Mach マッハ数[-]
% @return output 抗力係数[-]
M = [0 0.2 0.4 0.6 0.8 1.0 1.1 1.2 1.4 1.6 1.8 2.0 2.5 3.0 3.5 4.0 5.0];
cd_row = [0.28 0.28 0.28 0.29 0.35 0.64 0.67 0.69 0.66 0.62 0.58 0.55 ...
0.48 0.42 0.38 0.355 0.33];
output = interp1(M, cd_row, Mach,'spline');
% output = interp1(M, cd_row, Mach,'linear');
