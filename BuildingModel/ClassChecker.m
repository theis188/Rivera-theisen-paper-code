function [BadClass] = ClassChecker( UniqueId, VetoedClasses )
% Look up compound information
    

    %Import file
    fid = fopen('classes.dat');
    File = textscan(fid,'%s','delimiter', '\n');
    fclose(fid);

    %Find ID in file
    Start = find(strcmp(['UNIQUE-ID - ' UniqueId],File{1}));
    if ~isempty(Start),
        End = find(strcmp('//',File{1}(Start:end)));
        Element = File{1}(Start:Start+End-2);
        clear fid File Start End

        %Analyze the class
        BadClass = 0;
        n=1;
        while BadClass == 0 && n<=length(Element),
            IntPosition = strfind(Element{n}, ' - ');
            Attribute = Element{n}(1:IntPosition-1);
            Value = Element{n}(IntPosition+3:end);
            switch Attribute    %Not all possible attributes are listed here!
                case 'TYPES'
                    if ~isempty(find(strcmp(Value,VetoedClasses),1)),
                        BadClass = 1;
                    else
                        BadClass = ClassChecker(Value, VetoedClasses);
                    end
                otherwise
            end
            n= n+1;
       end
    else
        BadClass = 0;
    end
end

