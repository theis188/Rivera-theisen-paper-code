function [ CommonName, ReactionList ] = ParsePathway( UniqueId )
%Parse pathways.dat for information for a particular pathway


    %Import file
    fid = fopen('pathways.dat');
    File = textscan(fid,'%s','delimiter', '\n');
    fclose(fid);

    %Find ID in file
    Start = find(strcmp(['UNIQUE-ID - ' UniqueId],File{1}));
    if ~isempty(Start),
        End = find(strcmp('//',File{1}(Start:end)));
        Element = File{1}(Start:Start+End-2);
        clear fid File Start End

        %Analyze the pathway
        ReactionList = {};
        for n=1:length(Element),
            IntPosition = strfind(Element{n}, ' - ');
            Attribute = Element{n}(1:IntPosition-1);
            Value = Element{n}(IntPosition+3:end);
            switch Attribute     %Not all possible attributes are listed here!
                case 'COMMON-NAME'
                    CommonName = Value;
                case 'REACTION-LIST'
                    ReactionList = [ReactionList; Value];
                case 'SUB-PATHWAYS'
                    ReactionList((strcmp(Value, ReactionList))) = [];
                    [~, SubReactionList] = ParsePathway(Value);
                    ReactionList = [ReactionList; SubReactionList];
                otherwise
            end
        end
    else
        ReactionList = {};
        CommonName = {};
    end

end

