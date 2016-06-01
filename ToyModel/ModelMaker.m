clear
load('SimpMod.mat')

MetabList = {'Lac','Glut','Prop','Eth','Acet'}

A = cellfun(@(x) find(strcmp(x,Net.MetabName)), MetabList)
Net.MetabName(A) = []
Net.S(A,:) = []

beq = [0; 0; 0; 0; 0]
lb = zeros(12,1)
ub = inf(12,1)
lb(12) = 10;
ub(12) = 10;

b_con = [0; 0; 0; 0; 0];
S_con = zeros(5,12);
S_con(1,[1 7]) = [-1 1];
S_con(2,[9 10]) = [-1 1];
S_con(3,[2 6]) = [-1 1];
S_con(4,[3 11]) = [-1 1];
S_con(5,[8 11]) = [-1 5];

f = zeros(12, 1);
f(8,1) = 1

v = linprog(f,[],[],[Net.S; S_con],[beq; b_con],lb,ub,[],optimoptions('linprog','MaxIter',10000))

Net.S(:,5) = [];
Net.EnzName(5,:) = []
Net.Reversibilities(5,:) = []
Net.Sreg = zeros(size(Net.S))
v(5,:) = [];

Net.Vref = v;

save('FinalSimp','Net')
