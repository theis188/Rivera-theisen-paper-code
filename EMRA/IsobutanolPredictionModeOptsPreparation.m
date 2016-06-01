ModeOpts.ImportParameters = [];
nEnz = 193;
Uini = [ones(nEnz,1); 0;0];
ModeOpts.Perts = repmat({Uini}, 1,3);


ModeOpts.Perts{1} = [ones(nEnz,1); 10;0];
ModeOpts.Perts{2} = [ones(nEnz,1); 0;10];
ModeOpts.Perts{3} = [ones(nEnz,1) ones(nEnz,1); 0 0;0 10];
ModeOpts.Perts{3}(15,:) = .1; % KO ethanol production
ModeOpts.Perts{3}(60,:) = .1; % KO lactate production
ModeOpts.Perts{3}(113,:) = .1; % KO acetate production

clear OriginalModeOpts Uini n
tic
% myCluster = parcluster('local');
% myCluster.NumWorkers = 40;
% 
% matlabpool open 39
% pctRunOnAll warning off all
MainAddFlux('Revision2',100,'SeveralPerturbations',ModeOpts)
matlabpool close
toc
%EmailSender('lafonj@gmail.com','SimulationDone','Finished',[])