function [ dG0, Reversible, Metabolites, Stoichiometry, EnzymeNames, Regulators, RegulationType,Name ] = ReactionInfo( UniqueId )
%Obtain reaction information available on EcoCyc
%   If available:
%     dG0 = standard gibbs free energy
%     Reversible = 1 if reversible, 0 if not
%     Metabolites = array of involved metaboltes' names
%     Stoichiometry = array of stoichiometric coefficients for metabolites
%     EnzymeNames = array of the UNIQUE-IDs of enzymes catalyzing the reaction
%     Regulators = 2d array metabolites regulating each enzyme (one row per enzyme one col per regulator)
%     RegulationType = 2d array indicating regulation type(1=competitive inhibition  2=competitive activation  
%                                                       ...3=allosteric inhibition  4=allosteric activation) 


    %Import file
    fid = fopen('reactions.dat');
    File = textscan(fid,'%s','delimiter', '\n');
    fclose(fid);

    %Find ID in file
    Start = find(strcmp(['UNIQUE-ID - ' UniqueId],File{1}));
    End = find(strcmp('//',File{1}(Start:end)));
    Element = File{1}(Start:Start+End-2);
    clear fid File Start End

    %Analyze the reaction
    dG0 = -NaN;
    Metabolites = {};
    EnzymeNames = {};
    Stoichiometry = [];
    L2R = 1;
    Reversible = 0;
    Regulators = {};
    RegulationType = {};
    Name = '';
    for n=1:length(Element),
        IntPosition = strfind(Element{n}, ' - ');
        Attribute = Element{n}(1:IntPosition-1);
        Value = Element{n}(IntPosition+3:end);
        switch Attribute    %Not all possible attributes are listed here!
            case 'ENZYMATIC-REACTION'
                [EnzId, RegulatedBy, RegType,Name] = EnzymeRxnInfo(Value);
                EnzymeNames = [EnzymeNames; EnzId];
                Regulators = [Regulators; {RegulatedBy}];
                RegulationType = [RegulationType; {RegType}];                
            case 'DELTAG0'
                dG0 = str2double(Value);
            case 'REACTION-DIRECTION'
               switch Value
                   case 'LEFT-TO-RIGHT'
                       %Nothing needs to be done
                   case 'RIGHT-TO-LEFT'
                       L2R = -1;
                       Stoichiometry = -1.*Stoichiometry;
                       dG0 = dG0*-1;
                   case 'PHYSIOL-RIGHT-TO-LEFT'
                       L2R = -1;
                       Stoichiometry = -1.*Stoichiometry;
                       dG0 = dG0*-1;
                   case 'REVERSIBLE'
                       Reversible = 1;
               end
            case 'LEFT'
               Metabolites = [Metabolites; Value];
               Stoichiometry = [Stoichiometry; -L2R]; 
            case 'RIGHT'
               Metabolites = [Metabolites; Value];
               Stoichiometry = [Stoichiometry; L2R]; 
            case '^COEFFICIENT'                
                Stoichiometry(end) = Stoichiometry(end)*str2double(Value);
            otherwise
        end
    end

end

