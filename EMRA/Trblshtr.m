%MetabFinder()

zz = find(strcmp('DIHYDROXYISOVALDEHYDRAT-RXN',Net.EnzName))
Net.MetabName(find(Net.S(:,zz)))
disp(Net.S(find(Net.S(:,zz)),zz))
disp(Net.Vref(zz))
disp(Net.Reversibilities(zz))
% % % disp(LB(zz))
% % % disp(UB(zz))

% zz = find(strcmp('DIOH-ISOVALERATE',Net.MetabName))
% Net.EnzName(find(Net.S(zz,:)))
% disp(Net.Vref(find(Net.S(zz,:))).*Net.S(zz,find(Net.S(zz,:)))')
% % 
% zz = find(strcmp('ATPSYN-RXN',Net.EnzName))
% Net.MetabName(find(Net.Sreg(:,zz)))
% disp(Net.Sreg(find(Net.Sreg(:,zz)),zz))
% disp(Net.Reversibilities(zz))

