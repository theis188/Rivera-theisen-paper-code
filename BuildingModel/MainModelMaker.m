%% List the pathways or reactions to be considered:
Pathways = {
    'GLYCOLYSIS-TCA-GLYOX-BYPASS'; 
    'MALIC-NADP-RXN'; 
    'PEPCARBOX-RXN';
    'PENTOSE-P-PWY';
    'GLUTSYNIII-PWY';
    'GLNSYN-PWY';
    'PWY0-781';
    'ASPARAGINESYN-PWY';
    'PROSYN-PWY';
    'SER-GLYSYN-PWY';
    'CYSTSYN-PWY';
    'BRANCHED-CHAIN-AA-SYN-PWY';
    'VALINE-PYRUVATE-AMINOTRANSFER-RXN';
    'PWY0-661';
    'PWY0-662';
    'PWY0-162';
    'HISTSYN-PWY';
    'PWY-6123';
    'PWY-6122';
    'PWY-7221';
    'PWY-7219';
    'COMPLETE-ARO-PWY';
    'ARGSYN-PWY';
    'NADPHOS-DEPHOS-PWY';
    'FERMENTATION-PWY';
    'RXN-8899';
    };


%% Recursively obtain the list of reactions
Rxns = {};
PathwayNames = {};
Rxn2Pathway = [];
for n=1:length(Pathways),
    [PathwayNames{n}, SubRxns] = ParsePathway(Pathways{n});
    if ~isempty(SubRxns),
        Rxns = [Rxns; SubRxns];
        Rxn2Pathway = [Rxn2Pathway; n.*ones(length(SubRxns),1)];
    else
        Rxns = [Rxns; Pathways{n}];
        PathwayNames{n} = '';
        Rxn2Pathway = [Rxn2Pathway; n];
    end
end

[Rxns, ind,~] = unique(Rxns);
Rxn2Pathway = Rxn2Pathway(ind);

%% Obtain reaction information for every reaction
Reactions = repmat(ReactionInformation, length(Rxns),1);
Metabolites = {};
for  n=1:length(Rxns),
    [ Reactions(n).dG0, Reactions(n).Reversible, Reactions(n).Metabolites, Reactions(n).Stoichiometry, ...
        Reactions(n).EnzymeNames, Reactions(n).Regulators, Reactions(n).RegulationType, Reactions(n).CommonName ] = ReactionInfo( Rxns{n} );
    Reactions(n).Pathway = PathwayNames{Rxn2Pathway(n)};
    Metabolites = [Metabolites; Reactions(n).Metabolites];
end
Metabolites = unique(Metabolites);
    


%% Add your own reactions
%Add PTS reaction
Reactions(end+1).Reversible = 0;
Reactions(end).Metabolites = {'PHOSPHO-ENOL-PYRUVATE';'GLC-6-P'; 'PYRUVATE'};
Reactions(end).Stoichiometry = [-1; 1; 1];
Reactions(end).EnzymeNames = {'PTS'};
Reactions(end).CommonName = 'PTS';
Rxns = [Rxns; 'PTS'];

%Add glk reaction
Reactions(end+1).Reversible = 0;
Reactions(end).Metabolites = {'ATP';'GLC-6-P'; 'ADP'};
Reactions(end).Stoichiometry = [-1; 1; 1];
Reactions(end).EnzymeNames = {'glk'};
Reactions(end).CommonName = 'glk';
Rxns = [Rxns; 'glk'];

%Add Ethanol transport reaction
Reactions(end+1).Reversible = 0;
Reactions(end).Metabolites = {'ETOH'};
Reactions(end).Stoichiometry = [-1];
Reactions(end).EnzymeNames = {'EtOH_out'};
Reactions(end).CommonName = 'Ethanol Output';
Rxns = [Rxns; 'EtOH_out'];

%Add Acetate transport reaction
Reactions(end+1).Reversible = 0;
Reactions(end).Metabolites = {'ACET'};
Reactions(end).Stoichiometry = [-1];
Reactions(end).EnzymeNames = {'Acetate_out'};
Reactions(end).CommonName = 'Acetate Output';
Rxns = [Rxns; 'Acetate_out'];

