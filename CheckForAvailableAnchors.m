function [RowAnchor,ColumnAnchor,NumAnchorsAvailable] = CheckForAvailableAnchors(Row,Column,Range)
pa = parameter;
SizeOfGrid = pa.SizeOfGrid;
global AnchorNodes;
RowAnchor = zeros(1,100);
ColumnAnchor = zeros(1,100);

row_lower = Row - Range;
row_upper = Row + Range;
col_lower = Column - Range;
col_upper = Column + Range;

if(row_lower < 1)
    row_lower = 1;
end

if(row_upper > SizeOfGrid)
    row_upper = SizeOfGrid;
end

if(col_lower < 1)
    col_lower = 1;
end

if(col_upper > SizeOfGrid)
    col_upper = SizeOfGrid;
end

[mAnchorList,nAnchorList]= size(AnchorNodes);
NumAnchorsAvailable = 0;
k=1;
for i = 1: mAnchorList
    
    anchor_data = AnchorNodes{i,1};
    
    if(anchor_data(1,1)>=row_lower && anchor_data(1,1) <= row_upper && anchor_data(1,2)>=col_lower && anchor_data(1,2)<= col_upper)
        RowAnchor(k) = anchor_data(1,1);
        ColumnAnchor(k) = anchor_data(1,2);
        NumAnchorsAvailable = NumAnchorsAvailable + 1;
        k=k+1;
    end
end
if(NumAnchorsAvailable >0)     
    RowAnchor = RowAnchor(1:NumAnchorsAvailable);
    ColumnAnchor = ColumnAnchor(1:NumAnchorsAvailable);
end
    
end