% eigen faces
clc;clear all;close all;
% c1 = load('conc10.txt');
% c2 = load('conc50.txt');
% c3 = load('conc125.txt');
% c4 = load('conc250.txt');

mydir = pwd;
myf = dir(fullfile(mydir,'TS4*.txt'))
indf = 5; %length(myf)

for i = 1:indf,
    is = int2str(i);
    v = genvarname('p', is);
%     data = close allload(myf(i).name);
    eval(['p' is '= -load(myf(i).name);' ]);
end
% figure; imagesc(p1); colorbar
% p1 = -load('phase1.txt');
% p2 = -load('phase2.txt');
% p3 = -load('phase3.txt');
% p4 = -load('phase4.txt');
% p5 = -load('phase5.txt');
% p6 = -load('phase6.txt');
% p7 = -load('phase7.txt');
% p8 = -load('phase8.txt');
% p9 = -load('phase9.txt');
% p10 = -load('phase10.txt');

for i = 1:indf,
    is = int2str(i);
    genvarname('p', is);
    eval(['p' is '= 0.5*(p' is ' + 1);']);
end
min(min(p5))
max(max(p5))

% figure;imagesc(p1);colorbar;
% figure;imagesc(p2);colorbar;
% figure;imagesc(p3);colorbar;
dim1 = 400;
p1 = reshape(p1,[dim1^2,1]);
p2 = reshape(p2,[dim1^2,1]);
p3 = reshape(p3,[dim1^2,1]);
p4 = reshape(p4,[dim1^2,1]);
p5 = reshape(p5,[dim1^2,1]);
% p6 = reshape(p6,[dim1^2,1]);
% p7 = reshape(p7,[dim1^2,1]);
% p8 = reshape(p8,[dim1^2,1]);
% p9 = reshape(p9,[dim1^2,1]);
% p10 = reshape(p10,[dim1^2,1]);
% p1 = p1/norm(p1);
% p2 = p2/norm(p2);
% p3 = p3/norm(p3);
% p4 = p4/norm(p4);
% p5 = p5/norm(p5);
% p6 = p6/norm(p6);
% p7 = p7/norm(p7);
% p8 = p8/norm(p8);
% p9 = p9/norm(p9);
% p10 = p10/norm(p10);





% p1 = (p1+1.0)/2.;
% p2 = (p2+1.0)/2.;
% p3=(p3+1.0)/2.;
% p4 = (p4+1.)/2.;

S = [p1, p2,p3,p4,p5];%,p6,p7,p8,p9,p10];
[row, col] = size(S);
clear p*
psi = zeros(dim1^2,1);
% size(S)
% make mean
for i = 1:col;
    psi = psi + S(:,i);
end
psi = psi'/col;% mean face
% psi = mean(S');

% figure;imagesc(reshape(psi,[dim1 dim1]));
% phi = zeros(1250
phi = zeros(dim1^2,col);
for i = 1:col;
    phi(:,i) = S(:,i)-psi';
end
mean2(phi);
% clear S;

% % calcualte covariance matrix
% C = zeros(dim1,1);
% for i = 1:col
%     C(:,i) = phi(:,i)'*phi(:,i);
% end
% C = C/col;
C = phi'*phi/col;
% C = C/col;
% C = cov(phi)/indf;
% [vec,val]

[u,el] = eig(C);
% alt
lamb = eig(C);
lamb = fliplr(lamb');
% 
% for i = 1:indf
%     b(:,i) = null(C-eye(10,10)*lamb(i));
% end


eigpca = fliplr(diag(el));
eigsum = sum(eigpca);
% csum = zeros(1,length(eigpca));
csum = 0
for i =1:length(eigpca);
    csum = csum +eigpca(i);
    eigcs(i) = csum;
end
% figure;plot(1:length(eigpca),eigcs/eigsum,'x--');
    


% this step is ok because ^^^
% rank of COV matrix is limited
% by number of training samples


phi = phi';
u = fliplr(u);
% need to normalize!
% f = u'*phi;
f = u'*phi;
f2 = u*phi;

% alt is phi'*u == same thing as above
% f is now the eigen vector we had seked in
% % a easier way


% not real eigen
%  waht do ?
% f2 = u*phi;
% clear C %psi
for i = 1:col
    f(i,:) = f(i,:)/norm(f(i,:));
    f2(i,:) = f(i,:)/norm(f(i,:));
    figure;imagesc(reshape(f(i,:),[dim1 dim1]))
end
% 
figure;
plot(1:length(eigpca),-eigpca,'x--')
title('skree plot')
figure;plot(1:length(eigpca),eigcs/eigsum,'x--');
title('cumsum of eigenvalues')
x = 1:0.1:10,
figure
plot(x,1-1./x);
title('example of a good eigen-cumsum');
% figure;