clear
ModeOpts.ImportParameters = ['NewKinetics.mat'];
NoRxns = 11;
Uini = [ones(NoRxns,1); 0];
ModeOpts.Perts{1} = repmat(Uini,1,2);
ModeOpts.Perts{2} = repmat(Uini,1,1);
ModeOpts.Perts{3} = repmat(Uini,1,1);
%ModeOpts.Perts{2} = Uini;ModeOpts.Perts{7} = Uini;

% ModeOpts.Perts{1}(7,:) = 100;
% ModeOpts.Perts{1}(5,:) = 2;
% ModeOpts.Perts{2}(7,:) = .0001;
% ModeOpts.Perts{2}(5,:) = 0.5;
% ModeOpts.Perts{3}(7,:) = 100;
% ModeOpts.Perts{3}(5,:) = 0.5;
% ModeOpts.Perts{4}(7,:) = .0001;
% ModeOpts.Perts{4}(5,:) = 2;
% ModeOpts.Perts{5}(7,:) = 100;
% ModeOpts.Perts{6}(7,:) = .0001;

ModeOpts.Perts{1}(1,:) = .005;
ModeOpts.Perts{1}(12,2) = 50;
ModeOpts.Perts{2}(1,:) = .0001;
ModeOpts.Perts{3}(1,:) = 1000;


clear Uini n
tic
% pctRunOnAll warning off all
%MainAddFlux('USLowRespCellWideModel_AddiButPathways14mod3',300,'SeveralPerturbations',ModeOpts)
MainAddFlux('FinalSimpGlycKAF',1,'SeveralPerturbations',ModeOpts)
toc
%EmailSender('lafonj@gmail.com','SimulationDone','Finished',[])