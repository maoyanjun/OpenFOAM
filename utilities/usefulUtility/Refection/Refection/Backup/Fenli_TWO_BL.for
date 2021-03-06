CC SEPARATION OF INCIDENT AND REFLECTED SPECTRA IN WAVE FLUMES
C----------------------------------------------------------------
C IRREGULAR WAVE REFLECTION  ANALYSIS PROGRAMED BY lIU SHUXUE
C NS=2    No. OF WAVE GAUGES
C NTOTAL  No. OF WAVE DATA
C DT      TIME INTERVAL
C DEPTH   WATER DEPTH AT THE WAVE GAUGES
C DL      SPACING BETWEEN THE TWO GAUGES
C THE DATA OF THE 1ST GAUGE
C----------------------------------------------------------------
	 DIMENSION TSER(2,65536),E1(65536),E2(65536),EI1(65536),EI2(65536)
        DIMENSION WHI(32768),WHR(32768),AKRZ(32768),FE(32768)
        DIMENSION SPEI(65536),SPER(65536)
	  DIMENSION SER0(10,32768),NCH(100)
        CHARACTER*25 NAME

	  WRITE(*,*)' '
	  WRITE(*,*)'     SEPARATION OF INCIDENT AND REFLECTED SPECTRA' 
	  WRITE(*,*)'           USING TWO POINT METHOD PROGRAMDE BY '
	  WRITE(*,*)'            LIU SHUXUE, DUT  '

C	  WRITE(*,*)' '
C	  WRITE(*,1000)
C	  READ(*,*) NTOTAL

c	  WRITE(*,*)' '
c	  WRITE(*,1100)	   ! 输入时间间隔
c	  READ(*,*) DT
	  DT=0.02

	  WRITE(*,*)' '
	  WRITE(*,1200)		! 输入水深
	  READ(*,*) DEPTH

	  WRITE(*,*)' '
	  WRITE(*,1300)	   ! 输入数据文件名
	  READ(*,'(A)') NAME
	  WRITE(*,*)' '	
	  
       	write(*,*)name
	  OPEN(1,FILE=NAME,STATUS='OLD')

	  READ(1,*)NS,NTOTAL
	  READ(1,*)(NCH(I),I=1,NS)
	  DO I=1,NTOTAL
	   READ(1,*)(SER0(J,I),J=1,NS)
	  END DO

	  WRITE(*,*)'  选择 采用 的 两个通道号 ： '
	  READ(*,*)ICH1,ICH2
 	  WRITE(*,*)' '

 	  WRITE(*,*)' '
	  write(*,1400)    ! 输入测点间距，相对于建筑物，外侧测点对应1，内侧对应2
	  READ(*,*)DL

	  DO I=1,NS
	   IF(NCH(I).EQ.ICH1)I1=I
	   IF(NCH(I).EQ.ICH2)I2=I
        END DO  


	  DO J=1,NTOTAL
C	   READ(1,*)time,TSER(1,J),TSER(2,J)
         TSER(1,J)=SER0(I1,J)
         TSER(2,J)=SER0(I2,J)
	  END DO
	  CLOSE(1)

1000    FORMAT(1X, "LENGTH OF TIME SERIES IS:N="
     &          / 1X,"-->>")
1100    FORMAT(1X, " TIME  INTERVAL IS:DT="
     &          /1X, "-->>")
1200    FORMAT(1X, "THE DEPTH OF WATRE IS:DEPTH"
     &          / "-->>")
1300    FORMAT(1X, "TIME SERIES DATA FILE NAME IS"
     &          / 1X,"-->>")
