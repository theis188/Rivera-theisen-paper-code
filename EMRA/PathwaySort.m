EnzymeCell = {}
for n = 1:size(Reactions,1)
    PwyIndex = strcmp(EnzymeCell,Reactions(n).Pathway)
    if isempty(find(PwyIndex)) 
        PwyIndex = size(EnzymeCell,2) + 1
        EnzymeCell{1,PwyIndex} = Reactions(n).Pathway
    else
        PwyIndex = find(PwyIndex(1,:))
    end
    if isempty(find(cellfun(@isempty,EnzymeCell(:,PwyIndex))))
        EnzymeNumber = size(EnzymeCell,1) + 1
    else
        EnzymeNumber = find(cellfun(@isempty,EnzymeCell(:,PwyIndex)),1)
    end
    EnzymeCell{EnzymeNumber,PwyIndex} = Reactions(n).CommonName
end

    