      SUBROUTINE OUTPUT(K,ZI,CI,NL,NPT,H,Q,WORK,SMOUT,SMIN,FACTOR,NSR,
     2ZS,NS,ZR,NR,ZM,ZMX,KND,ISR,SR,UN,NMODES,MXNM,LOWER,IUPPER,NMCAL,
     3NWL,ZP,CP,NBL,HBOT,CBOT,RHO,ALPBT,FREQ,MAXNL,AMPL,PHSE,
     4IERR)
      INTEGER I,I2PI,IB,IEF,IERR,INDEX,ISR,ITMAX,IUPPER,MAXNL,
     1    J,K,LAYER,LIM,LOWER,MXNM,NBL,NL,NMODES,NMCAL,NMIN,NPT,NR,NS,
     2    NSR,NWAT,NWL,LUO
      REAL AA,ALPBT,AP,AWKB,CBOT,CP,DEG,DEP,DEPTH,FREQ,G1,G2,GF,
     1    GFA,GFP,H,HBOT,HL,PHI,PHIP,PWKB,RHO,TOLU,UN,VMAX,VMIN,
     2    ZMX,ZP,ZR,ZS,TOLK,TOLGAM,AMPL(MAXNL,NMODES),
     3    PHSE(MAXNL,NMODES)
      DOUBLE PRECISION WORK,SMOUT,SMIN,FACTOR,G,GAMMA2,GAMMA,           16/07/82
     2    GSS,A,B,E,ZI,CI,Q,KND,SR,X,PI                                 16/07/82
      DIMENSION ZI(NL),CI(NL),WORK(NL,2),ZS(NS),ZR(NR),ISR(25),SR(25),
     2    UN(MXNM,NSR),KND(NMODES),ZP(NWL),CP(NWL),CBOT(NBL),HBOT(NBL),
     3    RHO(0:NBL),ALPBT(NBL)
      INTEGER ZM
      LOGICAL EIGF,EIGV,TLFLG,ATTFLG,GVLFLG,CPFLG,PFFLG
      COMMON/PAR/VMIN,VMAX,NMIN,ITMAX,IEF
      COMMON/TOL/TOLK,TOLU,TOLGAM
      COMMON /PRTFLG/LUO,EIGF,EIGV,TLFLG,ATTFLG,GVLFLG,CPFLG,PFFLG
      PARAMETER (PI=3.1415926535897932384626433832795D0)
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C          THIS SUBROUTINE DOES THE FOLLOWING:
C       -INCREMENT NMCAL
C       -NORMALIZES THE EIGENFUNCTION
C       -CALCULATES THE EIGENFUNCTION AT THE SOURCE AND RECIEVER DEPTHS
C       -PLOTS OR PRINTS THE EIGENFUNCTION AS SPECIFIED
C       -STORES THE FINAL VALUE OF THE EIGENVALUE
C
C       INPUT VARIABLES:
C         K,ZI,CI,H,NPT,NL,Q,SMOUT,SMIN,FACTOR,NSR,ZS,NS,ZR,NR,ZM,
C         ZMX,UOUT,UDROUT,UIN,UDRIN,ISR,SR,NMODES,KND,WORK,LOWER,NMCAL
C
C       OUTPUT VARIABLES:
C         UN,KN
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C       SAVE Q IN ARRAY KND
C       INCREMENT NMCAL
C
      INDEX = K - LOWER + 1                                             16/07/82
      KND(INDEX)=Q                                                      16/07/82
      NMCAL=NMCAL+1
C
C       MULTIPLY THE VALUES OF THE EIGENFUNCTION FROM THE OUTWARDS
C        INTEGRATION BY FACTOR
C
      LIM=ZM
      IF(ZMX.EQ.0.0)LIM=LIM-1
      IF(LIM.EQ.0)GO TO 125
      DO 100 I=1,LIM
      WORK(I,1)=WORK(I,1)*FACTOR
  100 WORK(I,2)=WORK(I,2)*FACTOR
C
C       NORMALIZE THE EIGENFUNCTION SO THAT THE INTEGRAL IS ONE
C
C
  125 G=1.0D0/(DSQRT((SMOUT+SMIN)*DBLE(H)))
      DO 200 I=1,NL
      WORK(I,1)=WORK(I,1)*G
  200 WORK(I,2)=WORK(I,2)*G
