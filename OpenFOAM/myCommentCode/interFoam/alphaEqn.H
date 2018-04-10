//// ********************************************   2.2.0 �汾    *******************************************////

    word alphaScheme("div(phi,alpha)");
    word alpharScheme("div(phirb,alpha)");
    surfaceScalarField phic(mag(phi/mesh.magSf()));    // ��������ٶȾ���ֵ  phic �� حUح
    phic = min(interface.cAlpha()*phic, max(phic));    //حUح=min (cAlpha*حUح��max(حUح))
    surfaceScalarField phir(phic*interface.nHatf());   // Ur = حUح* n *Sf   ���У�nHatf()Ϊ���ɱ���ĵ�λ������*Sf
                                                       //   surfaceVectorField nHatfv(gradAlphaf/(mag(gradAlphaf) + deltaN_));
    for (int aCorr=0; aCorr<nAlphaCorr; aCorr++)       //   deltaN_= 1e-8/pow(average(alpha1.mesh().V()), 1.0/3.0)   �ǳ�С��ֵ ��֤��ĸ��Ϊ0        
                                                       //   nHatf_ = nHatfv & Sf; 
    {                                                  
        surfaceScalarField phiAlpha
        (
            fvc::flux                                                    // phi*alpha1 ��U*alpha1��
            (
                phi,
                alpha1,
                alphaScheme
            )
          + fvc::flux                                                  // Ur*(1-alpha1)*alpha1
            (
                -fvc::flux(-phir, scalar(1) - alpha1, alpharScheme),   //  Ur*(1-alpha1)
                alpha1,                                                // *alpha1
                alpharScheme
            )
        );

        MULES::explicitSolve(alpha1, phi, phiAlpha, 1, 0);  // ���alpha1  ��ֵ ��Χ��0~1  

        rhoPhi = phiAlpha*(rho1 - rho2) + phi*rho2;   // rhoPhi = alpha1*(rho1-rho2)+(alpha1+alpha2)*U*rho2  ==  alpha1*U*rho1+alpha2*U*rho2
    }

    Info<< "Phase-1 volume fraction = "
        << alpha1.weightedAverage(mesh.Vsc()).value()
        << "  Min(alpha1) = " << min(alpha1).value()
        << "  Max(alpha1) = " << max(alpha1).value()
        << endl;
}



//// ********************************************   3.0.1 �汾    *******************************************////

