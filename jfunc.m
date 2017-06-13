function [j,jt] = jfunc(teta,x,labels,m)

j1=(labels) .* log (hteta(teta,x)) + (1-labels) .* log(1-hteta(teta,x));

j=-sum(j1)/m;
[r,c]=size(x);
for i=1:c,
jt1(:,i)=(hteta(teta,x)-labels) .* x(:,i) ;
end
jt=sum(jt1)/m;
end