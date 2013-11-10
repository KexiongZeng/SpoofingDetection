%GeneradeCoordinate
pa=parameter;
SUNumber=pa.SUNumber;
SizeOfGrid=pa.SizeOfGrid;
SpoofRange=pa.SpoofRange;
Coordinate=cell(1,SUNumber);%Store coordinates for SUNumber SUs
AttackerLocation=[unidrnd(SizeOfGrid),unidrnd(SizeOfGrid)];%Attacker Location
SpoofedLocation=[unidrnd(SizeOfGrid),unidrnd(SizeOfGrid)];%Spoofing Location set by attacker
[ row_lower,row_upper,column_lower,column_upper ] = SetBoundary(AttackerLocation(1,1),AttackerLocation(1,2),SpoofRange);
SpoofedSUCount=1;
SpoofedSUIndex=zeros(1,SUNumber);%Store the SU index in Coordinate
SpoofedSUOriginalLocation=cell(1,SUNumber);%Store the original location of SUs spoofed
for i=1:SUNumber
    row=unidrnd(SizeOfGrid);
    column=unidrnd(SizeOfGrid);
    Coordinate{1,i}=[row,column];
        if((row>=row_lower)&&(row<=row_upper)&&(column>=column_lower)&&(column<=column_upper))

            SpoofedSUOriginalLocation{1,SpoofedSUCount}=[row,column];
            SpoofedSUIndex(1,SpoofedSUCount)=i;
            SpoofedSUCount=SpoofedSUCount+1;

        end
end

 FalseCoordinate=Coordinate;
 SpoofedSUCount=SpoofedSUCount-1;
 for j=1:SpoofedSUCount
        FalseCoordinate{1,SpoofedSUIndex(1,j)}=SpoofedLocation;      
 end
 
    save('RealCoordinate.mat','Coordinate');
    save('FalseCoordinate.mat','FalseCoordinate');
    save('SpoofedSUCount.mat','SpoofedSUCount');