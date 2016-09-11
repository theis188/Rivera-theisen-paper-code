Code was written and executed in MATLAB 2014b. To run code, first unzip into an empty directory.

Fig 1) Freehand in PowerPoint.

Fig 2) 
- Fig 2A is freehand in Powerpoint. 
- Fig 2B: Navigate to the EMRA subfolder within MATLAB. Type 'PlotPathwaySizes' on the MATLAB command line and press enter.

Fig 3)
- Navigate to the ToyModel subfolder. Type 'AllLaunchKAF' on the MATLAB command line and press enter.
- A file of the form 'FinalSimpButKAF_SeveralPerturbations_1Models_YYYYMMDD_HHMMSS.mat' is generated.
- Paste the file name into the indicated line of 'StuffPlotter.m' (line 2). Save m-file.
- Type 'StuffPlotter' on the MATLAB command line and press enter.
- 11 figures are generated:
	-Fig 3A = Figure 9
	-Fig 3B = Figure 3
	-Fig 3C = Figure 2
	-Fig 3D = Figure 11
	-Fig 3E = Figure 5

Fig 4 (Old figure 5)
- Navigate to the EMRA subfolder. Type 'SimpLaunch_Glyc' on the MATLAB command line and press enter.
- NOTE: This process may take days if it is not multithreaded. On a single core system, expect long runtimes.
- FOR access to a sample result file, email:mtheisen@ucla.edu
- A file of the form 'Revision2_SeveralPerturbations_1000Models_YYYYMMDD_HHMMSS.mat' is generated.
- Paste the filename into 'IsobutanolYieldsNoScreeningMedQuarts.m' on the appropriate line (line 8).
- Type 'IsobutanolYieldsNoScreeningMedQuarts' on the MATLAB command line and press enter.
- Figure generated is Fig 5B.
- Fig 5A is freehand in PowerPoint.

Fig 5) Freehand in powerpoint

TO GENERATE MODELS:
- Navigate to BuildingModel subfolder. Type 'MainModelMaker' on the MATLAB command line and press enter.
- This generates models directly from the EcoCyc .dat files.

Suppplementary File S1)

Fig 1) Freehand Figure.

Figs 2 & 4) Navigate to the EMRA subfolder. Execute 'CalculateCellWideEntropy'. If results files not available, run IsobutanolPerturbAllModeOptsPreparation twice. Once with 'Original' in the space on line 20, and once with 'Revision2'. Place the original model & results, and the updated results filenames pasted in the appropriate lines (lines 1,3,74) of 'CalculateCellWideEntropy'. NOTE: IsobutanolPerturbAllModeOptsPreparation will take weeks to run singlethreaded. Contact mtheisen@ucla.edu for sample results files. Run 'IsobutanolPerturbAllModeOptsPreparation'.

Fig 3) Freehand in PowerPoint.

Supplementary S3)
- Navigate to the ToyModel subfolder. Type 'AllLaunchKAF' on the MATLAB command line and press enter.
- Five files of the form 'FinalSimp[Compound]KAF_SeveralPerturbations_1Models_YYYYMMDD_HHMMSS.mat' are generated in the current folder.
- Paste the filenames into the indicated line of the 'AllStuffPlotter.m' m-file (lines 8-12). Save the m-file.
- Type 'AllStuffPlotter' on the MATLAB command line and press enter.