%Add Lactate transport reaction
Reactions(end+1).Reversible = 0;
Reactions(end).Metabolites = {'D-LACTATE'};
Reactions(end).Stoichiometry = [-1];
Reactions(end).EnzymeNames = {'Lactate_out'};
Reactions(end).CommonName = 'Lactate Output';
Rxns = [Rxns; 'Lactate_out'];

%Respiration
Reactions(end+1).Reversible = 0;
Reactions(end).Metabolites = {'NADH'; 'ADP'; 'NAD'; 'ATP'};
Reactions(end).Stoichiometry = [-1; -2.5; 1; 2.5];
Reactions(end).EnzymeNames = {'CollapsedRespiration'};
Reactions(end).CommonName = 'Summarized Respiration';
Rxns = [Rxns; 'CollapsedRespiration'];



%Independent Outlet For Biomass: From Feist et al. 2007
BiomassComponents = {{'GLT'}; {'GLN'}; {'L-ASPARTATE'}; {'ASN'}; {'PRO'}; {'SER'}; {'GLY'}; {'CYS'}; {'LEU'}; {'VAL'}; {'L-ALPHA-ALANINE'}; ...
    {'THR'}; {'ILE'}; {'HIS'}; {'MET'}; {'LYS'}; {'TYR'}; {'PHE'}; {'TRP'}; {'ARG'}; {'UTP'}; {'CTP'}; {'GTP'}; {'ATP'}; {'NAD'}; {'NADP'}};
Coefficients = [-0.263; -0.263;-0.241;-0.241;-0.221;-0.216;-0.612;-0.092;-0.451;-0.423;-0.514;-0.254;-0.291;-0.095;-0.154;-0.343;-0.138;-0.185;-0.057;-0.296;-0.144;-0.134;-0.215;-0.174;-0.001831;-0.000447;];
for n=1:length(BiomassComponents),
    Reactions(end+1).Reversible = 0;
    Reactions(end).Metabolites = {BiomassComponents{n}};
    Reactions(end).Stoichiometry = [Coefficients(n)];
    Reactions(end).EnzymeNames = {strcat('Biomass', num2str(n))};
    Reactions(end).CommonName = strjoin(BiomassComponents{n}, 'to Biomass'); 
    Reactions(end).Pathway = 'Biomass Output Reactions';
    Rxns = [Rxns; strcat('Biomass', num2str(n))];
end


%% Prepare Input variables
S = [];
Sreg = [];
Reversibilities = [];
EnzymeNames = Rxns;
for n=1:length(Reactions),
    S = [S zeros(length(Metabolites),1)];
    Sreg = [Sreg zeros(length(Metabolites),1)];
    Reversibilities = [Reversibilities; Reactions(n).Reversible];
    for m=1:length(Reactions(n).Metabolites),
        S((strcmp(Reactions(n).Metabolites{m}, Metabolites)),end) = Reactions(n).Stoichiometry(m);
    end
    for nn=1:length(Reactions(n).EnzymeNames),
        for m=1:length(Reactions(n).Regulators{nn}),
            Sreg((strcmp(Reactions(n).Regulators{nn}{m}, Metabolites)),end) = Reactions(n).RegulationType{nn}(m);
        end
    end
    
end

Net.S = S;
Net.Sreg = Sreg;
Net.MetabName = Metabolites;
Net.EnzName = EnzymeNames;

