

      program main

      implicit none
      integer, parameter :: dp=8
      integer, parameter :: n=4608
      real(dp),parameter :: lx=134.325d0
      real(dp),parameter :: dx=lx/dble(n)
      real(dp) w(2*n+15)
      real(dp) x(n),r(n),y(n)
      real(dp), parameter :: pi=dacos(-1d0)

      integer i,l

      do i = 1,n
         !x(i)=dsin(2d0*pi*dble(i)/dble(n))
         x(i)=dcos(2d0*pi*dble(i-1)/dble(n))
      enddo
      y(:)=x(:)
      write(*,*)
      !write(*,*) x(1:5)
      write(*,*)
      CALL DFFTI (n,w)
      CALL DFFTF (n,x,w)
      !write(*,*) x(1:5)
      write(*,*)
      l=(n+1)/2
      !do i = 2,l
      write(*,*) 0,x(1)*dx
      do i = 2,5
         write(*,*) i-1,x(2*i-2)*dx,x(2*i-1)*dx
      enddo
      x(:)=x(:)*dx
      CALL DFFTB (n,x,w)
      x(:)=x(:)/lx
      write(*,*)
      do i = 2,5
         write(*,*) y(i),x(i)
      enddo


      endprogram main
  
