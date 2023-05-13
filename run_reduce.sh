module load icc/19.1
module load openmpi/4.0.3
mpic++ reduce.cc -o creduce
mpif77 -o freduce reduce.f
mpirun -np 4 creduce 5000000
mpirun -np 4 freduce 5000000
