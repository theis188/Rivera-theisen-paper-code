ModeOpts.ImportParameters = [];
Uini = [ones(193,1); 0;0];

%Unrobust enzymes are the ones with Si>.05 in AddiButPahtways13
Unrobust = [4    12    14    24    27    28    38    40    43    47    50    67    68    70    83    86    90    93    99   108   110   113   120   121   125   130   131   138   157   162   163   167   190   191   192   193];

ModeOpts.Perts = repmat({Uini}, 1,length(Unrobust)*2);

for n=1:length(Unrobust),
    ModeOpts.Perts{n}(Unrobust(n),:) = 10;
    ModeOpts.Perts{length(Unrobust)+n}(Unrobust(n),:) = .1;
end

clear Uini n
tic
myCluster = parcluster('local');
myCluster.NumWorkers = 40;

matlabpool open 39
pctRunOnAll warning off all
MainAddFlux('USLowRespCellWideModel_AddiButPathways14mod4',150,'SeveralPerturbations',ModeOpts)
matlabpool close
toc
EmailSender('lafonj@gmail.com','SimulationDone','Finished',[])