clear
for i = [1:5]
clearvars -except i
NameList = {'But','Glut','EtOH','Thr','Pyr'}
EnzOutList = [7,3,8,10,2]
MetabNameList = {'Thr','OAA','AcCoA','Thr','Pyr'}
MetabPlotList = [5,3,4,5,2]
RxnNumber = EnzOutList(i)

ModeOpts.ImportParameters = ['NewKinetics.mat'];
NoRxns = 11;
Uini = [ones(NoRxns,1); 0];
ModeOpts.Perts = repmat({Uini},1,2);
ModeOpts.Perts{3} = repmat(Uini,1,2);

ModeOpts.Perts{1}(RxnNumber,:) = 0.01;
ModeOpts.Perts{2}(RxnNumber,:) = 1000;
ModeOpts.Perts{3}(RxnNumber,:) = .01;
ModeOpts.Perts{3}(12,2) = 25;

clear Uini n
tic
% pctRunOnAll warning off all
%MainAddFlux('USLowRespCellWideModel_AddiButPathways14mod3',300,'SeveralPerturbations',ModeOpts)
MainAddFlux(strcat('FinalSimp',NameList{i},'KAF'),1,'SeveralPerturbations',ModeOpts)
toc
end

%EmailSender('lafonj@gmail.com','SimulationDone','Finished',[])