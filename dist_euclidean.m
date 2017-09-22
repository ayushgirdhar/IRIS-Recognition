function d=dist_euclidean(x,y)
d=sum(sum((x-y).^2)).^0.5;
end