load('OriginalOriginalResults300.mat') % Original Results File goes Here
%load('MattFixResults_SeveralPerturbations_300Models_20151006_102222')
load('OriginalOriginalModel.mat') % Original Results File goes Here
EnsembleSize = size(ModelResults,1);
nEnz = size(ModelResults{1,1},2)/2;
Sis1 = NaN(nEnz,EnsembleSize);
for n=1:EnsembleSize
    MaxUp = diag(ModelResults{n,2}(1:nEnz,1:nEnz));
    MaxDown = diag(ModelResults{n,2}(1:nEnz,nEnz+1:end));
    pi = logncdf(MaxUp,0,.5) - logncdf(MaxDown,0,.5);
    Sis1(:,n) = -pi.*log10(pi);
end
Si1 = median(Sis1,2);

nonBiomassIndices = cellfun(@(S) isempty(strfind(S,'Biomass')), Net.EnzName);

%BadEnz = find(Si1>.08);
BadEnz = find(Si1(nonBiomassIndices)>.08);
Pathways = {};
PCount = [];
Metabolites = {};
MCount = [];
for n=BadEnz',
   %
   if strcmp(Reactions(n).CommonName,'PTS') || strcmp(Reactions(n).CommonName,'glk') || strcmp(Reactions(n).CommonName,'PTS_r')
       Reactions(n).Pathway = 'superpathway of glycolysis, pyruvate dehydrogenase, TCA, and glyoxylate bypass'
   end
   %
   Pathway = Reactions(n).Pathway;
   Pathway = strrep(Pathway, 'superpathway of ','');
   Pathway = strrep(Pathway, 'pyruvate dehydrogenase, ','');
   Pathway = strrep(Pathway, '<i>','');
   Pathway = strrep(Pathway, '</i>','');
   Pathway = regexprep(Pathway,'(\<[a-z])','${upper($1)}');
   disp(Reactions(n).CommonName)
   disp(Reactions(n).Pathway)
   %pause
   if length(Pathway) == 0,
       Pathway = 'Independent Reaction';
   end       
   MetTemp = Net.MetabName(find(Net.S(:,n)));
   if isempty(find(strcmp(Pathway,Pathways))),
       Pathways = [Pathways; {Pathway}];
       PCount(end+1) = 1;
   else
       PCount(find(strcmp(Pathway,Pathways))) = PCount(find(strcmp(Pathway,Pathways))) + 1;
   end
   for nn=1:length(MetTemp),
       Metabolite = MetTemp(nn);
       if isempty(find(strcmp(Metabolite,Metabolites))),
           Metabolites = [Metabolites; Metabolite];
           MCount(end+1) = 1;
       else
           MCount(find(strcmp(Metabolite,Metabolites))) = MCount(find(strcmp(Metabolite,Metabolites))) + 1;
       end
   end
end
colors = linspecer(2);

figure('color','w')
barh(PCount,'FaceColor',colors(2,:))
set(gca,'ytick', 1:length(Pathways), 'yticklabel', Pathways,'FontSize',10)
xlabel('Number of Unrobust Enzymes (S_i > .08)','FontSize',10)


% figure('color','w')
% M2Plot = find(MCount>=2);
% barh(MCount(M2Plot),'FaceColor',colors(1,:))
% set(gca,'ytick', 1:length(M2Plot), 'yticklabel', Metabolites(M2Plot),'FontSize',10)


%load('USLowRespCellWideModel_AddiButPathways14mod2Results_SeveralPerturbations_300Models_20150513_123830')
%load('MattFix14mod2Results_SeveralPerturbations_300Models_20150917_142607')
load('SampleResults300.mat') %% Updated results file goes here
EnsembleSize = size(ModelResults,1);
Sis2 = NaN(size(ModelResults{1,1},2)/2,EnsembleSize);
nEnz = size(ModelResults{1,1},2)/2;
for n=1:EnsembleSize
    MaxUp = diag(ModelResults{n,2}(1:nEnz,1:nEnz));
    MaxDown = diag(ModelResults{n,2}(1:nEnz,nEnz+1:end));
    pi = logncdf(MaxUp,0,.5) - logncdf(MaxDown,0,.5);
    Sis2(:,n) = -pi.*log10(pi);
end
Si2 = median(Sis2,2);

figure('color','w')
stable1 = .05*100; 
stable2 = .85*100;
bar([stable1, stable2],'FaceColor',colors(1,:))
ylabel('Fraction of stable models (%)')
set(gca, 'xticklabel', {'Original Model', 'Revised Model'},'FontSize',10)
xlim([.5 2.5])
ylim([0 100])

figure('color','w')
%bar([sum(Si1); sum(Si2)],'FaceColor',colors(1,:))
bar([sum(Si1(nonBiomassIndices)); sum(Si2(nonBiomassIndices))],'FaceColor',colors(1,:))
ylabel('Median Entropy (S = \Sigma (-p_ilog(p_i))')
set(gca, 'xticklabel', {'Original Model', 'Revised Model'},'FontSize',10)
xlim([.5 2.5])

figure('color','w')
hist(Si1(nonBiomassIndices));
%hist(Si1);
h1 = findobj(gca,'Type','patch');
set(h1,'FaceColor',colors(1,:)/.92,'EdgeColor','k')
ylabel('Number of Enzymes')
xlabel('Median Entropy of Enzyme i (S_i=-p_ilog(p_i))')
set(gca,'FontSize',10)
box on



%Sys1 = load('USLowRespCellWideModel_AddiButPathways14.mat');
% Sys2 = load('USLowRespCellWideModel_AddiButPathways3.mat');
% Sys3 = load('USLowRespCellWideModel_AddiButPathways7.mat');