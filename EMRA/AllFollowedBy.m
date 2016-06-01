function [EnzymeConc EnzymeBifur ElapsedTime] = AllFollowedBy(Model,Kvec)

    load(Model)
    Xini = ones(length(X),1);
    Uini = (rVnet~=0)+0;
    
    Steps = 10;
    StepsUp = Steps;
    StepsDown = Steps;
    
    EnzymeConc = NaN(size(S,1),(1+StepsUp)+(1+StepsDown),Perturbations);
    EnzymeBifur = NaN(NoEnzymes,1);
    ElapsedTime = NaN(NoEnzymes,1);

    for i_Enzyme = 1:NoEnzymes,

            TimeIn = clock;
            U = Uini;
            Uf1 = U;
            Uf1(i_Enzyme) = PertUp;
            Uf2 = U;
            Uf2(i_Enzyme) = PertDown;

            if U(i_Enzyme)~=0,
                [uf, conc1, Bif1] = SimpleODESolver(StepsUp, Xini, U, Uf1, Kvec,DVDX, DVDU,S,JACOBIAN );
                Uf3 = Uf1; Uf3(ModeOpts.FollowedBy) = ModeOpts.PerturbationSize;
                if Bif1==0,                
                    [uf3, conc3, Bif3] = SimpleODESolver(StepsUp, conc1(end,:)', Uf1, Uf3, Kvec,DVDX, DVDU,S,JACOBIAN );
                else
                conc3 = NaN((1+Steps),size(S,1));
                Bif3 = NaN;
                end
                [uf2, conc2, Bif2] = SimpleODESolver(StepsDown, Xini, U, Uf2, Kvec,DVDX, DVDU,S,JACOBIAN );
                Uf4 = Uf2; Uf4(ModeOpts.FollowedBy) = ModeOpts.PerturbationSize;
                if Bif2==0,
                    [uf4, conc4, Bif4] = SimpleODESolver(StepsUp, conc2(end,:)', Uf2, Uf4, Kvec,DVDX, DVDU,S,JACOBIAN );
                else
                conc4 = NaN((1+Steps),size(S,1));
                Bif4=NaN;
                end
            elseif U(i_Enzyme)==0,
                [uf, conc1, Bif1] = SimpleODESolver(StepsUp, Xini, U, Uf1, Kvec,DVDX, DVDU,S,JACOBIAN );
                Uf3 = Uf1; Uf3(ModeOpts.FollowedBy) = ModeOpts.PerturbationSize;
                if Bif1==0,                
                    [uf3, conc3, Bif3] = SimpleODESolver(StepsUp, conc1(end,:)', Uf1, Uf3, Kvec,DVDX, DVDU,S,JACOBIAN );
                else
                conc3 = NaN((1+Steps),size(S,1));
                end
                conc2 = zeros((1+StepsDown),size(S,1));
                Bif2 = 0;
                conc4 = NaN((1+Steps),size(S,1));
                Bif4 = NaN;
            end

            ElapsedTime(i_Enzyme) = etime(clock,TimeIn);
            EnzymeConc(:,:,i_Enzyme) = [conc3',conc4'];
            EnzymeBifur(i_Enzyme) = Bif3+2*Bif4;

    end