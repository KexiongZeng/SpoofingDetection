%Debug
 ans=ismember(SpoofedSUIndex,AnchorIndex);%Falsenegative
 find(ans);
 find(BadAnchor);
 find(SuspiciousFlag(1,:)==2);
 find(SuspiciousFlag(1,:)==1);
 
 ans=ismember(SuspiciousIndex,AnchorIndex);
 %check repeated initial anchors
for i=1:2474
   for j=i+1:2474
      if(AnchorIndex(1,i)==AnchorIndex(1,j)) 
          display(i);
          display(j);
          break;
      end
   end
end
SuspiciousIndex=[find(SuspiciousFlag(1,:)==1),find(SuspiciousFlag(1,:)==2)];
 ans=ismember(SuspiciousIndex,SpoofedSUIndex);
 find(ans(1,:)==0)
 SuspiciousIndex(1,32)
 RealCoordinate{1,SuspiciousIndex(1,32)}

 