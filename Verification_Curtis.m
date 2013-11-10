clear;
clearvars -global AnchorNodes
clearvars -global AnchorIndex
global AnchorNodes;
global AnchorIndex;
pa = parameter;
SUNumber = pa.SUNumber;
tmp = load('RealCoordinate.mat');
RealCoordinate = tmp.Coordinate;
tmp=load('FalseCoordinate.mat');
FalseCoordinate=tmp.FalseCoordinate;
BeaconRange = pa.BeaconRange;
ErrorTolerance = pa.ErrorTolerance;
NumInitialAnchors = pa.NumInitialAnchors;
[p,q,r,s]=CheckConnectivity(RealCoordinate,BeaconRange);%output r tells you which nodes of p belong to the same connected component
InitialAnchor=cell(1,NumInitialAnchors);
AnchorIndex=zeros(1,NumInitialAnchors);%index of current anchors 
for i=1:NumInitialAnchors
    ind = unidrnd(SUNumber);
    InitialAnchor{1,i} = [RealCoordinate{1,ind}(1),RealCoordinate{1,ind}(2),ind];
    AnchorIndex(1,i)=ind;
end
AnchorNodes=InitialAnchor;%Keep track on all anchors
NumChecked = NumInitialAnchors;
LastNumChecked=0;
time = 0;

%Veification Process
while(NumChecked >LastNumChecked&&NumChecked~=SUNumber)%If no more nodes can be verified
   NewAnchorAvailable = cell(1,1);
   NewAnchorAvailable{1,1} = [0,0,0];
   LastNumChecked=NumChecked;
   NewInd=1;
   %One time verification
   for i=1:SUNumber
        SUCoordinates = RealCoordinate{1,i};
        AlreadyChecked = CheckRepeatedAnchor(i);
        % It's already verified or not
        if(AlreadyChecked~=1)
            [row,column,AnchorsAvailable] = CheckForAvailableAnchors(SUCoordinates(1,1),SUCoordinates(1,2),BeaconRange);
            % Have anchor neighbors
            
            if(AnchorsAvailable>0)
                SumX = sum(row);
                SumY = sum(column);
              
                XEst = SumX / (AnchorsAvailable);
                YEst = SumY / (AnchorsAvailable); 
                Error_est = sqrt((XEst-SUCoordinates(1,1))^2 + (YEst-SUCoordinates(1,2))^2);
                % We have to store all new anchors and add them after one
                % loop
                if(Error_est<=ErrorTolerance)
                    NumChecked = NumChecked + 1;
                    NewAnchorAvailable{1,NewInd}=[SUCoordinates(1,1),SUCoordinates(1,2),i];% Use GPS location for new anchors
                    %NewAnchorAvailable{1,NewInd}=[XEst,YEst,i];% Use estimated location for new anchors
                    NewInd=NewInd+1;
                    display('We got a new anchor!');
                end
            end
        end
   end
   %Add new anchors to anchor list
    [mNewAnchor,nNewAnchor]=size(NewAnchorAvailable);
    [mAnchor,nAnchor] = size(AnchorNodes);
    Value_Beginning = NewAnchorAvailable{1,1}(3);
    if(Value_Beginning ~= 0)
        for k = 1: nNewAnchor
            AnchorNodes{1,nAnchor+k} = NewAnchorAvailable{1,k};        
            AnchorIndex(1,nAnchor+k)= NewAnchorAvailable{1,k}(3); 
        end
    end
    time = time + 1;
end