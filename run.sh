#!/bin/bash

N1=10000000
N2=500000000
STEP=20000000

for i in {1..8};
do
	for j in `seq $N1 $STEP $N2`;
	do
		(time mpirun -np $i ./freduce $j) > "output/log_fred_${i}_${j}.txt" 2>&1
		(time mpirun -np $i ./creduce $j) > "output/log_cred_${i}_${j}.txt" 2>&1
                (time mpirun -np $i ./fsend $j) > "output/log_fsend_${i}_${j}.txt" 2>&1      
                (time mpirun -np $i ./csend $j) > "output/log_csend_${i}_${j}.txt" 2>&1
	done
done
