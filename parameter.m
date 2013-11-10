% parameter.m
function pa=parameter
%pa.dtn='tvdata_24649.txt';
pa.PowerThresh = -114 ; % Power level in dBm to indicate if a channel is available
pa.NumOfPoints = 25600; % Num of Points used from L-R model
pa.SizeOfGrid = sqrt(pa.NumOfPoints);%Square size
pa.NumOfTowers = 10; % Total Num of Towers/Channels considered
pa.NumOfSimulatedTowers = 10; % Num of Towers whose Propagation characteristics is considered
% pa.dtbs=importdata(pa.dtn);
% pa.dtbs(:,3)=pa.dtbs(:,3)-129.05; % converts power in dBu to dBm
pa.Resolution=8;%0.5mile=800m resolution
%Every gird is 121.1m north-south and 96.3m east-west
%157*157 square
pa.SUProtectRange=1;%Neighboring Protected Range
pa.SUNumber=500;
pa.SpoofRange=10;
pa.RunTimes=50;
pa.BeaconRange=5;
pa.ErrorTolerance=8;
pa.NumInitialAnchors=round(pa.SUNumber*0.01);