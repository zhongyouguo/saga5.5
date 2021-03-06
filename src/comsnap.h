c     include 'snap/common.f'
      integer   maxdep,maxrange,maxprof
      parameter(maxdep=mlay,maxrange=mx,maxprof=2)
      real hw,pfact(mfreq)
      common  /hw/hw,pfact
      real          R0, R1, R2
      COMMON /DENS/ R0, R1, R2
      real BETA(-1:3), SCATT(2), C2S, C2
      COMMON /AB/ BETA, SCATT, C2S, C2
      DOUBLE PRECISION C0(maxDEP), Z0(maxDEP),
     1     C1(maxDEP), Z1(maxDEP)
 
c
c---- This is for importing observed ssp
c     
      integer nobsssp, nobspts
      double precision xobsssp(maxprof,maxDEP)
      common /obsssp/nobsssp, nobspts, xobsssp
c
      real RNG(maxRANGE),
     1     SRD(MSRD)
      common /rec_sou/rng,srd
      double precision freqy
      common /matprop/c0,z0,c1,z1,freqy
      DOUBLE PRECISION TWOPI, PI, OMEGA
      DOUBLE PRECISION cminsnap, H0, H1
      COMMON /GSNAP/ H0, H1, TWOPI, PI, OMEGA
      integer ND0, ND1
      COMMON /NA/ND0, ND1, CMINsnap
      integer np,ndepth,maxnomode
      common /divparm/np,ndepth,maxnomode
      real FLDRD,PULRD
      COMMON/CFIELD/FLDRD(3),PULRD(3)

c     AARON
      logical tilt, offset, timeoffset,
     1     msource, mbeam, msourcesp, two_way, multistatic
      real dr_ind(256), time_ind(256), dtilt, multigeo(4)
c     AARON     
C  the next common block tiltparm is also in snap/field.f
      common /tiltparm/tilt,offset,timeoffset,msource,mbeam,
     1     msourcesp,
     2     two_way,multistatic,dtilt,multigeo,dr_ind,time_ind

      complex sourcesp(mdep,mfreq)
      common /sourcesp/sourcesp

      integer xplane, irflagg
      logical out_plane
      real arrayshape(10)
      common /arrayparm/out_plane,arrayshape,xplane,irflagg

      real xhor(Mdep), yhor(Mdep), zhor(Mdep)
      common /hparmx/xhor
      common /hparmy/yhor
      common /hparmz/zhor


c     logics for determine if modes should be calculated.
      integer i_call_porter,i_geom,ibathy,iscale
      common /log_mode/i_call_porter,i_geom,ibathy,iscale

      integer ierror
      common /tlerr/ierror

      integer nfftbb,iifft, nf1,nf2
      real fsbb,fmindum,fmaxdum,df_temp
      common /trfcomm/fsbb,fmindum,fmaxdum,nfftbb,df_temp,
     1     iifft,nf1,nf2 



      logical igrain
      integer ibeta
      dOUBLE PRECISION phim, max_dep 
      double precision c1s(maxDEP), alp1p(maxDEP),
     1     alp1s(maxDEP), r1_phi(maxDEP) 
      common /phicomm/phim,max_dep,igrain,ibeta
