%Simulate SUs join and request available channels in Database-driven CRNs
clc;
clear;
global Database;
pa=parameter;
SUNumber=pa.SUNumber;%Number of SUs
SUProtectRange=pa.SUProtectRange;
SizeOfGrid=pa.SizeOfGrid;
RunTimes=pa.RunTimes;% Number of Cases
SpoofRange=pa.SpoofRange;%Spoofing capability
ChannelUsing=zeros(1,SUNumber);%Which channel the SU is using
Coordinate=cell(1,SUNumber);%Store coordinates for SUNumber SUs
SpoofedSUOriginalLocation=cell(1,SUNumber);%Store the original location of SUs spoofed
FalseAvailableChannel=zeros(1,SUNumber);%Store the channels falsely assigned to spoofed SUs
ChannelRunOut=zeros(1,RunTimes);%Store channel run out reports for initial set up for SUNmber SUs
FalseChannelRunOut=zeros(1,RunTimes);%Store how many SUs are falsly denied of service
InterferePU=zeros(1,RunTimes);%Store how many interference with PUs
CoexistenceSU=zeros(1,RunTimes);%Store how many coexistence problems with SU
SpoofedSUIndex=zeros(1,SUNumber);%Store the SU index in Coordinate
Error_estimation = cell(1,RunTimes);
Error_run = zeros(1,SUNumber);
for r=1:RunTimes
        Load_Initial_Database;%Reset Database 
        AttackerLocation=[unidrnd(SizeOfGrid),unidrnd(SizeOfGrid)];%Attacker Location
        [ row_lower,row_upper,column_lower,column_upper ] = SetAttackerSpoofBoundary(AttackerLocation(1,1),AttackerLocation(1,2) );
        SpoofedLocation=[unidrnd(SizeOfGrid),unidrnd(SizeOfGrid)];%Spoofing Location set by attacker
        SpoofedSUCount=1;
        %Initial Channel allocation for the first SUNumber SUs
    for i=1:SUNumber
        row=unidrnd(SizeOfGrid);
        column=unidrnd(SizeOfGrid);
        Coordinate{1,i}=[row,column];
       
        %Channel allocation
%         AvailableChannel=ChannelAllocation(row,column);
%         ChannelUsing(1,i)=AvailableChannel;
        
         %Check if the SU is within spoofing range, if so we store its
        %original location
        if((row>=row_lower)&&(row<=row_upper)&&(column>=column_lower)&&(column<=column_upper))

            SpoofedSUOriginalLocation{1,SpoofedSUCount}=[row,column];
            SpoofedSUIndex(1,SpoofedSUCount)=i;
            SpoofedSUCount=SpoofedSUCount+1;

        end
        
%         if(AvailableChannel==0)
%         ChannelRunOut(1,r)=ChannelRunOut(1,r)+1;%Store channel run out for every case
%         display('Oops!We are out of available channel!')
%         end
    end
        %
        [E,Degree]=CreateGraph(Coordinate);
        ChannelUsing=GreedyColoring(E,Degree,Coordinate);
        ChannelRunOut(1,r)=size(find(ChannelUsing(:)==0),1);
        %Check all spoofed SUs to see if there are any false channel run
        %out and interference with PU and coexistence problems with SU

        FalseCoordinate=Coordinate;
    for j=1:(SpoofedSUCount-1)
        FalseCoordinate{1,SpoofedSUIndex(1,j)}=SpoofedLocation;  
    end
    [FalseE,FalseDegree]=CreateGraph(FalseCoordinate);
    FalseChannelUsing=GreedyColoring(FalseE,FalseDegree,FalseCoordinate);
   
    for j=1:(SpoofedSUCount-1)
         %Check PU Interference
        if(FalseChannelUsing(1,SpoofedSUIndex(1,j))~=0)
            if(Database(FalseChannelUsing(1,SpoofedSUIndex(1,j)),Coordinate{1,SpoofedSUIndex(1,j)}(1),Coordinate{1,SpoofedSUIndex(1,j)}(2))~=0)
                InterferePU(1,r)=InterferePU(1,r)+1;%Mark as interference with PU 
            end
            %Check SU Coexistence Problem
            if(Degree(1,SpoofedSUIndex(1,j))~=0)
                Neighbors=[E(find(E(:,1)==SpoofedSUIndex(1,j)),2); E(find(E(:,2)==SpoofedSUIndex(1,j)),1)];%Find index of neighboring SUs
                for k=1:size(Neighbors,1)
                    if(FalseChannelUsing(1,SpoofedSUIndex(1,j))==FalseChannelUsing(1,Neighbors(k)))
                        CoexistenceSU(1,r)=CoexistenceSU(1,r)+1;%Mark as coexistence problems with SU
                        break;
                    end
                end
            end
        end
    end
    %Check False Deny of Service
    FalseChannelRunOut(1,r)=size(find(FalseChannelUsing(:)==0),1);
    display(r);
   
  %  [NumVerified,Error_run,t,per,s,GArrayVerified] = G_Verify();
    %Error_estimation{1,r} = [NumVerified,Error_run,t,per,s];
 end
    filename=['Result_SUNUmber_',num2str(SUNumber),'_SUProtectRange_',num2str(SUProtectRange),'_SpoofRange_',num2str(SpoofRange)];
    save(filename,'FalseChannelRunOut','InterferePU','CoexistenceSU','ChannelRunOut');
     save('Coordinate_file.mat','FalseCoordinate');
    
    