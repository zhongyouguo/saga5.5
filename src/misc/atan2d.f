      REAL FUNCTION ATAN2D(X,Y)

C     THIS FUNCTION RETURNS THE REGULAR ATAN2 IN DEGREES
 
      REAL X,Y

      ATAN2D=ATAN2(X,Y)*45.0/ATAN(1.0)
      RETURN
      END      