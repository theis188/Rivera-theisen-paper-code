clear
ModeOpts.ImportParameters = [];
NoRxns = 11;
Uini = [ones(NoRxns,1)];
ModeOpts.Perts = repmat({Uini},1,4);

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


ModeOpts.Perts{1}(5,:) = 0.6;
ModeOpts.Perts{1}(7,:) = 1000;
ModeOpts.Perts{2}(:,:) = 1;
ModeOpts.Perts{2}(7,:) = .0001;
ModeOpts.Perts{3}(7,:) = 1000;
ModeOpts.Perts{4}(7,:) = .0001;


clear Uini n
tic
% pctRunOnAll warning off all
%MainAddFlux('USLowRespCellWideModel_AddiButPathways14mod3',300,'SeveralPerturbations',ModeOpts)
MainAddFlux('FinalSimpBut',1,'SeveralPerturbations',ModeOpts)
toc
%EmailSender('lafonj@gmail.com','SimulationDone','Finished',[])