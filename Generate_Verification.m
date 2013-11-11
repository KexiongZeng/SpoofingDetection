clear;
pa = parameter;
SUNumber = pa.SUNumber;
clearvars -global AnchorNodes
%Coordinate = pa.Coordinate;
global AnchorNodes
%global AnchorNodesAvailable
tmp = load('RealCoordinate.mat');
RealCoordinate = tmp.Coordinate;
BeaconRange = pa.BeaconRange;
ErrorTolerance = pa.ErrorTolerance;

NumInitialAnchors = pa.NumInitialAnchors;

AnchorNodes{1,1} = [0,0,0];
RepeatedAnchor = 1;
[p,q,r,s]=CheckConnectivity(RealCoordinate,BeaconRange);
for i=1:NumInitialAnchors
    RepeatedAnchor=1;
    while(RepeatedAnchor)
    AnchorNum = unidrnd(SUNumber);
    RepeatedAnchor = CheckRepeatedAnchor(AnchorNum);
    end  
    InitialAnchorCoordinates = RealCoordinate{1,AnchorNum};
    AnchorNodes{i,1} = [InitialAnchorCoordinates(1,1),InitialAnchorCoordinates(1,2),AnchorNum];
end
NewAnchorAvailable = cell(1,1);
NewAnchorAvailable{1,1} = [0,0,0];
NumChecked = NumInitialAnchors;
LastNumChecked=0;
time = 1;
while(NumChecked >LastNumChecked)%If no more nodes can be verified
    clearvars NewAnchorAvailable;
    NewAnchorAvailable = cell(1,1);
    LastNumChecked=NumChecked;
    NewAnchorAvailable{1,1} = [0,0,0];
    index = 1;
%     if(time > 1)
%         display('Gets stuck');
%     end
    for i = 1: SUNumber
        SUCoordinates = RealCoordinate{1,i};
        AlreadyChecked = CheckRepeatedAnchor(i);
        if(AlreadyChecked ~=1)
            [AnchorRow,AnchorColumn,TotalAnchorsAvailable] = CheckForAvailableAnchors(SUCoordinates(1,1),SUCoordinates(1,2),BeaconRange);
            if(TotalAnchorsAvailable>=1)
               %display('cannot Verify');
          
                
               
                    SumX = sum(AnchorRow);
                    SumY = sum(AnchorColumn);
              
                XEst = SumX / (TotalAnchorsAvailable);
                YEst = SumY / (TotalAnchorsAvailable);
            
            Error_est = (XEst-SUCoordinates(1,1)).^2 + (YEst-SUCoordinates(1,2)).^2; %wrong   you need to sqrt
            
                if(Error_est <= ErrorTolerance)
                NewAnchorAvailable{index,1} = [XEst,YEst,i];% Using estimate location as new anchor location is wrong. Estimation locations are not real topologies, we need to check for available anchors from real topology graph.
                index = index + 1;
                NumChecked = NumChecked + 1;
                display('We got a new anchor!');
                end
            end    
        end
    end
    [mNewAnchor,nNewAnchor]=size(NewAnchorAvailable);
    [mAnchorList,nAnchorList] = size(AnchorNodes);
    Value_Beginning = NewAnchorAvailable{1,1}(1,1);
    if(Value_Beginning ~= 0)
        for k = 1: mNewAnchor
            AnchorNodes{mAnchorList+k,1} = NewAnchorAvailable{k,1};        
        end
    end
    time = time + 1;
end
