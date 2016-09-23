clear
load('FinalSimpButKAFResults_SeveralPerturbations_1Models_20160531_140135.mat') % Paste filename here

IntractPlotXVars = []
IntractPlotYVars = []

IntractPlotXVars = [fliplr(ModelResults{1,2}{1,2}(7,:))]; % Vmax values for propanol synthesis
IntractPlotYVars = [fliplr(ModelResults{1,3}{1,2}(7,:))]; % Flux values for propanol synthesis

IntractPlotXVars = [IntractPlotXVars ModelResults{1,2}{1,1}(7,2:end)]; % Vmax values for propanol synthesis
IntractPlotYVars = [IntractPlotYVars ModelResults{1,3}{1,1}(7,2:end)]; % Flux values for propanol synthesis

IntractPlotXVars = log10(IntractPlotXVars)

%SplineX = -4:0.1:2
%SplineY = spline(IntractPlotXVars,IntractPlotYVars,SplineX)

NoIntractPlotXVars = []
NoIntractPlotYVars = []

NoIntractPlotXVars = [fliplr(ModelResults{1,2}{1,4}(7,:))]; % Vmax values for propanol synthesis
NoIntractPlotYVars = [fliplr(ModelResults{1,3}{1,4}(7,:))]; % Flux values for propanol synthesis

NoIntractPlotXVars = [NoIntractPlotXVars ModelResults{1,2}{1,3}(7,2:end)]; % Vmax values for propanol synthesis
NoIntractPlotYVars = [NoIntractPlotYVars ModelResults{1,3}{1,3}(7,2:end)]; % Flux values for propanol synthesis

NoIntractPlotXVars = log10(NoIntractPlotXVars)

KAYXVars = ModelResults{1,1}{1,5}(5,:);
KAYYVars = ModelResults{1,3}{1,5}(12,:) + ModelResults{1,3}{1,5}(7,:);
KAYThr = KAYXVars;
KAYThr = KAYThr/KAYThr(1);
KAYAcCoA = ModelResults{1,1}{1,5}(4,:);
KAYAcCoA = KAYAcCoA/KAYAcCoA(1);
IntrctThr = [fliplr(ModelResults{1,1}{1,2}(5,:)) ModelResults{1,1}{1,1}(5,2:end)];
IntrctThr = IntrctThr/IntrctThr(1);
IntrctAcCoA = [fliplr(ModelResults{1,1}{1,2}(4,:)) ModelResults{1,1}{1,1}(4,2:end)];
IntrctAcCoA = IntrctAcCoA/IntrctAcCoA(1);

OtherMetabs = [fliplr(ModelResults{1,1}{1,7}(2,:)) ModelResults{1,1}{1,6}(2,2:end)];
OtherFlux = [fliplr(ModelResults{1,3}{1,7}(1,:)) ModelResults{1,3}{1,6}(1,2:end)];
OtherVmax = [fliplr(ModelResults{1,2}{1,7}(1,:)) ModelResults{1,2}{1,6}(1,2:end)];

ThrConc = [fliplr(ModelResults{1,1}{1,4}(5,:)) ModelResults{1,1}{1,3}(5,2:end)];
ThrConc = ThrConc/ThrConc(1);
AcCoaConc = [fliplr(ModelResults{1,1}{1,4}(4,:)) ModelResults{1,1}{1,3}(4,2:end)];
AcCoaConc = AcCoaConc/AcCoaConc(1);
VmaxVals = IntractPlotXVars;

%NoSplineX = -4:0.1:2;
%NoSplineY = spline(NoIntractPlotXVars,NoIntractPlotYVars,NoSplineX);

GlycFluxVmax = fliplr(ModelResults{1,3}{1,4}(1,:))
GlycFluxVmax = [GlycFluxVmax ModelResults{1,3}{1,3}(1,2:end)]
BuOHFluxVmax = NoIntractPlotYVars;
YielderVmax = BuOHFluxVmax./GlycFluxVmax;
XAxisBuOHVmax = NoIntractPlotXVars;

