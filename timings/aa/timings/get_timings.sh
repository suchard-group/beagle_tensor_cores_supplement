#!/bin/bash

nsysrep=$1
n=$(basename $nsysrep)

nsys stats -r cuda_gpu_kern_sum --force-export=true --format csv -o ${n/.nsys-rep/} $nsysrep
