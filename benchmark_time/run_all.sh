#!/bin/bash

cd aa/
ls *.xml | xargs -n1 -P 1 bash -c './run.sh $0'

mkdir -p timings/
cd timings/
ls ../*.nsys-rep | xargs -n1 -P 1 bash -c './get_timings.sh $0'

cd ../../
cd codon/
ls *.xml | xargs -n1 -P 1 bash -c './run.sh $0'

mkdir timings
cd timings/
ls ../*.nsys-rep | xargs -n1 -P 1 bash -c './get_timings.sh $0'

