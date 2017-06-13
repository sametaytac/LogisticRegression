function tetas = findtetas( class1,labels )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[r,c]=size(class1);
a=ones(1,c);
b=length(labels);
for i=1:7,
f = @(teta)jfunc(teta,class1,labels(:,i),b);
options = optimset('GradObj','on');
tetas(i,:)=fminunc(f,a,options);
end

end

