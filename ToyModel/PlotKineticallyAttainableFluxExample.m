Colors = linspecer(2);

load('SimplePropanolPathwayWReptS2.mat')
load('SimplePropanolPathwayWReptS2Results_Single_Enz40_1ImportedModels.mat')

s=functions(FLUXES)
FLUXES1=str2func(s.function)
FLUXES = FLUXES1

iReaction = 40;
iDistinctEnz = ModeOpts.PerturbedEnz;

if Uini(iDistinctEnz)==0,
    xx = [0:(ModeOpts.PertUp)/Steps:ModeOpts.PertUp 0:(ModeOpts.PertUp)/Steps:ModeOpts.PertUp];
    step = 5;  % larger value indicates lower resolution
    xx = xx(1:step:end);
    uu = [0:(ModeOpts.PertUp)/Steps:ModeOpts.PertUp 0:(ModeOpts.PertUp)/Steps:ModeOpts.PertUp];
else
    xx = [ModeOpts.PertDown:(1-ModeOpts.PertDown)/StepsDown:1 1:(ModeOpts.PertUp-1)/StepsUp:ModeOpts.PertUp]; %Order you want
    step = 5;  % larger value indicates lower resolution
    xx = xx(1:step:end);
    uu = [1:(ModeOpts.PertUp-1)/Steps:ModeOpts.PertUp 1:(ModeOpts.PertDown-1)/Steps:ModeOpts.PertDown]; %Order you have
end
    
    tmpFluxes = NaN(EnsembleSize,length(xx));
    for i = 1:length(xx)
        if i<length(xx)/2,
            j = find(abs(uu-xx(i)) <= 1e-9,1);
        else
            j = find(abs(uu-xx(i)) <= 1e-9,1,'last');
        end
        u = ones(length(rVnet),1);
        u(iDistinctEnz) = xx(i);
        for iModel = 1:EnsembleSize
            if all(~isnan(ModelResults{iModel,1}(:,j,1)))
                v = FLUXES(ModelResults{iModel,1}(:,j,1),EnsembleKvec(:,iModel),1,u);
                tmpFluxes(iModel,i) = v(iReaction);
            end
        end
    end
    
    plot(log10(xx),tmpFluxes,'Color',Colors(1,:))
    hold on
    
    load('SimplePropanolPathwayWReptS2Results_Single_Enz62_1ImportedModels.mat')
    
    s=functions(FLUXES)
    FLUXES1=str2func(s.function)
    FLUXES = FLUXES1
    
    enz1 = [40 62];
    n=1;
    BifPoint = find(isnan(ModelResults{n,1}(1,:,1)),1,'first')-1;
    if isempty(BifPoint),
        BifPoint = StepsUp+1;
    end
    u = Uini;
    switch Mode
        case 'Single'
            u(ModeOpts.PerturbedEnz) = Uini(ModeOpts.PerturbedEnz)+(ModeOpts.PertUp-Uini(ModeOpts.PerturbedEnz))/StepsUp*(BifPoint-1);
        case 'Sequential'
            u(ModeOpts.Sequence(1:end-1)) = ModeOpts.Perts(1:end-1);
            u(ModeOpts.Sequence(end)) = Uini(ModeOpts.Sequence(end))+(ModeOpts.Perts(end)-Uini(ModeOpts.Sequence(end)))/StepsUp*(BifPoint-1);
    end
    if BifPoint>0,
        tempFluxes = FLUXES(ModelResults{n,1}(:,BifPoint,1), EnsembleKvec(:,n),1,u);
    else
        tempFluxes = nan(length(rVnet),1);
    end

    PropFlux = sum(tempFluxes(enz1));
    plot(log10(xx),repmat(PropFlux,length(xx),1),'Color',Colors(2,:));
    
    ylabel([EnzName{iReaction} ' Flux']);
    xlabel([EnzName{iDistinctEnz} ' Vmax'])
    set(gca,'XTick',[-4 -3 -2 -1 0 1 2],'XTickLabel',{'1e-4','1e-3','1e-2', '.1', '1', '10', '100'});
    
    load('SimplePropanolPathwayWReptS2Results_Single_Enz40_1ImportedModels.mat')
    figure
    
    s=functions(FLUXES)
    FLUXES1=str2func(s.function)
    FLUXES = FLUXES1
    
    iMet = 35;
    iDistinctEnz = ModeOpts.PerturbedEnz;

    if Uini(iDistinctEnz)==0,
        xx = [0:(ModeOpts.PertUp)/Steps:ModeOpts.PertUp 0:(ModeOpts.PertUp)/Steps:ModeOpts.PertUp];
        step = 5;  % larger value indicates lower resolution
        xx = xx(1:step:end);
        uu = [0:(ModeOpts.PertUp)/Steps:ModeOpts.PertUp 0:(ModeOpts.PertUp)/Steps:ModeOpts.PertUp];
    else
        xx = [ModeOpts.PertDown:(1-ModeOpts.PertDown)/StepsDown:1 1:(ModeOpts.PertUp-1)/StepsUp:ModeOpts.PertUp]; %Order you want
        step = 5;  % larger value indicates lower resolution
        xx = xx(1:step:end);
        uu = [1:(ModeOpts.PertUp-1)/Steps:ModeOpts.PertUp 1:(ModeOpts.PertDown-1)/Steps:ModeOpts.PertDown]; %Order you have
    end
    
    tmpFluxes = NaN(EnsembleSize,length(xx));
    for i = 1:length(xx)
        if i<length(xx)/2,
            j = find(abs(uu-xx(i)) <= 1e-9,1);
        else
            j = find(abs(uu-xx(i)) <= 1e-9,1,'last');
        end
        for iModel = 1:EnsembleSize
            if all(~isnan(ModelResults{iModel,1}(:,j,1)))
                tmpFluxes(iModel,i) = ModelResults{iModel,1}(iMet,j,1);
            end
        end
    end
    
    plot(log10(xx),tmpFluxes,'Color',Colors(1,:))
    ylabel([Net.MetabName{iMet} ' Concentration']);
    xlabel([EnzName{iDistinctEnz} ' Vmax'])
    set(gca,'XTick',[-4 -3 -2 -1 0 1 2],'XTickLabel',{'1e-4','1e-3','1e-2', '.1', '1', '10', '100'});


    

