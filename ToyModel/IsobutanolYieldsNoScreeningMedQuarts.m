enz1 = [194 195];
enz2 = [162 163];
ShotasData = [.04 .12 .14; .01 .03 .03];
MTyield = [1 1 1].*74.1/180;  %Mass theoretical yield ibut

%Files={'USLowRespCellWideModel_AddiButPathways14mod2Results_SeveralPerturbations_1000Models_20150514_142836'};
Files={'MattFixResults_SeveralPerturbations_1000Models_20151005_103127'};

Ys = zeros(length(MTyield),size(ShotasData,2)+1);
YLdevs = zeros(length(MTyield),size(ShotasData,2)+1);
YUdevs = zeros(length(MTyield),size(ShotasData,2)+1);

fig = figure('color','w');
Colors = linspecer(5);
Colors = Colors([1,3,4,2],:);
load(Files{1});
GoodModels = 1:size(ModelResults,1); 
for datapnt=1:size(ShotasData,2),  %
    EnsembleSize = size(ModelResults,1); 
    for Ens = 1:length(MTyield),  %3 cell strains
        Yields = nan(EnsembleSize,1); 
        Productivity = nan(EnsembleSize,1); 
        for n=1:EnsembleSize  %Number of ensembles
            MolarYields = sum(ModelResults{n,3}(enz1,Ens))/sum(ModelResults{n,3}(enz2,Ens));
            if MolarYields~=0,
                Yields(n) = MolarYields*74/180; %g/g
                Productivity(n) = sum(ModelResults{n,3}(enz1,Ens)); % Temporary storage in case you want to know the value
            end
        end
        if Ens==datapnt-1, %screening for right models--not in final manuscript
            GoodModels(find(Yields(GoodModels)<ShotasData(1,datapnt-1)-ShotasData(2,datapnt-1) | Yields(GoodModels)>ShotasData(1,datapnt-1)+ShotasData(2,datapnt-1))) = [];
        end
            
        Ys(Ens,datapnt) = nanmedian(Yields(GoodModels));
        YLdevs(Ens,datapnt) = nanmedian(Yields(GoodModels))-prctile(Yields(GoodModels),25);
        YUdevs(Ens,datapnt) = prctile(Yields(GoodModels),75)-nanmedian(Yields(GoodModels));
        Ys(Ens,size(ShotasData,2)+1) = ShotasData(1,Ens); %column 1 is sim data, column 4 is shota data ,2&3 are unknown
        YLdevs(Ens,size(ShotasData,2)+1) = ShotasData(2,Ens);
        YUdevs(Ens,size(ShotasData,2)+1) = ShotasData(2,Ens);
    end    
end

hold on

h(1) = bar(.9,100*Ys(1,[1])./MTyield(1),.18); e(1) = errorbar([.9],100*Ys(1,[1])./MTyield(1),100*YLdevs(1,[1])./MTyield(1),100*YUdevs(1,[1])./MTyield(1),'k');
h(2) = bar(1.1,100*Ys(1,[4])./MTyield(1),.18); e(2) = errorbar([1.1],100*Ys(1,[4])./MTyield(1),100*YLdevs(1,[4])./MTyield(1),100*YUdevs(1,[4])./MTyield(1),'k');

h(3)=bar(1.4,100*Ys(2,[1])./MTyield(1),.18); e(3)=errorbar(1.4,100*Ys(2,[1])./MTyield(1),100*YLdevs(2,[1])./MTyield(1),100*YUdevs(2,[1])./MTyield(1),'k');
h(4)=bar(1.6,100*Ys(2,[4])./MTyield(1),.18); e(5)=errorbar(1.6,100*Ys(2,[4])./MTyield(1),100*YLdevs(2,[4])./MTyield(1),100*YUdevs(2,[4])./MTyield(1),'k');

h(5)=bar(1.9,100*Ys(3,[1])./MTyield(1),.18); e(6)=errorbar(1.9,100*Ys(3,[1])./MTyield(1),100*YLdevs(3,[1])./MTyield(1),100*YUdevs(3,[1])./MTyield(1),'k');
h(6)=bar(2.1,100*Ys(3,[4])./MTyield(1),.18); e(9)=errorbar(2.1,100*Ys(3,[4])./MTyield(1),100*YLdevs(3,[4])./MTyield(1),100*YUdevs(3,[4])./MTyield(1),'k');


ylabel('Percent of Theoretical Yield (%)')
set(gca,'XTick',[1 1.5 2],'XTickLabel',{'Kivd+Adh2','+ilvIHCD','-Fermentation'},'box','on');
ylim([0 100])
xlim([.7 2.3])
axis('square')
legend(h(5:6),'Model Prediction', 'Strain Data from Atsumi et al.')
dColors = [Colors([1,4],:); Colors([1,4],:); Colors([1,4],:)] ;
for i=1:6
    set(h(i),'FaceColor',dColors(i,:),'barwidth', .18);
end

