"----------------------------------------------"
" Contributor: Tobias Holzmann                 "
" Last Change: December 2016                   "
"----------------------------------------------"
" Location:    www.Holzmann-cfd.de             "
" Email:       Tobias.Holzmann@Holzmann-cfd.de "
"----------------------------------------------"


" OpenFOAM variables
"-------------------------------------------------------------------------------

    "- Highlight the fluid or solid FOAM variables
    syntax keyword variables 
    \ nu 
    \ nuInf 
    \ nPhi
    \ n
    \ m
    \ nTheta
    \ Sf
    \ S
    \ nu0 
    \ sigma 
    \ E
    \ U 
    \ p 
    \ p_rgh 
    \ k 
    \ epsilon 
    \ alpha
    \ omega 
    \ nut 
    \ mut 
    \ mu 
    \ nuTilda 
    \ R 
    \ rho
    \ rhok
    \ psi 
    \ gamma 
    \ phi 
    \ p0 
    \ T 
    \ h 
    \ phiU 
    \ K 
    \ sigmaS 
    \ emissivity 
    \ absorptivity
    \ Cp 
    \ Hf 
    \ kappa 
    \ n0 
    \ Tref 
    \ C0 
    \ K0 
    \ Pr 
    \ DT 
    \ phid 
    \ phirb 
    \ alpha 
    \ thermo 
    \ meshPhi 
    \ pcorr 
    \ b
    \ Su
    \ Xi
    \ ha
    \ hau
    \ Final
    \ Eff
    highlight link variables foam256_variables                                                                                

    "- Highlight the fluid or solid FOAM variables 'Final'
    syntax match varFinal 
    \ "[a-zA-Z\.]\+Final\{1}"
    highlight link varFinal foam256_variables                                                                                

    "- Highlight the fluid or solid FOAM variables 'Eff'
    syntax match varEff 
    \ "[a-zA-Z\.]\+Eff\{1}"
    highlight link varEff foam256_variables                                                                                

    "- Highlight the alpha things
    "- TODO highlight for different alpha regions
    " syntax match varAlpha 
    " \ "alpha[\.a-z]\+"
    " highlight link varAlpha foam256_variables


"-------------------------------------------------------------------------------
