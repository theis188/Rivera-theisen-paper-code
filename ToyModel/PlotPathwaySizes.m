Pathways = {};
PCount = [];
for n=1:length(Net.EnzName),
   Pathway = Reactions(n).Pathway;
   Pathway = strrep(Pathway, 'superpathway of ','');
   Pathway = strrep(Pathway, 'pyruvate dehydrogenase, ','');
   Pathway = strrep(Pathway, '<i>','');
   Pathway = strrep(Pathway, '</i>','');
   Pathway = regexprep(Pathway,'(\<[a-z])','${upper($1)}');
   if ~isempty(strfind(Pathway,'RXN'))
       Pathway = '';
   end
   
   if length(Pathway) == 0,
       Pathway = 'Independent Reaction';
   end       
   if isempty(find(strcmp(Pathway,Pathways))),
       Pathways = [Pathways; {Pathway}];
       PCount(end+1) = 1;
   else
       PCount(find(strcmp(Pathway,Pathways))) = PCount(find(strcmp(Pathway,Pathways))) + 1;
   end
end
colors = linspecer(2);

figure('color','w')
barh(PCount,'FaceColor',colors(1,:))
xlabel('Number of Reactions in Pathway','FontSize',10)
ylim([0 length(Pathways)+1])
set(gca,'ytick', 1:length(Pathways), 'yticklabel', Pathways,'FontSize',10)