C
C       CALCULATE THE EIGENFUNCTION AT THE SOURCE AND RECIEVER DEPTHS
C
      HL=H/FLOAT(NPT)
      DO 400 I=1,NSR
      IF(I.GT.25)GO TO 310
      LAYER=ISR(I)
      X=SR(I)
      GO TO 350
  310 IF(I.GT.NS)GO TO 315
      DEPTH=ZS(I)
      GO TO 320
  315 DEPTH=ZR(I-NS)
  320 IF(DEPTH.GT.H)GO TO 330
      LAYER=IFIX(DEPTH/HL)+1
      X=DBLE((DEPTH-SNGL(ZI(LAYER))*H)/H)
      GO TO 350
  330 DEPTH=DEPTH/H
      DO 335 J=NPT,NL-1
      IF(DEPTH.GE.SNGL(ZI(J)).AND.DEPTH.LT.SNGL(ZI(J+1)))GO TO 340
  335 CONTINUE
      J=NL
  340 LAYER=J
      X=DBLE(DEPTH)-ZI(J)
  350 GAMMA2=CI(LAYER)-Q
      GAMMA=DSQRT(DABS(GAMMA2))
      IF(GAMMA2.GT.TOLGAM)GO TO 360
      IF(GAMMA2.LT.-TOLGAM)GO TO 370
      UN(INDEX,I)=SNGL(WORK(LAYER,1)+WORK(LAYER,2)*X)                   13/07/82
      GO TO 400
  360 GSS=GAMMA*X
      UN(INDEX,I)=SNGL(WORK(LAYER,2)/GAMMA*DSIN(GSS)+WORK(LAYER,1)*     13/07/82
     $   DCOS(GSS))                                                     13/07/82
      GO TO 400
  370 A=0.5D0*(WORK(LAYER,1)+WORK(LAYER,2)/GAMMA)
      B=0.5D0*(WORK(LAYER,1)-WORK(LAYER,2)/GAMMA)
      E=DEXP(GAMMA*X)
      UN(INDEX,I)=SNGL(A*E+B/E)                                         13/07/82
  400 CONTINUE
C
C       INSERT IN THIS SPOT THE PREPARATIONS FOR THE OPTIONAL
C        PRINTING OR PLOTTING OUTPUTS
C
      NWAT = NL-NBL
      DEG = 180./PI
      IF (EIGF) THEN
          WRITE(LUO,450)K
  450     FORMAT(//,' EIGENFUNCTION ',I5,/,
     1      4X,'IZ',5X,'DEPTH',12X,'A',12X,'PHI',13X,'AP',12X,'PHIP',
     1      13X,'U',14X,'UP')
      ENDIF
C
      I2PI = 0
      DO 500 I=1,NL
        DEP=H*ZI(I)
C          CALCULATE A MONOTONIC AMPLITUDE AND PHASE
        GF  = RHO(0)
        IF (I.GT.NWAT)  GF=GF/RHO(I-NWAT)
        AA = DSQRT (  WORK(I,1)**2 + ( GF*WORK(I,2) )**2 )
        IF (WORK(I,1).EQ.0..AND. WORK(I,2).EQ.0.) THEN
            PHI = 0.0
        ELSE
            PHI = DEG * ATAN2 ( WORK(I,1), GF*WORK(I,2) )
        ENDIF
C
C          TRY TO GET A SMOOTHER AMPLITUDE AND PHASE
        G2 = CI(I)-Q
        G1 = SQRT ( ABS(G2) )
        GFA= RHO(0)/G1
        GFP= GFA
C            IF (G1 .LT. 1.0)  GFP=1.0
C            IF (G2 .LT. 4.0)  GFA=0.5
        IF (I .GT. NWAT)  THEN
            GFA=GFA/RHO(I-NWAT)
            GFP=GFP/RHO(I-NWAT)
        ENDIF
        AP = DSQRT (  WORK(I,1)**2 + (GFA*WORK(I,2))**2 )
        IF (WORK(I,1).EQ.0..AND. WORK(I,2).EQ.0.) THEN
            PHIP = 0.0
        ELSE
            PHIP = DEG * ATAN2 ( WORK(I,1), GFP*WORK(I,2) )
        ENDIF
        IF (PHIP.LT.0.)  PHIP = PHIP + 360.
        PHIP = PHIP + 360.*I2PI
        IF (I.NE.NL)  THEN
          IF (G2.GT.TOLGAM**2)  THEN
             I2PI = PHIP/360. + G1*(ZI(I+1)-ZI(I))/(PI*2.)
              IB = 1
          ELSE
             IF (WORK(I,1).LT.0. .AND. WORK(I+1,1).GE.0.)
     1          I2PI = I2PI + 1
              IB=2
          ENDIF
        ENDIF
C          WRITE RESULTS
        IF ( MOD(K,2) .EQ. 0 )  PHIP = PHIP - 180.
        IF (EIGF) WRITE (LUO,550)  I,DEP,AA,PHI, AP,PHIP,
     1      WORK(I,1),WORK(I,2), IB
        AMPL(I,INDEX) = AP
        PHSE(I,INDEX) = PHIP
C
C       5-Apr-88: Amplitude and phase for reverberation use
          IF (G2.LE.TOLGAM**2)  THEN
            AWKB = ABS (WORK(I,1))
            IF (WORK(I,1).GE.0.)  PWKB = 90.
            IF (WORK(I,1).LT.0.)  PWKB = 270.
            IF (EIGF) WRITE (LUO,551)  AWKB, PWKB
          ENDIF
 
  500 CONTINUE
  550 FORMAT (1X,I5,5G15.7,2G15.7,I3)
  551 FORMAT (51X,2G15.7)
      RETURN
      END
