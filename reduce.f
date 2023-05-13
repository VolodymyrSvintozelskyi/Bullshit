      Program Example3d
       Implicit None
       Include 'mpif.h'
       Integer Size, Rank, Ierr, I, N, argc
       Integer*8 nPart
       Double Precision Sum, GSum, A, B, time1, time2, Al, Bl, X, F,
     $ timeT, TRUE, Yl, Yr, PI
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
       N = nPart/Size

       Sum = 0
       Yl = F(Al)
       Do I = 1,N
       X = Al+(Bl-Al)*I/N
       Yr = F(X)
       Sum = Sum + Yr + Yl
       Yl = Yr
       End Do

      
       Call MPI_REDUCE(Sum, GSum, 1, MPI_DOUBLE_PRECISION,
     $ MPI_SUM, 0, MPI_COMM_WORLD, Ierr)
       

       If (Rank.eq.0) Then
       time2 = MPI_WTime() 
       GSum = GSum/(N*Size)/2*(B-A)
       Write (6,*) 'Result= ',GSum,' Error= ',TRUE-GSum
       Write (6,*), ' Time = ', time2 - time1
       End If
       Call MPI_FINALIZE(Ierr)
       Stop
       End
