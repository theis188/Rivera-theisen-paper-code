%function Yield = MaxGlcYieldFinder(file)
clear
file = 'FinalSimp'
load(strcat(file,'.mat'))

b = zeros(size(Net.MetabName))
lb = zeros(size(Net.Vref))
ub = inf(size(Net.Vref))
lb(11,1) = 10
lb(11,1) = 10
f = zeros(11,1)
f(7,1) = -1

v = linprog(f,[],[],Net.S,b,lb,ub,[],optimoptions('linprog','MaxIter',10000))

GlcYield = v(7,1)/v(5,1)

