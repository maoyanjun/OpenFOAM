const dictionary& alphaControls = mesh.solverDict(alpha1.name());

label nAlphaCorr(readLabel(alphaControls.lookup("nAlphaCorr"))); //��ǰʱ�䲽�ڶ��ೡ����ѭ�����

label nAlphaSubCycles(readLabel(alphaControls.lookup("nAlphaSubCycles")));//����alpha��������ѭ������Ŀ  ����ʱ�䲽���Ա�֤����ȶ�

bool MULESCorr(alphaControls.lookupOrDefault<Switch>("MULESCorr", false));//MULES���� ��֤���κ���ֵ��ʽ���������͵�������ೡ�н�

// Apply the compression correction from the previous iteration //����һ������Ӧ��ѹ������
// Improves efficiency for steady-simulations but can only be applied //����ȶ�ģ���Ч��
// once the alpha field is reasonably steady, i.e. fully developed //ֻ������ȶ���alpha����Ӧ��
bool alphaApplyPrevCorr
(
    alphaControls.lookupOrDefault<Switch>("alphaApplyPrevCorr", false)
);

// Isotropic compression coefficient
scalar icAlpha
(
    alphaControls.lookupOrDefault<scalar>("icAlpha", 0) //����ͬ��ѹ������
);