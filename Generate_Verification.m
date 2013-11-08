pa = parameter;
SUNumber = pa.SUNumber;
clearvars -global AnchorNodes
%Coordinate = pa.Coordinate;
global AnchorNodes
%global AnchorNodesAvailable
tmp = load('Coordinate_file.mat');
FalseCoordinate = tmp.FalseCoordinate;
MaxRangeGrid = 1;
ErrorTolerance = 2;

NumInitialAnchors = 50;

AnchorNodes{1,1} = [0,0,0];
RepeatedAnchor = 1;

for i=1:NumInitialAnchors
    RepeatedAnchor=1;
    while(RepeatedAnchor)
    AnchorNum = unidrnd(SUNumber);
    RepeatedAnchor = CheckRepeatedAnchor(AnchorNum);
    end  
    InitialAnchorCoordinates = FalseCoordinate{1,AnchorNum};
    AnchorNodes{i,1} = [InitialAnchorCoordinates(1,1),InitialAnchorCoordinates(1,2),AnchorNum];
end
NewAnchorAvailable = cell(1,1);
NewAnchorAvailable{1,1} = [0,0,0];
NumChecked = NumInitialAnchors;
time = 1;
while(NumChecked <= SUNumber)
    clearvars NewAnchorAvailable;
    NewAnchorAvailable = cell(1,1);
    NewAnchorAvailable{1,1} = [0,0,0];
    index = 1;
    if(time > 1)
        display('Gets stuck');
    end
    for i = 1: SUNumber
        SUCoordinates = FalseCoordinate{1,i};
        AlreadyChecked = CheckRepeatedAnchor(i);
        if(AlreadyChecked ~=1)
            [AnchorRow,AnchorColumn,TotalAnchorsAvailable] = CheckForAvailableAnchors(SUCoordinates(1,1),SUCoordinates(1,2),MaxRangeGrid);
        if(TotalAnchorsAvailable<1)
            display('cannot Verify');
        else
            NumChecked = NumChecked + 1;
            SumX = 0;
            SumY = 0;
            for j = 1: TotalAnchorsAvailable
                SumX = SumX + AnchorRow(j);
                SumY = SumY + AnchorColumn(j);
            end
            XEst = SumX / (TotalAnchorsAvailable);
            YEst = SumY / (TotalAnchorsAvailable);
            
            Error_est = (XEst-SUCoordinates(1,1)).^2 + (YEst-SUCoordinates(1,2)).^2;
            
            if(Error_est <= ErrorTolerance)
                NewAnchorAvailable{index,1} = [XEst,YEst,i];
                index = index + 1;
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
