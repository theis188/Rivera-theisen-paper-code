function [BadClass,CarbonCount,NitrogenCount,Names] = CompoundChecker( UniqueId, VetoedClasses )
% Look up compound information
    
    %Import file
    fid = fopen('compounds.dat');
    File = textscan(fid,'%s','delimiter', '\n');
    fclose(fid);

    %Find ID in file
    Start = find(strcmp(['UNIQUE-ID - ' UniqueId],File{1}));
    if ~isempty(Start),
        End = find(strcmp('//',File{1}(Start:end)));
        Element = File{1}(Start:Start+End-2);
        clear fid File Start End
        BadClass = 0;
        CarbonCount = 0;
        NitrogenCount=0;
        Names = {};
        %Analyze the compound
        for n=1:length(Element),
            IntPosition = strfind(Element{n}, ' - ');
            Attribute = Element{n}(1:IntPosition-1);
            Value = Element{n}(IntPosition+3:end);
            switch Attribute    %Not all possible attributes are listed here!
                case 'TYPES'
                    %Check that the type does not belong to a vetoed class
                    [BadClass] = ClassChecker( Value, VetoedClasses );
                case 'CHEMICAL-FORMULA'
                    %Report how many carbons the compound has
                    if strncmp(Value, '(C ', 3)
                        CarbonCount = str2double(Value(4:end-1));
                    elseif strncmp(Value, '(N ', 3)
                        NitrogenCount = str2double(Value(4:end-1));
                    end
                case 'COMMON-NAME'
                    Names = {Names{:} Value};
                case 'SYNONYMS'
                    Names = {Names{:} Value};
            end
        end
    else
        % There is an inconsistency in the database with the IDs of THF
        % derivatives
        if ~isempty(strfind(UniqueId,'THF'))
            BadClass = 1;
            CarbonCount = NaN;
            NitrogenCount = NaN;
            Names = NaN;
        else
            %For now let it just pass the test if it can't find the compound
            BadClass = NaN;     %Will return false in if BadClass
            CarbonCount = NaN;  %Will return flase in CarbonCount==0
            NitrogenCount = NaN;
            Names = NaN;
        end
    end
end

