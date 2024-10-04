#!/bin/bash

xml=$1
n=$(basename $xml)
n=${n/.xml/_profile}

gpu=1
nrep=10

# Set path to BEAGLE lib
export LD_LIBRARY_PATH=$HOME/beagle-lib/build_benchmark/lib

# Set path to BEAST jar
BEAST_JAR=$HOME/Documents/beast-mcmc/build/dist/beast.jar

cmd="java -Xms2G -Xmx4G -Djava.library.path="${LD_LIBRARY_PATH}" -jar ${BEAST_JAR} -seed 112358 -beagle_GPU -beagle_order ${gpu} -beagle_instances 1 -overwrite"
cmd_tensor_cores="java -Xms2G -Xmx4G -Djava.library.path="${LD_LIBRARY_PATH}" -jar ${BEAST_JAR} -seed 112358 -beagle_GPU -beagle_order ${gpu} -beagle_tensor_core -beagle_instances 1 -overwrite"

# General timing
for rep in $(seq 1 $nrep); do
        $cmd_tensor_cores $xml > ${xml/.xml/_gpu_tensor_cores}_${rep}.txt 2>&1
        sleep 2
        $cmd $xml > ${xml/.xml/_gpu}_${rep}.txt 2>&1
        sleep 2
done

#Kernel profiling
for rep in $(seq 1 $nrep); do
        nsys profile -o ${n}_tensor_cores_${rep} $cmd_tensor_cores $xml > ${xml/.xml/_gpu_nsys_tensor_cores}_${rep}.txt 2>&1
        sleep 2
        nsys profile -o ${n}_${rep} $cmd $xml > ${xml/.xml/_gpu_nsys}_${rep}.txt 2>&1
        sleep 2
done

#Kernel timings
ncu -c 10 --set full -o ${n}_tensor_cores_gradient -k kernelPartialsPartialsEdgeFirstDerivatives $cmd_tensor_cores $xml > ${xml/.xml/}_gradient_gpu_ncu_tensor_cores.txt 2>&1
ncu -c 10 --set full -o ${n}_tensor_cores_preorder -k kernelPartialsPartialsGrowing $cmd_tensor_cores $xml > ${xml/.xml/}_preorder_gpu_ncu_tensor_cores.txt 2>&1
ncu -c 10 --set full -o ${n}_tensor_cores_postorder -k kernelPartialsPartialsNoScale $cmd_tensor_cores $xml > ${xml/.xml/}_postorder_gpu_ncu_tensor_cores.txt 2>&1

ncu -c 10 --set full -o ${n}_gradient -k kernelPartialsPartialsEdgeFirstDerivatives $cmd $xml > ${xml/.xml/}_gradient_gpu_ncu.txt 2>&1
ncu -c 10 --set full -o ${n}_preorder -k kernelPartialsPartialsGrowing $cmd $xml > ${xml/.xml/}_preorder_gpu_ncu.txt 2>&1
ncu -c 10 --set full -o ${n}_postorder -k kernelPartialsPartialsNoScale $cmd $xml > ${xml/.xml/}_postorder_gpu_ncu.txt 2>&1
