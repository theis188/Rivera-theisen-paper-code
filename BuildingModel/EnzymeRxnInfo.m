function [ EnzId, RegulatedBy, RegType, Name ] = EnzymeRxnInfo( UniqueId )
%Obtain enzyme reaction information

    %Import file
    fid = fopen('enzrxns.dat');
    File = textscan(fid,'%s','delimiter', '\n');
    fclose(fid);

    %Find ID in file
    Start = find(strcmp(['UNIQUE-ID - ' UniqueId],File{1}));
    End = find(strcmp('//',File{1}(Start:end)));
    Element = File{1}(Start:Start+End-2);
    clear fid File Start End

    %Analyze the reaction
    RegulatedBy = {};
    RegType = [];
    for n=1:length(Element),
        IntPosition = strfind(Element{n}, ' - ');
        Attribute = Element{n}(1:IntPosition-1);
        Value = Element{n}(IntPosition+3:end);
        switch Attribute   %Not all possible attributes are listed here!
            case 'ENZYME'
                EnzId = Value;
            case 'REGULATED-BY'
                [MetId, TypeId, Relevant] = RegulationInfo(Value);
%                 if Relevant     %%%%%%% To only include regulation marked
%                 as physiologically relevant. 
                    RegulatedBy = [RegulatedBy; MetId];
                    RegType = [RegType; TypeId];
%                 end
            case 'COMMON-NAME'
                Name = Value;
            case 'KM'
            otherwise
        end
    end

end

