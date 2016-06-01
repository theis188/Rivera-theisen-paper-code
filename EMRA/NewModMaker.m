load('MattFix.mat');
Net.S(:,end+1) = 0;
Net.Sreg(:,end+1) = 0;
Net.S(find(strcmp('2-KETO-ISOVALERATE',Net.MetabName)),end) = -1;
Net.S(find(strcmp('NADH',Net.MetabName)),end) = -1;
Net.S(find(strcmp('NAD',Net.MetabName)),end) = 1;
Net.Vref(end+1) = 0;
Net.EnzName{end+1,1} = 'iBuOH_Vmax_Out';
Net.Reversibilities(end+1) = 0;

save('MattFixVmax.mat')