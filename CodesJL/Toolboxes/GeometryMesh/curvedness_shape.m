function [Curvedness,ShapeIndex,stats]=curvedness_shape(curvatures,ord)

if ord
    curvatures=sort(curvatures,2,'descend');
end

ShapeIndex=(2/pi)*atan((curvatures(:,1)+curvatures(:,2))./(curvatures(:,1)-curvatures(:,2)));
Curvedness=sqrt((curvatures(:,1).^2+curvatures(:,2).^2)/2);
stats(1)=mean(Curvedness);
stats(2)=mean(ShapeIndex(find(ShapeIndex>0)));
stats(3)=mean(ShapeIndex(find(ShapeIndex<0)));
stats(4)=median(Curvedness);
stats(5)=median(ShapeIndex(find(ShapeIndex>0)));
stats(6)=median(ShapeIndex(find(ShapeIndex<0)));
stats(7)=max(Curvedness);