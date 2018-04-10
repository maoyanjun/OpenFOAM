if (nAlphaSubCycles > 1)   //nAlphaSubCycles�����ָ��ʱ�䲽����
{
    dimensionedScalar totalDeltaT = runTime.deltaT();   //��ʱ�䲽��=deltaT
    surfaceScalarField rhoPhiSum      //����rhoPhiSum
    (
        IOobject
        (
            "rhoPhiSum",
            runTime.timeName(),
            mesh
        ),
        mesh,
        dimensionedScalar("0", rhoPhi.dimensions(), 0)
    );

    tmp<volScalarField> trSubDeltaT;

    if (LTS)
    {
        trSubDeltaT =
            fv::localEulerDdt::localRSubDeltaT(mesh, nAlphaSubCycles);
    }

    for
    (
        subCycle<volScalarField> alphaSubCycle(alpha1, nAlphaSubCycles);  //���ѭ�������෽��
        !(++alphaSubCycle).end();
    )
    {
        #include "alphaEqn.H"
        rhoPhiSum += (runTime.deltaT()/totalDeltaT)*rhoPhi;   //�Ӻͼ�������������ʱ�䲽��rhoPhi
    }

    rhoPhi = rhoPhiSum;
}
else  //nAlphaSubCycles=1ʱ ���ָ�ʱ�䲽
{
    #include "alphaEqn.H"   //���rhoPhi ,alpha����������k
}

rho == alpha1*rho1 + alpha2*rho2;  //	����Ȩ�� rho