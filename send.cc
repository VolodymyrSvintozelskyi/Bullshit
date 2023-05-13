#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <cmath>

#define TRUEVAL -2*M_PI

const double A = 0;
const double B = 2*M_PI;

double func(double x) {return (1-8*x*x)*cos(4*x);}

int main(int argc, char** argv) {
  int size, rank;
  long long N = atoll(argv[1]);
  double Sum, GSum, time1, time2, timeI, Al, Bl, X, Yl, Yr, F, ISum, timeT;
  MPI_Status Status;

  MPI_Init(NULL, NULL);
  MPI_Comm_size(MPI_COMM_WORLD, &size);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  time1 = MPI_Wtime();

  N /= size;
  Al = A+(B-A)*rank/size;
  Bl = Al+(B-A)/size;

  Sum = 0;
  Yl = func(Al);
  for (long long i = 0; i < N; ++i){
    X = Al+(Bl-Al)*i/N;
    Yr = func(X);
    Sum = Sum + Yr + Yl;
    Yl = Yr;
  }

  if (rank == 0) {
 
    GSum = Sum;
    for (int i = 1; i < size; ++i){
      MPI_Recv(&ISum, 1, MPI_DOUBLE_PRECISION, i, 0, MPI_COMM_WORLD, &Status);
      
      GSum = GSum + ISum;
      //std::cout << timeT << std::endl;
      timeT = timeT + timeI;
    }

    time2 = MPI_Wtime();
    GSum = GSum/(N*size)/2*(B-A);
    std::cout << "Result= " << GSum << " Error= " << (TRUEVAL-GSum) << std::endl <<
    " Time= " << time2 - time1 << std::endl;
  } else {
    MPI_Send(&Sum, 1, MPI_DOUBLE_PRECISION, 0, 0, MPI_COMM_WORLD);
  }

  MPI_Finalize();
  return 0;
}

