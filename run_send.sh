module load icc/19.1
module load openmpi/4.0.3
mpic++ send.cc -o csend
mpif77 -o fsend send.f
mpirun -np 4 csend 500000000
mpirun -np 4 fsend 500000000