1400    FORMAT(1X, "THE SPACE OF TWO POINTS: DL"
     &          / "-->>")


        DO I=1,NTOTAL
          E1(I)=0.0
          E2(I)=0.0
          EI1(I)=0.0
          EI2(I)=0.0
        END DO
        DO I=1,NTOTAL
         E1(I)=TSER(1,I)
         E2(I)=TSER(2,I)
        END DO
        NTS=NTOTAL

        INV=1
        CALL FFT(INV,NTS,E1,EI1)
        CALL FFT(INV,NTS,E2,EI2)

        DEL_F=1/DT/FLOAT(NTS)
        ALM1=DL/0.05
        AK1=2.*3.14159/ALM1
        ALM2=DL/0.45
        AK2=2.*3.14159/ALM2
        FLMAX=SQRT(AK2*9.8*TANH(AK2*DEPTH))/2./3.14159
        FLMIN=SQRT(AK1*9.8*TANH(AK1*DEPTH))/2./3.14159

         DO I=1,NTS/2

          FE(I)=FLOAT(I-1)*DEL_F
          IF(FE(I).GT.FLMIN.AND.FE(I).LT.FLMAX)THEN
           A1=2.0*E1(I)
           B1=2.0*EI1(I)
           A2=2.0*E2(I)
           B2=2.0*EI2(I)
           CALL REFLECTION(FE(I),DEPTH,DL,A1,A2,B1,B2,AI,AR,AKR)
           WHI(I)=AI
           WHR(I)=AR
           AKRZ(I)=AKR
          ELSE
           WHI(I)=0.0
           WHR(I)=0.0
           AKRZ(I)=0.0
          END IF

         END DO

         AIS=0.0
         ARS=0.0
         DO I=1,NTS/2
           AIS=AIS+WHI(I)**2
           ARS=ARS+WHR(I)**2
         END DO
	   ARS=SQRT(ARS)
	   AIS=SQRT(AIS)
         AKS=ARS/AIS
C
         WRITE(*,*)' THE ALALYZED REFLECTION COEFFICIENT: KR= ',AKS

	    WRITE(*,*)' '
	    WRITE(*,'(A\)')' ENTER INCIDENT AND REFLECTED SPECTRA  NAME:'
		READ(*,'(A)')NAME 
          OPEN(1,FILE=NAME,STATUS='UNKNOWN')

C	     WRITE(*,'(A\)')' SMOOTHING THE SPECTRA ?: (1=Y, 0=N): '
C		 READ(*,*)ISMO
           ISMO=1

           IFZ=0
           DO I=1,NTS/2
            IF(FE(I).GT.FLMAX*2)GOTO 321
            IFZ=IFZ+1
            SPEI(I)=WHI(I)**2/DEL_F/2.
            SPER(I)=WHR(I)**2/DEL_F/2.
 321       END DO
	     IF(ISMO.EQ.1)THEN

C	       WRITE(*,*)' '
C	       WRITE(*,'(A\)')' ENTER THE SMOOTHING POINT NPT= '
C	       READ(*,*)NPT
C	       WRITE(*,*)' '
C	       WRITE(*,'(A\)')' THE NO. OF SMOOTHING NPASS= '
C	       READ(*,*)NPASS
	       NPT=9
		   NPASS=3  
	        
             CALL SMOOTH(NPT,NPASS,IFZ,SPEI)
             CALL SMOOTH(NPT,NPASS,IFZ,SPER)
	     END IF
           DO I=1,IFZ
            WRITE(1,101)FE(I),SPEI(I),SPER(I)
           END DO
           CLOSE(1)
101        FORMAT(1X,3F12.8)
C           PAUSE

        STOP
        END
C
        SUBROUTINE REFLECTION(F,D,DL,A1,A2,B1,B2,AI,AR,AKR)

        W=2.*3.14159*F
        AK=WN(W,D)
        AI=SQRT((A2-A1*COS(AK*DL)-B1*SIN(AK*DL))**2
     &+(B2+A1*SIN(AK*DL)-B1*COS(AK*DL))**2)/(2.*ABS(SIN(AK*DL)))
        AR=SQRT((A2-A1*COS(AK*DL)+B1*SIN(AK*DL))**2
     &+(B2-A1*SIN(AK*DL)-B1*COS(AK*DL))**2)/(2.*ABS(SIN(AK*DL)))
        AKR=AR/AI

        RETURN
        END
