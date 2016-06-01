function [ V, ParamInfo, SubstrateConc, ParameterRange, rV] = SetUpRxnRatesMA(S, Sreg, KVEC, X, Vin_index, Vout_index, U,rV,Revs,S2a,EnzName,MetabName)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    MassActionIrrev_Params = 1;
    MassActionRev_Params = 2
    OutRxn_Params = 1;
    PTS_Params = 5;

    ParametersUsed = 0;
    V = sym('V', [size(S,2) 1]);
    ParamInfo = zeros(size(S,2), 2);
    SubstrateConc = sym('SubstrateConc');
    ParameterRange = zeros([length(KVEC), 2]);
    for Rxn = 1: size(S,2),
        Subs = abs(sum(S(S(:,Rxn)<0, Rxn)));
        Prods = sum(S(S(:,Rxn)>0, Rxn));
        Rev = Revs(Rxn);
        Regs = Sreg(find(Sreg(:,Rxn)>0), Rxn);
        Inlet = ~isempty(find(Vin_index==Rxn, 1));
        if Inlet,
            Subs = Subs+1;
            if strcmp(EnzName(Rxn),'PTS_r'),
                MetabolitesVector = [X(find(strcmp('PHOSPHO-ENOL-PYRUVATE',MetabName))); X(find(strcmp('PYRUVATE',MetabName))); X(find(strcmp('GLC-6-P',MetabName))); SubstrateConc];
            elseif (Subs == 1 || Subs == 2) && (Prods==1 || Prods==2), 
                MetabolitesVector = [SubstrateConc; X(find(S(:,Rxn)<0)); X(find(S(:,Rxn)== -2)); X(find(S(:,Rxn)>0)); X(find(S(:,Rxn)== 2))];
            else
                MetabolitesVector = [SubstrateConc; X(find(S(:,Rxn)<0));  X(find(S(:,Rxn)>0))];
            end
        else
            if strcmp(EnzName(Rxn),'PTS_r'),
                MetabolitesVector = [X(find(strcmp('PHOSPHO-ENOL-PYRUVATE',MetabName))); X(find(strcmp('PYRUVATE',MetabName))); X(find(strcmp('GLC-6-P',MetabName))); SubstrateConc];
            elseif (Subs == 1 || Subs == 2) && (Prods==1 || Prods==2) && isempty(Regs),
                MetabolitesVector = [X(find(S(:,Rxn)<0)); X(find(S(:,Rxn)== -2)); X(find(S(:,Rxn)>0)); X(find(S(:,Rxn)== 2))];
            else
                MetabolitesVector = [X(find(S(:,Rxn)<0));  X(find(S(:,Rxn)>0))];
            end
        end

        
        if Rev = 1
            [V(Rxn) ParameterRange(ParametersUsed+[1:MassActionRev_Params])] = MassActionRev(KVEC(ParametersUsed+[1:MassActionRev_Params]), ...
             MetabolitesVector, length(find(S(:,Rxn)<0)), abs([S(find(S(:,Rxn)<0), Rxn);  S(find(S(:,Rxn)>0), Rxn)]), rV(Rxn),U(rxn));
             ParamInfo(Rxn,:) = ParametersUsed+[1 MassActionRev_Params];
             ParametersUsed = ParametersUsed + MassActionRev_Params;
        else
             [V(Rxn) ParameterRange(ParametersUsed+[1:MassActionRev_Params])] = MassActionIrrev(KVEC(ParametersUsed+[1:MassActionRev_Params]), ...
             MetabolitesVector, length(find(S(:,Rxn)<0)), abs([S(find(S(:,Rxn)<0), Rxn);  S(find(S(:,Rxn)>0), Rxn)]), rV(Rxn),U(rxn));
             ParamInfo(Rxn,:) = ParametersUsed+[1 MassActionRev_Params];
             ParametersUsed = ParametersUsed + MassActionRev_Params;

        end
         VRxn = subs(V(Rxn), SubstrateConc, 1);
    end
    for Rxn=1:size(S2a,2)
        V(size(S,2)+Rxn) = U(size(S,2)+Rxn);
    end
end



function [ V, ParameterRange ] = MassActionRev( k, x, NoSubs, Exponents, rV, U)
    V = U*k(1)*prod(x(1:NoSubs).^Exponents(1:NoSubs)) - k(2)*prod(x(NoSubs+1:end).^Exponents(NoSubs+1:end));
    ParameterRange = [0 Inf; .01*rV 1*rV];
end

function [ V, ParameterRange ] = MassActionIrrev( k, x, NoSubs, Exponents, rV, U)
    V = U*k(1)*prod(x(1:NoSubs).^Exponents(1:NoSubs));
    ParameterRange = [0 Inf; .01*rV 1*rV];
end

