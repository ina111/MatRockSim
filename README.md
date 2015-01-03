# MatRockSim

Matlab Rocket Flight Simulator

6自由度のロケットフライトシミュレーター。水平座標系での飛翔をシミュレーション。

## 実行
Matlab/OctaveでMatRockSimフォルダ内で下記コマンドで実行。

    MatRockSim


## パラメータ設定
- params.mファイルの中身を変更
- aerodynamics/cd_Rocket.mファイルを変更することによって抗力係数の変更

## Future Works
- 慣性モーメントの時間変化。（推力とXdotなどの連携）
- 圧力中心の遷移(Barrowman method??, マッハ数依存の空力モーメント係数 ??)
- 上空の風の変化に対応
- ランチャー離脱時のチップオフ
- 航法誘導、姿勢制御、シーケンス制御

## Simulink使い方
Matlabを起動し、コマンドウィンドウでInitiallize.mを回す
>> Initiallize
simulink_MatRockSim.slxを起動し、Simulink上でシミュレーション。
