clear
figure

for i = 1:5
clearvars -except i
    
ResultsList = {...
    'FinalSimpButKAFResults_SeveralPerturbations_1Models_20160531_113838.mat'                  %But File Here
    'FinalSimpGlutKAFResults_SeveralPerturbations_1Models_20160531_113843.mat'                 %Glut File Here
    'FinalSimpEtOHKAFResults_SeveralPerturbations_1Models_20160531_113847.mat'                 %EtOH File Here
    'FinalSimpThrKAFResults_SeveralPerturbations_1Models_20160531_113851.mat'                  %Thr File Here
    'FinalSimpPyrKAFResults_SeveralPerturbations_1Models_20160531_113855.mat'...               %Pyr File Here
};
NameList = {'But','Glut','EtOH','Thr','Lac'}
EnzOutList = [7,3,8,10,2]
MetabNameList = {'Thr','OAA','AcCoA','Thr','Pyr'}
MetabPlotList = [5,3,4,5,2]
RxnNumber = EnzOutList(i)
MetabNumber = MetabPlotList(i)

load(ResultsList{i})

NoIntractPlotXVars = []
NoIntractPlotYVars = []

NoIntractPlotXVars = [fliplr(ModelResults{1,2}{1,1}(RxnNumber,:))]; % Vmax values for propanol synthesis
NoIntractPlotYVars = [fliplr(ModelResults{1,3}{1,1}(RxnNumber,:))]; % Flux values for propanol synthesis

NoIntractPlotXVars = [NoIntractPlotXVars ModelResults{1,2}{1,2}(RxnNumber,2:end)]; % Vmax values for propanol synthesis
NoIntractPlotYVars = [NoIntractPlotYVars ModelResults{1,3}{1,2}(RxnNumber,2:end)]; % Flux values for propanol synthesis

NoIntractPlotXVars = log10(NoIntractPlotXVars)

KAYYVars = ModelResults{1,1}{1,3}(MetabNumber,:);
KAYXVars = ModelResults{1,3}{1,3}(12,:) + ModelResults{1,3}{1,3}(RxnNumber,:);
KAYMet = KAYYVars;
if i == 4;
    KAYMet = log10(KAYMet);
end;
%KAYMet = KAYMet/KAYMet(1);

%figure %Vmax Plot
subplot(5,2,2*i-1)
hold on
colorstring = {hex2rgb('#DB0000');hex2rgb('#178210')}
plot(NoIntractPlotXVars,NoIntractPlotYVars,'Color',colorstring{1},'LineWidth',2)
set(gca,'XLim',[-4,3],'Xtick',[-4 -3 -2 -1 0 1 2 3]);%,'YLim',[0,5],'YTick',[0, 2.5, 5])
xlabel(strcat('Vmax ', NameList{i},' Output Rxn'))
ylabel(strcat(NameList{i},' Output Flux'))

%figure
subplot(5,2,2*i)
hold off
colorstring = {hex2rgb('#DB0000');hex2rgb('#178210')}
plot(KAYXVars,KAYYVars,'LineWidth',2)
xlabel(strcat(NameList{i},' Flux'))
if i == 4;
    ylabel(strcat(MetabNameList{i},' Conc (log10)'))
else;
    ylabel(strcat(MetabNameList{i},' Conc'))
end;

%set(gca,'XLim',[-4,3],'Xtick',[-4 -3 -2 -1 0 1 2 3],'YLim',[0,5],'YTick',[0, 2.5, 5])

end