

fileID = fopen('winequality-white.csv','r');
A = fgetl(fileID);
C = strsplit(A,';');

%reda file,get rows

for i=1:4898,
    ab=strsplit(fgetl(fileID),';');
values(i,:)=[1;cellfun(@str2num,ab).'];
end
fclose(fileID);

%feature scaling with range(0,1) 
for i=2:12,
values(:,i)=values(:,i)./ max(values(:,i));
end

allvalues=values(:,[1:12]);
labels=values(:,13);


 aug=allvalues(:,1);
 freesulfurdioxcide=allvalues(:,7);
 totalsulfurdioxide=allvalues(:,8);
 alcohol=allvalues(:,12);
 
 orgvalues=[aug,freesulfurdioxcide,totalsulfurdioxide,alcohol];


%generate class label vector
 labeldeger=zeros(4898,7);
 for i=1:7,
 labeldeger(find(labels(:)==i+2),i)=1;
 end

 %FIRST PART
 
 
 %find optimal tetas
tet=findtetas(orgvalues,labeldeger);

%find hvalues
for i=1:7,
hvals(i,:)=hteta(tet(i,:),orgvalues);
end


[M,I]=max(hvals);

%find accuracy

I=(I+2)';
accuracyfirstpart=(length(labels)-length(find(I~=labels)))/length(labels)

%SECOND PART
%cross validation,split data to 6,iterate 6,so every data will be training and test;
iterat=1;
for i=1:6,
temptest=orgvalues([iterat:800+iterat],:);
temptrain=[orgvalues([1:iterat],:);orgvalues([iterat+800:4898],:)];
    

templabeldeger =[labeldeger([1:iterat],:);labeldeger([iterat+800:4898],:)];
templabels=labels([iterat:800+iterat],:);
tet2=findtetas(temptrain,templabeldeger);


for j=1:7,
hvals2(j,:)=hteta(tet2(j,:),temptest);
end

[M,I2]=max(hvals2);

I2=(I2+2)';
accuracy2(i,:)=(length(templabels)-length(find(I2~=templabels)))/length(templabels);
iterat=iterat+800;
end

accuracysecondpart=mean(accuracy2)

%THIRD PART
%feature mapping,3 feature selected (fixed freesulfurdioxcide,citric acid,alcoholides)



mapvalues=[aug,freesulfurdioxcide,totalsulfurdioxide,alcohol,prod([freesulfurdioxcide,freesulfurdioxcide],2),prod([freesulfurdioxcide,totalsulfurdioxide],2),prod([freesulfurdioxcide,alcohol],2),prod([alcohol,alcohol],2),prod([alcohol,totalsulfurdioxide],2),prod([totalsulfurdioxide,totalsulfurdioxide],2)];




tet3=findtetas(mapvalues,labeldeger);

for i=1:7,
hvals3(i,:)=hteta(tet3(i,:),mapvalues);
end


[M3,I3]=max(hvals3);

I3=(I3+2)';
accuracythirdpart=(length(labels)-length(find(I3~=labels)))/length(labels)



