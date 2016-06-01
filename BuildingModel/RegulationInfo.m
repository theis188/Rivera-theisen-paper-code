function [MetId, TypeId, Relevant] = RegulationInfo(UniqueId)
%Get regulation info

    %Import file
    fid = fopen('regulation.dat');
    File = textscan(fid,'%s','delimiter', '\n');
    fclose(fid);

    %Find ID in file
    Start = find(strcmp(['UNIQUE-ID - ' UniqueId],File{1}));
    End = find(strcmp('//',File{1}(Start:end)));
    Element = File{1}(Start:Start+End-2);
    clear fid File Start End

    %Analyze the reaction
    Mechanism = 0;  % 0 for competitive, 1 for allosteric, *these are the only supported types for now
    Direction = 1;  % 1 for inhibition, 2 for activation
    Relevant = 0;
    for n=1:length(Element),
        IntPosition = strfind(Element{n}, ' - ');
        Attribute = Element{n}(1:IntPosition-1);
        Value = Element{n}(IntPosition+3:end);
        switch Attribute  %Not all possible attributes are listed here!
            case 'MECHANISM'
                switch Value
                    case ':COMPETITIVE'
                        Mechanism = 0;                        
                    case ':NONCOMPETITIVE'
                        Mechanism = 0;
                    case ':ALLOSTERIC'
                        Mechanism = 1;
                    case ':OTHER'
                        Mechanism = 1;
                    otherwise
                        Mechanism = 1;
                end
            case 'MODE'
                switch Value
                    case '+'
                        Direction = 2;
                    case '-'
                        Direction = 1;
                end
            case 'REGULATOR'
                MetId = Value;
            case 'KI'
            case 'PHYSIOLOGICALLY-RELEVANT?'
                switch Value
                    case 'T'
                        Relevant = 1;
                    case 'F'
                        Relevant = 0;
                end
            otherwise
        end
    end
    TypeId = 2*Mechanism+Direction;
    
end

