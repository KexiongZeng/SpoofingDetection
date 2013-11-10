% check connectivity

function [p,q,r,s]=CheckConnectivity(Coordinate,BeaconRange)
pa=parameter;
SUNumber=pa.SUNumber;
%E=zeros(SUNumber^2,2);%pairwise connections
A=zeros(SUNumber,SUNumber);
%k=1;
for i=1:SUNumber
          X_1=Coordinate{1,i}(1);
          Y_1=Coordinate{1,i}(2);
    [row_lower,row_upper,column_lower,column_upper]=SetBoundary(X_1,Y_1,BeaconRange );
    for j=i+1:SUNumber
          X_2=Coordinate{1,j}(1);
          Y_2=Coordinate{1,j}(2);
        if(X_2>=row_lower&&X_2<=row_upper&&Y_2>=column_lower&&Y_2<=column_upper)
%             E(k,1)=i;
%             E(k,2)=j;
%             k=k+1;
%             E(k,1)=j;
%             E(k,2)=i;
%             k=k+1;
            A(i,j)=1;
            A(j,i)=1;
        end
    end
end
A(logical(eye(size(A))))=1;%Assign 1 to diagonal elements
[p,q,r,s]=dmperm(A);%r is connected components
