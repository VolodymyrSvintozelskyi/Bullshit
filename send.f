      Program Example3a
       Implicit None
       Include 'mpif.h'
       Integer Size, Rank, Ierr, I, N, Status(MPI_STATUS_SIZE), argc
       Integer*8 nPart
       Double Precision Sum, GSum, A, B, time1, time2, timeI,
     $ Al, Bl, X, Yl, Yr, F, ISum, TRUE, timeT, PI 
       Character argv*32
       Parameter (PI = 3.14159265358979323846)
       Parameter (A=0.0, B=2.0*PI)
       Parameter (TRUE=-2.0*PI)
       
       F(x)=(1-8*x*x)*cos(4*x)
       Call MPI_INIT(Ierr)
       Call MPI_COMM_SIZE(MPI_COMM_WORLD, Size, Ierr)
       Call MPI_COMM_RANK(MPI_COMM_WORLD, Rank, Ierr)
       
       argc = iargc()
       CALL getarg(1,argv)
       READ(argv,*) nPart
       time1 = MPI_WTime()
       Al = A+(B-A)*Rank/Size
       Bl = Al+(B-A)/Size
C        N = 1000000000/Size

       N = nPart/Size
       Sum = 0
       Yl = F(Al)
       Do I = 1,N
       X = Al+(Bl-Al)*I/N
       Yr = F(X)
       Sum = Sum + Yr + Yl
       Yl = Yr
       End Do


       If (Rank.eq.0) Then
       timeT = MPI_WTime() - time1
       GSum = Sum
       Do I=1,Size-1
       Call MPI_RECV(ISum, 1, MPI_DOUBLE_PRECISION,
     $ MPI_ANY_SOURCE, 0, MPI_COMM_WORLD, Status, Ierr)
       Call MPI_RECV(timeI, 1, MPI_DOUBLE_PRECISION,
     $ MPI_ANY_SOURCE, 0, MPI_COMM_WORLD, Status, Ierr)
       GSum = GSum + ISum
       timeT = timeT + timeI
       End Do
       time2 = MPI_WTime()
       GSum = GSum/(N*Size)/2*(B-A)
C        Write (6,*) 'Result= ',GSum,' Error= ',TRUE-GSum,
C      $' Time=',time2 - time1
       Write (6,*) 'Result= ',GSum,' Error= ',TRUE-GSum
       Write (6,*) ' Time = ', time2 - time1
       
       else

       Call MPI_SEND(Sum, 1, MPI_DOUBLE_PRECISION, 0,
     $ 0, MPI_COMM_WORLD, Ierr)
       Call MPI_SEND(1, MPI_DOUBLE_PRECISION, 0,
     $ 0, MPI_COMM_WORLD, Ierr)
       End If
       Call MPI_FINALIZE(Ierr)
       Stop
       End
