clear
load('FinalSimpGlycKAFResults_SeveralPerturbations_1Models_20160531_143424') % Paste FileName in Parentheses & quotes on this line

RxnNumber = 1
MetabNumber = 2

NoIntractPlotXVars = []
NoIntractPlotYVars = []

NoIntractPlotXVars = [fliplr(ModelResults{1,2}{1,2}(RxnNumber,:))]; % Vmax values for glyc
NoIntractPlotYVars = [fliplr(ModelResults{1,3}{1,2}(RxnNumber,:))]; % Flux values for glyc
ButFlux = [fliplr(ModelResults{1,3}{1,2}(7,:))];

NoIntractPlotXVars = [NoIntractPlotXVars ModelResults{1,2}{1,3}(RxnNumber,2:end)]; % Vmax values for glyc
NoIntractPlotYVars = [NoIntractPlotYVars ModelResults{1,3}{1,3}(RxnNumber,2:end)]; % Flux values for glyc
ButFlux = [ButFlux ModelResults{1,3}{1,3}(7,2:end)];

NoIntractPlotXVars = log10(NoIntractPlotXVars)


KAYYVars = ModelResults{1,1}{1,1}(MetabNumber,:); % PyrConc
KAYXVars = ModelResults{1,3}{1,1}(12,:) + ModelResults{1,3}{1,1}(RxnNumber,:); %GlucFlux
KAYMet = KAYYVars;
%KAYMet = KAYMet/KAYMet(1);
ButFluxPhi = ModelResults{1,3}{1,1}(7,:);
ButYieldPhi = ButFluxPhi./KAYXVars;

%figure %Vmax Plot
BuOHFluxVmax = ButFlux;
GlycFluxVmax = NoIntractPlotYVars;
ButYieldVmax = BuOHFluxVmax./GlycFluxVmax;
Vmaxxer = NoIntractPlotXVars;
Vmaxxer = (Vmaxxer + 3)*40/6

figure
colorstring = {hex2rgb('#DB0000');hex2rgb('#178210')}
plot(NoIntractPlotXVars,NoIntractPlotYVars,'LineWidth',2)
set(gca,'XLim',[-3,3],'Xtick',[-3 -2 -1 0 1 2 3],'YLim',[0,40],'YTick',[0, 10, 20, 30, 40]);
xlabel(strcat('Vmax  Glyc Rxn'))
ylabel(strcat('Glyc Flux'))

figure
colorstring = {hex2rgb('#DB0000');hex2rgb('#178210')}
plot(NoIntractPlotXVars,ButFlux,'LineWidth',2)
set(gca,'XLim',[-3,3],'Xtick',[-3 -2 -1 0 1 2 3],'YLim',[0,8],'YTick',[0, 2, 4,6,8]);
xlabel(strcat('Vmax Glyc Rxn'))
ylabel(strcat('But Flux'))

figure
hold off
colorstring = {hex2rgb('#DB0000');hex2rgb('#178210')}
plot([0 KAYXVars],[0 KAYYVars],'LineWidth',2)
xlabel(strcat('Glyc Flux'))
ylabel(strcat('Pyr Conc'))
set(gca,'XLim',[0,40],'Xtick',[0 10 20 30 40],'YLim',[0,8],'YTick',[0, 2, 4, 6, 8]);

figure
plot([KAYXVars],[ButFluxPhi],Vmaxxer,BuOHFluxVmax,'LineWidth',2)
set(gca,'XLim',[0,40],'Xtick',[0 10 20 30 40],'YLim',[0,8],'YTick',[0, 2, 4, 6, 8]);
ylabel(strcat('BuOH Flux'))
xlabel(strcat('Glyc Flux/Vmax'))

figure
plot([0 KAYXVars],[0 ButYieldPhi],Vmaxxer,ButYieldVmax,'LineWidth',2)
set(gca,'XLim',[0,40],'Xtick',[0 10 20 30 40],'YLim',[0,0.4],'YTick',[0 0.1 0.2 0.3]);
ylabel(strcat('BuOH Yield'))
xlabel(strcat('Glyc Flux/Vmax'))
%set(gca,'XLim',[-4,3],'Xtick',[-4 -3 -2 -1 0 1 2 3],'YLim',[0,5],'YTick',[0, 2.5, 5])

