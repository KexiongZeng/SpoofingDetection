clear;
clearvars -global AnchorNodes
clearvars -global AnchorIndex
clearvars -global SuspiciousFlag
global AnchorNodes;
global AnchorIndex;
global SuspiciousFlag;
global RealCoordinate;
global FalseCoordinate;
global SpoofedSUCount
global SpoofedSUIndex;
global AttackerLocation;
global SpoofedLocation;
pa = parameter;
SUNumber = pa.SUNumber;
RunTimes=pa.RunTimes;
UnverifiedArray=zeros(1,RunTimes);
SpoofedArray=zeros(1,RunTimes);
TimeConsumption=zeros(1,RunTimes);
for r=1:RunTimes
    GenerateCoordinate;
%     tmp = load('RealCoordinate.mat');
%     RealCoordinate = tmp.Coordinate;
%     tmp=load('FalseCoordinate.mat');
%     FalseCoordinate=tmp.FalseCoordinate;
%     tmp=load('SpoofInfo.mat');
%     SpoofedSUCount=tmp.SpoofedSUCount;   
%     SpoofedSUIndex=tmp.SpoofedSUIndex;
    SpoofedArray(1,r)=SpoofedSUCount;
    BeaconRange = pa.BeaconRange;
    ErrorTolerance = pa.ErrorTolerance;
    NumInitialAnchors = pa.NumInitialAnchors;
    EstLocation=cell(1,SUNumber);%Estimated Location
    %[p,q,r,s]=CheckConnectivity(FalseCoordinate,BeaconRange);%output r tells you which nodes of p belong to the same connected component
    InitialAnchor=cell(1,NumInitialAnchors);
    AnchorIndex=zeros(1,NumInitialAnchors);%index of current anchors 
    SuspiciousFlag=zeros(1,SUNumber);%initial anchors may be suspicious nodes
    for i=1:NumInitialAnchors
        ind = unidrnd(SUNumber);
        % prevent repeated initial anchors
        while(find(AnchorIndex(1,:)==ind))
            ind=ind+1;
        end
        InitialAnchor{1,i} = [RealCoordinate{1,ind}(1),RealCoordinate{1,ind}(2),ind];
        AnchorIndex(1,i)=ind;
        %Check if initial anchors are under attack
        Lia=ismember(SpoofedSUIndex,ind);
        if(sum(Lia))
           SuspiciousFlag(1,ind)=1; %raise a suspicion so this node can never be verified
        end
    end
    %BadInitialNum=sum(SuspiciousFlag);%number of bad initial anchors
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
            RealSUCoordinates = RealCoordinate{1,i};
            FalseSUCoordinates = FalseCoordinate{1,i};
            AlreadyChecked = CheckRepeatedAnchor(i);
            % It's already verified or not
            if(AlreadyChecked~=1&&SuspiciousFlag(1,i)~=1)
                [row,column,AnchorsAvailable] = CheckForAvailableAnchors(RealSUCoordinates(1,1),RealSUCoordinates(1,2),BeaconRange);%use real topology 
                % Have anchor neighbors

                if(AnchorsAvailable>0)
                    SumX = sum(row);
                    SumY = sum(column);

                    XEst = SumX / (AnchorsAvailable);
                    YEst = SumY / (AnchorsAvailable); 
                    EstLocation{1,i}=[XEst,YEst];
                    %FalseSUCoordinates are GPS reported locations
                    Error_est = sqrt((XEst-FalseSUCoordinates(1,1))^2 + (YEst-FalseSUCoordinates(1,2))^2);
                    % We have to store all new anchors and add them after one
                    % loop
                    if(Error_est<=ErrorTolerance)
                        NumChecked = NumChecked + 1;
                        NewAnchorAvailable{1,NewInd}=[FalseSUCoordinates(1,1),FalseSUCoordinates(1,2),i];% Use GPS location for new anchors
                        %NewAnchorAvailable{1,NewInd}=[XEst,YEst,i];% Use estimated location for new anchors
                        NewInd=NewInd+1;
                        SuspiciousFlag(1,i)=0;
                        display('We got a new anchor!');
                    else
                        SuspiciousFlag(1,i)=1;%raise a suspicion so this node can never be verified
                        display('We got a suspicious node!');
                    end
                else %(AnchorsAvailable==0)
                        SuspiciousFlag(1,i)=2;%We are not sure because this node can hear no anchors
                        display('We are not sure about this node!');
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
    SuspiciousIndex=[find(SuspiciousFlag(1,:)==1),find(SuspiciousFlag(1,:)==2)];
    [m,n]=size(SuspiciousIndex);
    UnverifiedArray(1,r)=n;%All suspicious nodes including spoofing and cannot localization
    FalsePositive=UnverifiedArray-SpoofedArray; % plus means normal node is mistakenly considered as spoofed nodeswhile minus means spoofed nodes are not detected .
    TimeConsumption(1,r)=time;
end

filename=['Result_SUNumber_',num2str(SUNumber),'_BeaconRange_',num2str(BeaconRange),'_ErrorTolerance_',num2str(ErrorTolerance)];
    save(filename,'FalsePositive','SpoofedArray','UnverifiedArray');