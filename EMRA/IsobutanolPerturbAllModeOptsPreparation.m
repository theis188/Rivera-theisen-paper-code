ModeOpts.ImportParameters = [];
NoRxns = 193;
Uini = [ones(NoRxns,1); 0;0];
ModeOpts.Perts = repmat({Uini}, 1,NoRxns*2);

for n=1:NoRxns,
    ModeOpts.Perts{n}(n,:) = 10;
    ModeOpts.Perts{NoRxns+n}(n,:) = .1;
end

clear Uini n
tic
myCluster = parcluster('local');%
myCluster.NumWorkers = 40;
% 
delete(gcp)
parpool open 12
% pctRunOnAll warning off all
%MainAddFlux('USLowRespCellWideModel_AddiButPathways14mod3',300,'SeveralPerturbations',ModeOpts)
MainAddFlux('Original',300,'SeveralPerturbations',ModeOpts)
matlabpool close
toc
%EmailSender('lafonj@gmail.com','SimulationDone','Finished',[])