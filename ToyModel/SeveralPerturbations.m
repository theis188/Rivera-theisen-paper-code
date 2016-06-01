function [EnzymeConc, EnzymeActs, EnzymeFluxes, Bifs, EnzymeTimes] = SeveralPerturbations(Model,Kvec,ModeOpts)

    load(Model)
    Xini = ones(length(X),1);
    Uini = (rVnet~=0)+0;
        
    Perturbations = length(ModeOpts.Perts);
    
    EnzymeConc = {};
    EnzymeActs = {};
    EnzymeFluxes = {};
    EnzymeTimes = NaN(1,Perturbations);
    Bifs = NaN(Perturbations,1);
    
    for n=1:Perturbations,
        U = Uini;
        X = Xini;
        Bif = 0;
        nn=1;
        while nn<=size(ModeOpts.Perts{n},2) && ~Bif
            Uf1 = ModeOpts.Perts{n}(:,nn);
            [uf, conc, Bif, TimeTaken] = SimpleODESolverMatlab(2000, X, U, Uf1, Kvec,DVDX, DVDU,S );
            U = uf(:,end);
            X = conc(end,:)';
            nn= nn+1;
        end
        
        %keyboard
        EnzymeConc{n} = conc';
        EnzymeActs{n} = uf;
        for i = 1:size(uf,2)
            EnzymeFluxes{n}(:,i) = FLUXES(conc(i,:)',Kvec,1,uf(:,i));
        end
        EnzymeTimes(n) = TimeTaken;
        Bifs(n) = Bif;
        
    end        
   
    
end