C---------------------------------------------------
C THIS FUNCTION IS USED TO CALCULATE THE WAVE_NUMBER
C---------------------------------------------------
        FUNCTION WN(W,D)
        A=0.0
        B=25.0
        EP=1.0E-5
 11     Y=FF(W,B,D)
        IF(Y.LT.0.0)GOTO 22
        B=2.0*B
        GOTO 11
 22     C=A
        H=W*W/9.8/10.0
 5      Y0=FF(W,C,D)
 10     C=C+H
        IF(C.GT.B)THEN
        WRITE(*,*)'    B IS TOO SMALL  '
        STOP
        END IF
        Y1=FF(W,C,D)
        IF(Y1*Y0.LT.0.0.OR.Y1.EQ.0.0)GOTO 15
        Y0=Y1
        GOTO 10
 15     A1=C-H
        B1=C
        Y0=FF(W,A1,D)
 30     X=0.5*(A1+B1)
        Y=FF(W,X,D)
        IF(Y*Y0.GT.0.0)A1=X
        IF(Y*Y0.LE.0.0)B1=X
        DY=B1-A1
        if(dy.gt.ep)goto 30
        WN=X
        RETURN
        END
        FUNCTION FF(W,AK,D)
        FF=W*W-AK*9.8*TANH(AK*D)
        END
C
C****************************************************************
C--------------------------------------------------------------------
C INV=0: FOURIER TRANSFORM: OUTPUT=(XC,XS)*EXP(-iwt)
C					=[XC*COS(wt)+XS*SIN(wt)]+i[-XC*SIN(wt)+XS*COS(wt)]
C
C    =1: INVRESE FOURIER TRANSFORM; OUTPUT MULTIFIED BY N
C                                   =(XC,XS)*EXP(iwt)
C					=[XC*COS(wt)-XS*SIN(wt)]+i[XC*SIN(wt)+XS*COS(wt)]
C-------------------------------------------------------------------- 
	  SUBROUTINE FFT(INV,N,XC,XS)
        DIMENSION XC(65536),XS(65536)
        REAL UC,US,WC,WS,TC,TS
        M=ALOG(FLOAT(N))/ALOG(2.0)+0.1
        NV2=N/2
        NM1=N-1
        J=1
        DO 40 I=1,NM1
        IF(I.GE.J) GOTO 10
        TC=XC(J)
        TS=XS(J)
        XC(J)=XC(I)
        XS(J)=XS(I)
        XC(I)=TC
        XS(I)=TS
10      K=NV2
20      IF(K.GE.J) GOTO 30
        J=J-K
        K=K/2
        GOTO 20
30      J=J+K
40      CONTINUE
        PI=4.0*ATAN(1.0)
        DO 70 L=1,M
        LE=2**L
        LE1=LE/2
        UC=1.0
        US=0.0
        WC=COS(PI/FLOAT(LE1))
        WS=-SIN(PI/FLOAT(LE1))
        IF(INV.NE.0)WS=-WS
        DO 60 J=1,LE1
        DO 50 I=J,N,LE
        IP=I+LE1
        TC=XC(IP)*UC-XS(IP)*US
        TS=XS(IP)*UC+XC(IP)*US
        XC(IP)=XC(I)-TC
        XS(IP)=XS(I)-TS
        XC(I)=XC(I)+TC
        XS(I)=XS(I)+TS
50      CONTINUE
        UC1=UC*WC-US*WS
        US=US*WC+UC*WS
        UC=UC1
60      CONTINUE
70      CONTINUE
C        TYPE*,' N=',N
        IF(INV.EQ.0) RETURN
        DO 80 I=1,N
        XC(I)=XC(I)/FLOAT(N)
        XS(I)=XS(I)/FLOAT(N)