GlucFluxPhi = ModelResults{1,3}{1,5}(1,:);
BuOHFluxPhi = ModelResults{1,3}{1,5}(12,:) + ModelResults{1,3}{1,5}(7,:);
BuOHYieldPHI = BuOHFluxPhi./GlucFluxPhi;
XAxisBuOHPhi = BuOHFluxPhi - 3;

figure
hold on
colorstring = {hex2rgb('#DB0000');hex2rgb('#178210')}
plot(IntractPlotXVars,IntractPlotYVars,'Color',colorstring{1},'LineWidth',2)
plot(NoIntractPlotXVars,NoIntractPlotYVars,'Color',colorstring{2},'LineWidth',2)
set(gca,'XLim',[-4,3],'Xtick',[-4 -3 -2 -1 0 1 2 3],'YLim',[0,5],'YTick',[0, 2.5, 5])

figure
hold off
colorstring = {hex2rgb('#DB0000');hex2rgb('#178210')}
plot(IntractPlotXVars,IntractPlotYVars,'Color',colorstring{1},'LineWidth',2)
set(gca,'XLim',[-4,3],'Xtick',[-4 -3 -2 -1 0 1 2 3],'YLim',[0,5],'YTick',[0, 2.5, 5])
figure
plot(NoIntractPlotXVars,NoIntractPlotYVars,'Color',colorstring{2},'LineWidth',2)
set(gca,'XLim',[-4,3],'Xtick',[-4 -3 -2 -1 0 1 2 3],'YLim',[0,5],'YTick',[0, 2.5, 5])

figure
hold on
plot(KAYYVars,KAYXVars,'LineWidth',2)
set(gca,'XLim',[0,5],'Xtick',[0 1 2 3 4 5],'YLim',[0,18],'YTick',[0, 9, 18])

GlcYield(1) = 1.5;
GlcYield(2) = 1;
GlcYield(3) = ModelResults{1,3}{1,3}(7,end)/ModelResults{1,3}{1,3}(11,end);
GlcYield(4) = ModelResults{1,3}{1,1}(7,end)/ModelResults{1,3}{1,1}(11,end);

figure
h = bar(1:4,diag(GlcYield),'stacked')
set(h(1),'facecolor',hex2rgb('#A5A5A5'))
set(h(2),'facecolor',hex2rgb('#3174E0'))
set(h(3),'facecolor',hex2rgb('#3ACC0E'))
set(h(4),'facecolor',hex2rgb('#BF4141'))
set(gca,'YLim',[0,2],'YTick',[0, 1, 2])

figure
plot(OtherMetabs,OtherFlux,'LineWidth',2);
set(gca,'XLim',[0 2],'Xtick',[0 1 2],'YLim',[0 16],'YTick',[0, 8 16])

figure
plot(OtherFlux,OtherVmax,'LineWidth',2);
set(gca,'XLim',[0 16],'Xtick',[0 4 8 12 16],'YLim',[0 12],'YTick',[0, 6, 12])

figure
plot(VmaxVals,AcCoaConc,VmaxVals,ThrConc,'LineWidth',2);

figure
plot(KAYYVars,KAYAcCoA,KAYYVars,KAYThr,'LineWidth',2);
set(gca,'XLim',[0 5],'Xtick',[0 1 2 3 4 5],'YLim',[0 1],'YTick',[0, 0.5, 1])

figure
plot(VmaxVals,IntrctAcCoA,VmaxVals,IntrctThr,'LineWidth',2);
set(gca,'XLim',[-4,3],'Xtick',[-4 -3 -2 -1 0 1 2 3],'YLim',[0 1],'YTick',[0, 0.5, 1])

figure
hold on
plot(XAxisBuOHVmax,YielderVmax,XAxisBuOHPhi,BuOHYieldPHI,'LineWidth',2);
set(gca,'XLim',[-4,3],'Xtick',[-4 -3 -2 -1 0 1 2 3],'YLim',[0 0.6],'YTick',[0, 0.3, 0.6])


