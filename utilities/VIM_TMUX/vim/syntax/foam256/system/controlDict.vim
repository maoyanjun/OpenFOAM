"----------------------------------------------"
" Contributor: Tobias Holzmann                 "
" Last Change: December 2016                   "
"----------------------------------------------"
" Location:    www.Holzmann-cfd.de             "
" Email:       Tobias.Holzmann@Holzmann-cfd.de "
"----------------------------------------------"


" controlDict  
"-------------------------------------------------------------------------------


    "- Keys in controlDict on the left side (LS)
    syn keyword ctrDictKeysLS 
    \ startFrom
    \ stopAt
    \ deltaT
    \ writeControl
    \ writeInterval
    \ purgeWrite 
    \ writeFormat 
    \ writePrecision 
    \ writeCompression 
    \ timeFormat 
    \ timePrecision 
    \ runTimeModifiable 
    \ libs 
    \ adjustTimeStep 
    \ maxCo 
    \ maxAlphaCo 
    \ maxDeltaT 
    \ application 
    \ setFormat 
    \ outputControl 
    \ maxDi
    \ secondaryWriteControl
    \ secondaryWriteInterval
    \ secondaryPurgeWrite
    highlight link ctrDictKeysLS foam256_keyOnLeftSide


    "- Dictionaries
    syn keyword ctrDictDict
    \ functions
    highlight link ctrDictDict foam256_dictionary



    "- Keys in controlDict on the right side (RS)
    syn keyword ctrDictKeysRS 
    \ firstTime 
    \ latestTime 
    \ writeNow
    \ noWriteNow 
    \ nextWrite 
    \ timeStep 
    \ runTime 
    \ adjustableRunTime 
    \ cpuTime 
    \ clockTime 
    \ ascii 
    \ binary 
    \ uncompressed 
    \ compressed 
    \ fixed 
    \ scientific 
    \ general 
    \ raw 
    \ gnuplot 
    \ xmgr 
    \ jplot 
    \ outputTime 
    \ vtk 
    \ particleTracks 
    \ axis 
    \ start 
    \ end 
    \ nPoints
    highlight link ctrDictKeysRS foam256_keyOnRightSide

    
    "- Special keys which match left and right but are on right side 
    syn match ctrDictSpecialRS 
    \ " startTime\| endTime"
    highlight link ctrDictSpecialRS foam256_keyOnRightSide


    "- Special keys which match left and right but are on left side 
    syn match ctrDictSpecialLS 
    \ "^startTime\|^endTime"
    highlight link ctrDictSpecialLS foam256_keyOnLeftSide

    
    "- Solver highlight
    syn match ctrDictSolver
    \ "[a-zA-Z]\+Foam"
    highlight link ctrDictSolver foam256_solvers 


"-------------------------------------------------------------------------------
