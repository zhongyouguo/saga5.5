C
      SUBROUTINE LINEAR (NWL,ZP,CP,NBL,HBOT,CBOT,H,OMEGA,NL,XI,VI)
C
C  INTERPOLATION OF SOUND SPEED PROFILE SO THAT 1./C**2 IS LINEAR IN
C   THE WATER
C
C  WRITTEN BY  DALE D ELLIS  DREA/AM  RM/250  EXT/155   DARTMOUTH N.S.
C  DATE WRITTEN   17-NOV-78
C  LAST MODIFICATION  20-NOV-78
C
C  OUTPUT IS SIMILAR TO THE BARTBERGER-ACKLER NORMAL MODE PROGRAM
C   DEPTHS ARE NORMALIZED SO THAT THE WATER DEPTH IS 1.
C   OUTPUT QUANTITY VI IS  (H*OMEGA/C(Z))**2
C
C  INPUT ARGUMENTS
C  I  NWL       NUMBER OF POINTS IN INPUT WATER COLUMN PROFILE
C  S  ZP(NWL)   DEPTHS OF INPUT PROFILE
C  S  CP(NWL)   SOUND SPEEDS AT DEPTHS ZP
C  I  NBL       NUMBER OF BOTTOM LAYERS
C  S  HBOT(NBL) THICKNESS OF EACH BOTTOM LAYER
C  S  CBOT(NBL) SOUND SPEED IN BOTTOM LAYERS
C  S  H         WATER DEPTH
C  D  OMEGA     ANGULAR FREQUENCY
C  I  NL        NUMBER OF LAYERS IN INTERPOLATED PROFILE
C
C  OUTPUT ARGUMENTS
C  D  XI(NL)    INTERPOLATED DEPTHS  [ XI(NPT+1)=1.D0 AT DEPTH H]
C  D  VI(NL)    OUTPUT FUNCTION  (H*OMEGA/(0.5*(C(I)+C(I+1)))**2
C
C  OTHER VARIABLES
C  I  NPT       NUMBER OF LAYERS IN WATER COLUMN
C  D  CII       INTERPOLATED SOUND SPEED AT DEPTH ZII
C  D  CI2       AVERAGE SOUND SPEED IN LAYER I AND I+1
C
C
      INTEGER I,NBL,NL,NPT,NPT1,NWL,M
      REAL CBOT,CP,EPS,H,HB,HBOT,ZP
      DIMENSION ZP(NWL),CP(NWL),HBOT(NBL),CBOT(NBL)
      DOUBLE PRECISION XI(NL),VI(NL)
      DOUBLE PRECISION OMEGA,HW,DZ,DX,ZII,SLOPE,ZPM,VM
      DATA EPS /1.E-4/
C
      NPT=NL-NBL
      NPT1=NPT+1
      HW=DBLE(H)*OMEGA
      DZ=DBLE(H)/NPT
      DX=1.0D0/NPT
C
      M=1
C
      DO 100 I=1,NPT1
      ZII=(I-1)*DZ
      IF ( ZII.LE.ZP(1) )  GO TO 50
      IF ( ZII.GE.ZP(NWL) ) GO TO 60
      IF ( ABS(ZII-ZP(M)).LT.EPS)  GO TO 70
   40 IF ( ZII.LE.ZP(M) )  GO TO 80
C
C         CALCULATE SLOPE IN NEXT DEPTH INTERVAL
      ZPM=DBLE(ZP(M))
      VM = ( HW/DBLE(CP(M)) )**2
      M=M+1
      SLOPE= ( (HW/DBLE(CP(M)))**2 -VM ) / (DBLE(ZP(M))-ZPM)
      GO TO 40
C
C          DEPTH LESS THAN ZP(1).   CONSTANT
   50 VI(I)=(HW/DBLE(CP(1)))**2
      GO TO 100
C
C          DEPTH GREATER THAN ZP(NWL).  CONSTANT
   60 VI(I)=(HW/DBLE(CP(NWL)))**2
      GO TO 100
C
C          DEPTH NEAR INPUT POINT.  EQUAL TO THAT POINT
   70 VI(I)=(HW/DBLE(CP(M)))**2
      GO TO 100
C
C          INTERPOLATION. 1./C**2  LINEAR
   80 VI(I)=VM + SLOPE*(ZII-ZPM)
C
  100 CONTINUE
C
C
      DO 105 I=1,NPT
      XI(I)=(I-1)*DX
      VI(I)=4.D0 / (1.0D0/DSQRT(VI(I)) + 1.0D0/DSQRT(VI(I+1)) )**2
  105 CONTINUE
C
C
      HB=DBLE(H)
      DO 110 I=1,NBL
      XI(NPT+I)= HB/DBLE(H)
      VI(NPT+I)=  (HW/DBLE(CBOT(I)))**2
      HB=HB+DBLE(HBOT(I))
  110 CONTINUE
C
C
      RETURN
      END