%% Modify the model as suitable for your purpose
%For simplicity, quinones can be represented as 1.5 ATP
%For simplicity, thioredoxin can be substituted by NADPH
%For simplicity NAD-P-OR-NOP choose NADP. Later this could be expanded to use both substrates
Substitutions = {{1} {'|Menaquinones|'} {'='} {1.5} {'ADP'}; ...
                 {1} {'|Menaquinols|'} {'='} {1.5} {'ATP'}; ...
                 %{1} {'|Oxidized-NrdH-Proteins|'} {'='} {1.5} {'ADP'}; ...
                 %{1} {'|Reduced-NrdH-Proteins|'} {'='} {1.5} {'ATP'}; ...
                 %{1} {'|Oxidized-flavodoxins|'} {'='} {1.5} {'ADP'}; ...
                 %{1} {'|Reduced-flavodoxins|'} {'='} {1.5} {'ATP'}; ...
                 {1} {'|Quinones|'} {'='} {1.5} {'ADP'}; ...
                 {1} {'|Reduced-Quinones|'} {'='} {1.5} {'ATP'}; ...
                 {1} {'|Ubiquinones|'} {'='} {1.5} {'ADP'}; ...
                 {1} {'|Ubiquinols|'} {'='} {1.5} {'ATP'}; ...
                 %{1} {'|Ox-Thioredoxin|'} {'='} {1.5} {'NADP'}; ...
                 %{1} {'|Red-Thioredoxin|'} {'='} {1.5} {'NADPH'}; ...
                 {1} {'NAD-P-OR-NOP'} {'='} {1} {'NADP'}; ...
                 {1} {'NADH-P-OR-NOP'} {'='} {1} {'NADPH'}; ...
%                  {1} {'|Acceptor|'} {'='} {1} {'NADP'}; ...
%                  {1} {'|Donor-H2|'} {'='} {1} {'NADPH'}; ...
                 };
for n=1:size(Substitutions,1),
    Met1 = find(strcmp(Substitutions{n,2}, Net.MetabName));
    Met2 = find(strcmp(Substitutions{n,5}, Net.MetabName));
    Net.S(Met2,:) = Net.S(Met2,:)+(Substitutions{n,4}{1}/Substitutions{n,1}{1}).*Net.S(Met1,:);
    Net.S(Met1,:) = [];
    Net.Sreg(Met1,:) = [];
    Net.MetabName(Met1) = [];
end
    
    
%Remove negligible metabolites
VetoedClasses = {'Cofactors';
                 'Vitamins';
                 'Ions';
                 'Salts';
                 'Inorganic-Compounds';
                 'THF-Derivatives';
                 };
NegligibleMetabolites = [];
for n=1:length(Net.MetabName),
    [BadClass, CarbonCount, NitrogenCount] = CompoundChecker(strrep(Net.MetabName{n}, '|', ''), VetoedClasses); % There seems to be an incosistency in the database where -GLU-N does not appear in compounds
    if BadClass==1 || CarbonCount==0 || (CarbonCount==1&&NitrogenCount==0),
        NegligibleMetabolites = [NegligibleMetabolites; n];
    end
end
                 
Net.S(NegligibleMetabolites,:) = [];
Net.MetabName(NegligibleMetabolites) = [];
Net.Sreg(NegligibleMetabolites,:) = [];