80      CONTINUE
        RETURN
        END
C****************************************************************

        SUBROUTINE SMOOTH(NPT,NPASS,ITOTAL,RESULT)
C
C       This subroutine takes 2 arrays describing 2 address windows
C               describing a 65536 word array in common block /REGR/
C               and smooths ITOTAL points with a NPT point and NPASS
C               pass moving average smoothing, keeping the average in
C               array SMOTH.
C
        DIMENSION SMOTH(101),REF(49)
        DOUBLE PRECISION SUMTMP,SUMR
        DIMENSION RESULT(1)
C
C       Loop over the number of passes
C
        DO 1000 IPASS=1,NPASS
C
C       Fill SMOTH array for 1st time get initial sum
C
        SUMTMP=0.
        DO 11 J=1,NPT
        SMOTH(J)=RESULT(J)
        SUMTMP=SUMTMP+DBLE(RESULT(J))
11      CONTINUE
C
C       Smooth 1st NPT/2 points
C
C               Treat spectrum as a reflection about 0
C
C               Calculate initial sum
C
        SUMR=0.                         !initialize sum
        DO 5 I=1,NPT/2-1
        REF(I)=RESULT(I)                !fill in array of reflected values
        SUMR=SUMR+2*DBLE(REF(I))        !add reflected values to sum
5       CONTINUE                        !end of loop
        SUMR=SUMR+DBLE(RESULT(NPT/2))+DBLE(RESULT(NPT/2+1))   !add last 2 pts.
C
C               Fill in 1st NPT/2 values
C
        DO 10 I=1,NPT/2
        RESULT(I)=SNGL(SUMR/FLOAT(NPT))         !fill in averaged value
        IF (I .NE. NPT/2) THEN
                SUMR=SUMR-DBLE(REF(NPT/2-I))    !decrement sum
                SUMR=SUMR+DBLE(RESULT(NPT/2+1+I))   !add to sum
        END IF
10      CONTINUE                                !end of loop
C
C       Fill in smoothed value for NPT/2+1
C
        RESULT(NPT/2+1)=SNGL(SUMTMP)/NPT
C
C       Initialize pointers:
C                               PTR1-pointer for SMOTH array
C                               PTR2-pointer used to read from RESULT array
C                               PTR3-pointer used to read/write to RESULT array
C
        JCOUNT=0
C        ICOUNT=0
        PTR1=1
        PTR2=NPT+1
        PTR3=NPT/2+1
C
C       Top of main smoothing loop
C
12      CONTINUE
C
C       Put new avg in PTR3+1 from PTR3*NPT - PTR1 + PTR2
C               change value in PTR1
C
        SUMTMP=SUMTMP+DBLE(RESULT(PTR2)-SMOTH(PTR1))
        RESULT(PTR3+1)=SNGL(SUMTMP)/NPT
        SMOTH(PTR1)=RESULT(PTR2)
C
C       Increment pointers
C
        PTR1=PTR1+1
        PTR2=PTR2+1
        PTR3=PTR3+1
        JCOUNT=JCOUNT+1
C
C       Test pointers for reaching boundaries
C
        IF (JCOUNT .GT. ITOTAL) GOTO 1000
        IF (PTR1 .GT. NPT) PTR1=1
        IF (PTR2 .GT. ITOTAL) PTR2=1
        IF (PTR3 .GT. ITOTAL)GOTO 1000
C        IF (PTR3 .GT. ITOTAL) THEN
C                IF (ITOTAL-JCOUNT .LE. 65536) GOTO 16
C16              PTR3=1
C        ELSE
C                IF (PTR3 .EQ. 8193) THEN
C                        ICOUNT=ICOUNT+2
C                        IF (ITOTAL-JCOUNT .LT. 65536) GOTO 17
C17                      CONTINUE
C                END IF
C        END IF
        GOTO 12
C
C       Exit main smoothing loop
C
1000    CONTINUE
        RETURN
        END