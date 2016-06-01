enz1 = [194 195];
enz2 = [162 163];
ShotasData = [.04 .12 .14; .01 .03 .03];
MTyield = [1 1 1].*74.1/180;

% Files={'USLowRespCellWideModel_AddiButPathwaysResults_SeveralPerturbations_100000Models_20141116_152921.mat'};
% Files={'USLowRespCellWideModel_AddiButPathways2Results_SeveralPerturbations_100Models_20141201_111050.mat'};
Files={'USLowRespCellWideModel_AddiButPathways14modResults_SeveralPerturbations_10000Models_20150423_144954'};

Ys = zeros(length(MTyield),size(ShotasData,2)+1);
YLdevs = zeros(length(MTyield),size(ShotasData,2)+1);
YUdevs = zeros(length(MTyield),size(ShotasData,2)+1);

fig = figure('color','w');
Colors = linspecer(5);
Colors = Colors([1,3,4,2],:);
load(Files{1});
GoodModels = 1:size(ModelResults,1);
for datapnt=1:size(ShotasData,2),
    EnsembleSize = size(ModelResults,1);
    for Ens = 1:length(MTyield),
        Yields = nan(EnsembleSize,1);        
        for n=1:EnsembleSize
            MolarYields = sum(ModelResults{n,3}(enz1,Ens))/sum(ModelResults{n,3}(enz2,Ens));
            if MolarYields~=0,
                Yields(n) = MolarYields*74/180; %g/g
            end
        end
        if Ens==datapnt-1,
            GoodModels(find(Yields(GoodModels)<ShotasData(1,datapnt-1)-ShotasData(2,datapnt-1) | Yields(GoodModels)>ShotasData(1,datapnt-1)+ShotasData(2,datapnt-1))) = [];
            sprintf('Good models after %i screening steps: %i', datapnt-1, length(GoodModels))
        end
            
        Ys(Ens,datapnt) = nanmedian(Yields(GoodModels));
        YLdevs(Ens,datapnt) = nanmedian(Yields(GoodModels))-prctile(Yields(GoodModels),25);
        YUdevs(Ens,datapnt) = prctile(Yields(GoodModels),75)-nanmedian(Yields(GoodModels));
        Ys(Ens,size(ShotasData,2)+1) = ShotasData(1,Ens);
        YLdevs(Ens,size(ShotasData,2)+1) = ShotasData(2,Ens);
        YUdevs(Ens,size(ShotasData,2)+1) = ShotasData(2,Ens);
    end    
end

GoodModels(find(Yields(GoodModels)<ShotasData(1,datapnt)-ShotasData(2,datapnt) | Yields(GoodModels)>ShotasData(1,datapnt)+ShotasData(2,datapnt))) = [];
sprintf('Good models after %i screening steps: %i', datapnt, length(GoodModels))


hold on

h(1) = bar([.9],100*Ys(1,[1])./MTyield(1),.18); e(1) = errorbar([.9],100*Ys(1,[1])./MTyield(1),100*YLdevs(1,[1])./MTyield(1),100*YUdevs(1,[1])./MTyield(1),'k');
h(2) = bar([1.1],100*Ys(1,[4])./MTyield(1),.18); e(2) = errorbar([1.1],100*Ys(1,[4])./MTyield(1),100*YLdevs(1,[4])./MTyield(1),100*YUdevs(1,[4])./MTyield(1),'k');

h(3)=bar(1.8,100*Ys(2,[1])./MTyield(1),.18); e(3)=errorbar(1.8,100*Ys(2,[1])./MTyield(1),100*YLdevs(2,[1])./MTyield(1),100*YUdevs(2,[1])./MTyield(1),'k');
h(4)=bar(2,100*Ys(2,[2])./MTyield(1),.18);   e(4)=errorbar(2,100*Ys(2,[2])./MTyield(1),100*YLdevs(2,[2])./MTyield(1),100*YUdevs(2,[2])./MTyield(1),'k');
h(5)=bar(2.2,100*Ys(2,[4])./MTyield(1),.18); e(5)=errorbar(2.2,100*Ys(2,[4])./MTyield(1),100*YLdevs(2,[4])./MTyield(1),100*YUdevs(2,[4])./MTyield(1),'k');

h(6)=bar(2.7,100*Ys(3,[1])./MTyield(1),.18); e(6)=errorbar(2.7,100*Ys(3,[1])./MTyield(1),100*YLdevs(3,[1])./MTyield(1),100*YUdevs(3,[1])./MTyield(1),'k');
h(7)=bar(2.9,100*Ys(3,[2])./MTyield(1),.18); e(7)=errorbar(2.9,100*Ys(3,[2])./MTyield(1),100*YLdevs(3,[2])./MTyield(1),100*YUdevs(3,[2])./MTyield(1),'k');
h(8)=bar(3.1,100*Ys(3,[3])./MTyield(1),.18); e(8)=errorbar(3.1,100*Ys(3,[3])./MTyield(1),100*YLdevs(3,[3])./MTyield(1),100*YUdevs(3,[3])./MTyield(1),'k');
h(9)=bar(3.3,100*Ys(3,[4])./MTyield(1),.18); e(9)=errorbar(3.3,100*Ys(3,[4])./MTyield(1),100*YLdevs(3,[4])./MTyield(1),100*YUdevs(3,[4])./MTyield(1),'k');


ylabel('Percent of Theoretical Yield (%)')
set(gca,'XTick',[1 2 3],'XTickLabel',{'Kivd+Adh2','+ilvIHCD','-Fermentation'},'box','on');
ylim([0 100])
xlim([.7 3.5])
legend(h(6:9),'Unscreened Prediction', '1-step Screening Prediction', '2-step Screening Prediction', 'Strain Data from Atsumi et al.')
dColors = [Colors([1,4],:); Colors([1,2,4],:); Colors([1,2,3,4],:)] ;
for i=1:9
    set(h(i),'FaceColor',dColors(i,:));
end