% Remove empty or repeated rxns
EmptyRxns =  find(sum(abs(Net.S),1) == 0);
Net.S(:,EmptyRxns) = [];
Net.Sreg(:,EmptyRxns) = [];
Net.EnzName(EmptyRxns) = [];
Reactions(EmptyRxns) = [];
Reversibilities(EmptyRxns) = [];
[~, Unq, ~] = unique(Net.S', 'rows');
RptRxns = logical(ones(size(Net.S,2),1));
RptRxns(Unq) = 0;
Net.S(:,RptRxns) = [];
Net.Sreg(:,RptRxns) = [];
Net.EnzName(RptRxns) = [];
Reversibilities(RptRxns) = [];
Reactions(RptRxns) = [];
Net.Reversibilities = Reversibilities;

%% Prepare Flux Distribution
LB = -1000*Net.Reversibilities;
UB = 1000*ones(size(Net.S,2),1);
% Fluxes taken from Fischer et al. 2004
GlucoseUptake = 7.1;
LB(RxnIndex('PTS', Net.EnzName)) = .9*GlucoseUptake;     % Assumine 90% of the glucose uptake goes through PTS 
UB(RxnIndex('PTS', Net.EnzName)) = .9*GlucoseUptake;
LB(RxnIndex('glk', Net.EnzName)) = .1*GlucoseUptake;           % The other 10% goes through glk
UB(RxnIndex('glk', Net.EnzName)) = .1*GlucoseUptake;
LB(RxnIndex('EtOH_out', Net.EnzName)) = .001;           % Ethanol production
UB(RxnIndex('EtOH_out', Net.EnzName)) = .001;
LB(RxnIndex('Acetate_out', Net.EnzName)) = 6.6;           % Acetate production
UB(RxnIndex('Acetate_out', Net.EnzName)) = 6.6;
LB(RxnIndex('Lactate_out', Net.EnzName)) = .001;           % Lactate production
UB(RxnIndex('Lactate_out', Net.EnzName)) = .001;
LB(RxnIndex('Biomass1', Net.EnzName):RxnIndex('Biomass26', Net.EnzName)) =  GlucoseUptake*.180*.41;       % Growth rate  = GlucoseUptake*GlucoseMW*BiomassYield
UB(RxnIndex('Biomass1', Net.EnzName):RxnIndex('Biomass26', Net.EnzName)) =  GlucoseUptake*.180*.41;
LB(RxnIndex('RXN-5822', Net.EnzName)) = 0;                     %NADP Phosphatase can be neglected
UB(RxnIndex('RXN-5822', Net.EnzName)) = 0;              
LB(RxnIndex('ISOCIT-CLEAV-RXN', Net.EnzName)) = 0;                     %The glyoxylate bypass was found inactive
UB(RxnIndex('ISOCIT-CLEAV-RXN', Net.EnzName)) = 0;

Aeq = zeros(9,length(LB));
Beq = zeros(9,1);

% Reverse reactions
Aeq(3,[RxnIndex('F16BDEPHOS-RXN', Net.EnzName), RxnIndex('6PFRUCTPHOS-RXN', Net.EnzName)]) = [95 -5];           % fbp:pfk = 5:95
Aeq(4,[RxnIndex('PEPDEPHOS-RXN', Net.EnzName), RxnIndex('PEPSYNTH-RXN', Net.EnzName)]) = [5 95];         % pyk:pps = 95:5
Aeq(7,[RxnIndex('R601-RXN', Net.EnzName), RxnIndex('SUCCINATE-DEHYDROGENASE-UBIQUINONE-RXN', Net.EnzName)]) = [-2 1];          %frd:sdh = 1:2

% Parallel reactions
Aeq(5,[RxnIndex('MALATE-DEH-RXN', Net.EnzName), RxnIndex('MALATE-DEHYDROGENASE-ACCEPTOR-RXN', Net.EnzName)]) = [1 -1];            % mdh:mqo = 1:1
Aeq(6,[RxnIndex('PPENTOMUT-RXN', Net.EnzName), RxnIndex('PRPPSYN-RXN', Net.EnzName)]) = [1 1];          % prs:deoB (In His Pwy ATP->AMP:2ATP->2ADP) = 1:1     PRPPSYN
Aeq(8,[RxnIndex('NAD-SYNTH-GLN-RXN', Net.EnzName), RxnIndex('NAD-SYNTH-NH3-RXN', Net.EnzName)]) = [5 -95];         %nadE(Glu):nadE(NH4) = 95:5
Aeq(9,[RxnIndex('PYRUVDEH-RXN', Net.EnzName), RxnIndex('PYRUVFORMLY-RXN', Net.EnzName)]) = [5 -95];         %pdh:pfl = 95:5

Aeq = [Aeq; Net.S];
Beq = [Beq; zeros(size(Net.S,1),1)];

% Minimize repiration for semi-aerobic condition
f = zeros(length(LB), 1);
f(RxnIndex('CITSYN-RXN', Net.EnzName)) = 1;
x = linprog(f,[],[],Aeq,Beq,LB,UB,[],optimoptions('linprog','MaxIter',10000));
Net.Vref = x;


%% Remove Rxns Without Flux
Net.S(:,abs(Net.Vref)<1e-10) = [];
Net.Sreg(:,abs(Net.Vref)<1e-10) = [];
Net.EnzName(abs(Net.Vref)<1e-10) = [];
Net.Reversibilities(abs(Net.Vref)<1e-10) = [];
Reactions(abs(Net.Vref)<1e-10) = [];
Net.Vref(abs(Net.Vref)<1e-10) = [];


%% Remove Metabolites Without Rxns
EmptyMets =  find(sum(abs(Net.S),2) == 0);
Net.S(EmptyMets,:) = [];
Net.Sreg(EmptyMets,:) = [];
Net.MetabName(EmptyMets) = [];

%% Specify Inlet Rxns
InletRxns = {'PTS'; 'glk'; 'PTS_r'};
Net.Vin_index = [];
for n=1:length(InletRxns),
    Net.Vin_index = [Net.Vin_index; RxnIndex(InletRxns{n}, Net.EnzName)];
end

%% Specify Outlet Rxns
OutletRxns = {'EtOH_out'; 'Acetate_out'; 'Lactate_out'};
for n=1:26,
    OutletRxns = [OutletRxns; strcat('Biomass', num2str(n))];
end
Net.Vout_index= [];
for n=1:length(OutletRxns),
    Net.Vout_index = [Net.Vout_index; RxnIndex(OutletRxns{n}, Net.EnzName)];
end
          
save('Original', 'Net', 'Reactions')

%% Fix Sreg JIGGA %%FIXXEEERRR
%Jimmy Fix

Net.Sreg(find(strcmp('ATP',Net.MetabName)), find(strcmp('6PGLUCONDEHYDROG-RXN',Net.EnzName))) = 1;
Net.Sreg(find(strcmp('FRUCTOSE-16-DIPHOSPHATE',Net.MetabName)), find(strcmp('6PGLUCONDEHYDROG-RXN',Net.EnzName))) = 3;
Net.Sreg(find(strcmp('NADPH',Net.MetabName)), find(strcmp('6PGLUCONDEHYDROG-RXN',Net.EnzName))) = 1;
Net.Sreg(find(strcmp('HOMO-SER',Net.MetabName)), find(strcmp('ASPARTATEKIN-RXN',Net.EnzName))) = 0;
Net.Sreg(find(strcmp('GLC-6-P',Net.MetabName)), find(strcmp('PTS',Net.EnzName))) = 3;
Net.EnzName(find(strcmp('PTS',Net.EnzName))) = {'PTS_r'};

save('Revision1', 'Net', 'Reactions')

%%%%%%%%%%%%%%%%%%%%%%%%
%Matt Fix
Net.Sreg(find(strcmp('ATP',Net.MetabName)), find(strcmp('PHOSGLYPHOS-RXN',Net.EnzName))) = 0;
Net.Sreg(find(strcmp('G3P',Net.MetabName)), find(strcmp('PHOSGLYPHOS-RXN',Net.EnzName))) = 0;
Net.Sreg(find(strcmp('DIHYDROXY-ACETONE-PHOSPHATE',Net.MetabName)), find(strcmp('F16ALDOLASE-RXN',Net.EnzName))) = 0;
Net.Sreg(find(strcmp('PHOSPHO-ENOL-PYRUVATE',Net.MetabName)), find(strcmp('glk',Net.EnzName))) = 1;
Net.Sreg(find(strcmp('NAD',Net.MetabName)), find(strcmp('CITSYN-RXN',Net.EnzName))) = 0;
Net.Sreg(find(strcmp('OXALACETIC_ACID',Net.MetabName)), find(strcmp('CITSYN-RXN',Net.EnzName))) = 0;
Net.Sreg(find(strcmp('CYS',Net.MetabName)), find(strcmp('HOMOSERKIN-RXN',Net.EnzName))) = 0;
Net.Sreg(find(strcmp('HOMO-CYS',Net.MetabName)), find(strcmp('HOMOSERKIN-RXN',Net.EnzName))) = 0;
Net.Sreg(find(strcmp('IMINOASPARTATE',Net.MetabName)), find(strcmp('L-ASPARTATE-OXID-RXN',Net.EnzName))) = 0;
Net.Sreg(find(strcmp('DIHYDROXY-ACETONE-PHOSPHATE',Net.MetabName)), find(strcmp('L-ASPARTATE-OXID-RXN',Net.EnzName))) = 2;
Net.Sreg(find(strcmp('AMP',Net.MetabName)), find(strcmp('ADENYLOSUCCINATE-SYNTHASE-RXN',Net.EnzName))) = 1;
Net.Sreg(find(strcmp('ADENYLOSUCC',Net.MetabName)), find(strcmp('ADENYLOSUCCINATE-SYNTHASE-RXN',Net.EnzName))) = 1;

save('Revision2', 'Net', 'Reactions')