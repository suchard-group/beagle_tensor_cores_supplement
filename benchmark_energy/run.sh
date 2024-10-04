#!/bin/bash

xml=$1
n=$(basename $xml)
n=${n/.xml/_profile}

nrep=100
gpu=1

export LD_LIBRARY_PATH=$HOME/beagle-lib/build_energy/lib

BEAST_JAR=$HOME/Documents/beast-mcmc/build/dist/beast.jar


#Kernel profiling
for rep in $(seq 1 $nrep); do
	java -Xms2G -Xmx4G -Djava.library.path="$LD_LIBRARY_PATH" -jar $BEAST_JAR -seed 112358 -beagle_GPU -beagle_order $gpu -beagle_instances 1 -overwrite -beagle_tensor_core $xml > ${xml/.xml/_gpu_tensor_cores}_rep_${rep}.txt 2>&1
	sleep $((RANDOM % 9 + 2))
	java -Xms2G -Xmx4G -Djava.library.path="$LD_LIBRARY_PATH" -jar $BEAST_JAR -seed 112358 -beagle_GPU -beagle_order $gpu -beagle_instances 1 -overwrite $xml > ${xml/.xml/_gpu}_rep_${rep}.txt 2>&1
	sleep $((RANDOM % 9 + 2))
done