{
    word alphaScheme("div(phi,alpha)");
    word alpharScheme("div(phirb,alpha)");

    tmp<fv::ddtScheme<scalar> > ddtAlpha   //����tmp��ģ��  ���alpha��ʱ�䵼��
    (
        fv::ddtScheme<scalar>::New
        (
            mesh,
            mesh.ddtScheme("ddt(alpha)")
        )
    );

    // Set the off-centering coefficient according to ddt scheme
    scalar ocCoeff = 0;     //����ddt��ʽ��ƫ��ϵ��
    if                      //�����Euler����localEulerʱ����ɢ��ʽ  ocCoeff = 0
    (
        isType<fv::EulerDdtScheme<scalar> >(ddtAlpha())
     || isType<fv::localEulerDdtScheme<scalar> >(ddtAlpha())
    )
    {
        ocCoeff = 0;
    }
    else if (isType<fv::CrankNicolsonDdtScheme<scalar> >(ddtAlpha()))
    {
        if (nAlphaSubCycles > 1)
        {
            FatalErrorIn(args.executable())
                << "Sub-cycling is not supported "
                   "with the CrankNicolson ddt scheme"
                << exit(FatalError);
        }

        ocCoeff =
            refCast<fv::CrankNicolsonDdtScheme<scalar> >(ddtAlpha()).ocCoeff();
    }
    else
    {
        FatalErrorIn(args.executable())
            << "Only Euler and CrankNicolson ddt schemes are supported"
            << exit(FatalError);
    }

    scalar cnCoeff = 1.0/(1.0 + ocCoeff);   //����C-N��ʽ��ϵ�� 

    // Standard face-flux compression coefficient  //���ñ�׼�ı�������ѹ��ϵ�� 
    surfaceScalarField phic(mixture.cAlpha()*mag(phi/mesh.magSf()));  //Uc=cAlpha*حUح      mesh.magSf()=حAح     phi = linearInterpolate(U) & mesh.Sf()

    // Add the optional isotropic compression contribution   //���ݸ���ͬ��ѹ������icAlpha  ����ͬ��ѹ������
    if (icAlpha > 0)   // Ĭ�� icAlpha = 0 (һ�㲻���Ǵ���)
    {
        phic *= (1.0 - icAlpha);                                      //Uc=cAlpha*حUح*(1-icAlpha)
        phic += (mixture.cAlpha()*icAlpha)*fvc::interpolate(mag(U));  // Uc=cAlpha*حUح*(1-icAlpha)+ cAlpha*icAlpha*حUح= cAlpha*حUح
    }

    // Do not compress interface at non-coupled boundary faces  //�ڲ���ϵı߽��治����ѹ����
    // (inlets, outlets etc.)
    forAll(phic.boundaryField(), patchi)   
    {
        fvsPatchScalarField& phicp = phic.boundaryField()[patchi];

        if (!phicp.coupled())
        {
            phicp == 0;
        }
    }

    tmp<surfaceScalarField> phiCN(phi); //����phiCN=phi

    // Calculate the Crank-Nicolson off-centred volumetric flux
    if (ocCoeff > 0)
    {
        phiCN = cnCoeff*phi + (1.0 - cnCoeff)*phi.oldTime();    //���CN��ʽ�µļ�ȨphiCN
    }

    if (MULESCorr)    //����MULES������������෽��
    {
        fvScalarMatrix alpha1Eqn   //����ѹ������෽�� ��ɢ���  
        (
            (
                LTS
              ? fv::localEulerDdtScheme<scalar>(mesh).fvmDdt(alpha1)
              : fv::EulerDdtScheme<scalar>(mesh).fvmDdt(alpha1)    //�෽�̵�һ��
            )
          + fv::gaussConvectionScheme<scalar>         
            (
                mesh,
                phiCN,
                upwind<scalar>(mesh, phiCN)
            ).fvmDiv(phiCN, alpha1)       //�෽�̵ڶ���
        );

        alpha1Eqn.solve();    //  ����෽��

        Info<< "Phase-1 volume fraction = "      //���alphaֵ
            << alpha1.weightedAverage(mesh.Vsc()).value()
            << "  Min(" << alpha1.name() << ") = " << min(alpha1).value()
            << "  Max(" << alpha1.name() << ") = " << max(alpha1).value()
            << endl;

        tmp<surfaceScalarField> talphaPhiUD(alpha1Eqn.flux());   // talphaPhiUD = fvmDiv(phiCN, alpha1)  =  U * alpha1
        alphaPhi = talphaPhiUD();                                //alphaPhi =  talphaPhiUD = fvmDiv(phiCN, alpha1)=  U * alpha1

        if (alphaApplyPrevCorr && talphaPhiCorr0.valid())  // talphaPhiCorr Ĭ��Ϊ�ر�
                                                           // Apply the compression correction from the previous iteration
                                                           // Improves efficiency for steady-simulations but can only be applied                                                         	
                                                           // once the alpha field is reasonably steady, i.e. fully developed
        {
            Info<< "Applying the previous iteration compression flux" << endl;  //Ӧ����һ��������ѹ��ͨ��
            MULES::correct(alpha1, alphaPhi, talphaPhiCorr0(), 1, 0);  //����MULES���෽�̽�������

            alphaPhi += talphaPhiCorr0();
        }

        // Cache the upwind-flux
        talphaPhiCorr0 = talphaPhiUD;    //�洢ӭ���ʽ�µ� talphaPhiUD 

        alpha2 = 1.0 - alpha1;    //�ֱ����alpha1��alpha2

        mixture.correct();    //����ƽ���˶�ճ�� �� ��������
    }


    for (int aCorr=0; aCorr<nAlphaCorr; aCorr++)    // ����alpha����ѭ�������������෽�̽�������
    {                                            
    	                                 //   surfaceVectorField nHatfv(gradAlphaf/(mag(gradAlphaf) + deltaN_)); 
    	                                 //   deltaN_= 1e-8/pow(average(alpha1.mesh().V()), 1.0/3.0)   �ǳ�С��ֵ ��֤��ĸ��Ϊ0 
    	                                 //   nHatf_ = nHatfv & Sf;
    	                                 //   http://www.cfd-online.com/Forums/openfoam-solving/58149-about-gammaeqn-interfoam.html
    	                                 
        surfaceScalarField phir(phic*mixture.nHatf());  // phir -> Ur = Uc*n*Sf   ���У�nHatf()Ϊ���ɱ���ĵ�λ������*Sf
                                                      

        tmp<surfaceScalarField> talphaPhiUn            //��ѹ������෽�� ��ɢ���
        (
            fvc::flux                                 // phi*alpha1 ��U*alpha1��
            (
                phi,
                alpha1,
                alphaScheme
            )
          + fvc::flux      //ѹ����                 // Ur*(1-alpha1)*alpha1
            (
               -fvc::flux(-phir, alpha2, alpharScheme),    //  Ur*(1-alpha1)
                alpha1,                                    //*alpha1
                alpharScheme
            )
        );

        // Calculate the Crank-Nicolson off-centred alpha flux
        if (ocCoeff > 0)
        {
            talphaPhiUn =
                cnCoeff*talphaPhiUn + (1.0 - cnCoeff)*alphaPhi.oldTime();      //��Ȩ��talphaPhi����ΪtalphaPhiUn
        }

        if (MULESCorr)    //����MULES����
        {
            tmp<surfaceScalarField> talphaPhiCorr(talphaPhiUn() - alphaPhi);  //����ֵ�� talphaPhiCorr = talphaPhiUn() - alphaPhi
            volScalarField alpha10("alpha10", alpha1);                        //alpha10=alpha1

            MULES::correct(alpha1, talphaPhiUn(), talphaPhiCorr(), 1, 0);  //��ѹ������෽��

            // Under-relax the correction for all but the 1st corrector
            if (aCorr == 0)   //��һ��ѭ��
            {
                alphaPhi += talphaPhiCorr();           //��һ��ѭ��ʱ���� alphaPhi = talphaPhiUn()
            }
            else
            {
                alpha1 = 0.5*alpha1 + 0.5*alpha10;    // ��Ȩ���� alpha1
                alphaPhi += 0.5*talphaPhiCorr();      // alphaPhi= alphaPhi + 0.5*talphaPhiCorr()   
            }
        }
        else
        {
            alphaPhi = talphaPhiUn;                  //������MULES����ʱ��ֱ�Ӵ���talphaPhiUn ���ٴ�����෽�� 

            MULES::explicitSolve(alpha1, phiCN, alphaPhi, 1, 0);
        }

        alpha2 = 1.0 - alpha1;

        mixture.correct();      //����ƽ���˶�ճ�� �� ��������
    }

    if (alphaApplyPrevCorr && MULESCorr)    
    {		
        talphaPhiCorr0 = alphaPhi - talphaPhiCorr0;
    }

    if
    (
        word(mesh.ddtScheme("ddt(rho,U)"))
     == fv::EulerDdtScheme<vector>::typeName
    )
    {
        rhoPhi = alphaPhi*(rho1 - rho2) + phiCN*rho2;     // alpha1*U*(rho1-rho2)+(alpha1+alpha2)*U*rho2  ==  alpha1*U*rho1+alpha2*U*rho2
    }
    else                                                  //�����CN��ɢ��ʽ������CN��ȨrhoPhi
    {
        if (ocCoeff > 0)
        {
            // Calculate the end-of-time-step alpha flux
            alphaPhi = (alphaPhi - (1.0 - cnCoeff)*alphaPhi.oldTime())/cnCoeff;    //���alphaPhi
        }

        // Calculate the end-of-time-step mass flux
        rhoPhi = alphaPhi*(rho1 - rho2) + phi*rho2;    //���rhoPhi = U*(alpha1*rho1+alpha2*rho2��
    }

    Info<< "Phase-1 volume fraction = "
        << alpha1.weightedAverage(mesh.Vsc()).value()
        << "  Min(" << alpha1.name() << ") = " << min(alpha1).value()
        << "  Max(" << alpha1.name() << ") = " << max(alpha1).value()
        << endl;
}
