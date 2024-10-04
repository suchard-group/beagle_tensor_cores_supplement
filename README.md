# Harnessing tensor cores for greater computational efficiency and lower energy consumption in phylogenetic inference

Please note that you will need `nsys` and `ncu` installed on the system to time and profile kernels, respectively. Both these tools are available as part of the [CUDA toolkit](https://developer.nvidia.com/cuda-toolkit) or can be installed from [nsys](https://developer.nvidia.com/nsight-systems) and [ncu](https://developer.nvidia.com/nsight-compute).

This repository was used to benchmark kernels with the following versions,

* CUDA release 12.4, V12.4.131
* NVIDIA Nsight Systems version 2024.4.2.133-244234382004v0
* NVIDIA (R) Nsight Compute Command Line Profiler Version 2024.2.0.0 (build 34181891) (public-release)

Different versions of CUDA or the profiling tools would reqire further edits to the commands in [./benchmark_time/aa/run.sh](./timings/aa/run.sh), [./benchmark_time/codon/run.sh](./timings/codon/run.sh), and [./benchmark_energy/run.sh](./energy/run.sh). 

Please see instructions to compile BEAGLE and install BEAST for reproducing the benchmarks.

## Benchmark kernel timings

### Installation 

BEAGLE
```
git clone -b tensor_cores https://github.com/beagle-dev/beagle-lib.git
cd beagle-lib/
mkdir build
cd build/
cmake -DBEAGLE_BENCHMARK_ENERGY=OFF -DBUILD_OPENCL=OFF -DBEAGLE_TENSOR_CORES=ON ..
```

BEAST
```
git clone -b tensor_cores https://github.com/beast-dev/beast-mcmc.git
cd beast-mcmc/
ant
```

In [./benchmark_time/aa/run.sh](./benchmark_time/aa/run.sh) and [./benchmark_time/codon/run.sh](./benchmark_time/codon/run.sh) setup `BEAST_JAR` and `LD_LIBRARY_PATH` variables to point to the BEAST JAR file and the BEAGLE library, respectively.

Run the following commands to time all the XMLs with increasing number of patterns, across 10 replicates for both amino acid and codon models.

```
cd benchmark_time/
./run_all.sh
```

## Benchmark energy consumption

### Installation

BEAGLE

Please note that the cmake flag `-DBEAGLE_BENCHMARK_ENERGY=ON` is different from the installation above. Do not turn this flag ON to benchmark timings since measuring energy requires significant overhead.

```
git clone -b tensor_cores https://github.com/beagle-dev/beagle-lib.git
cd beagle-lib/
mkdir build
cd build/
cmake -DBEAGLE_BENCHMARK_ENERGY=ON -DBUILD_OPENCL=OFF -DBEAGLE_TENSOR_CORES=ON ..
```

BEAST
```
git clone -b tensor_cores https://github.com/beast-dev/beast-mcmc.git
cd beast-mcmc/
ant
```

In [./benchmark_energy/run.sh](./benchmark_energy/run.sh) set `BEAST_JAR` and `LD_LIBRARY_PATH` variables to point to the BEAST JAR file and the BEAGLE library, respectively.

Run the following commands to measure energy consumption across 10 replicates with a random time delay between consecutive iterations for both amino acid and codon models,

```
cd benchmark_energy/
./run.sh carnivores_aa_hmc_patterns_4096.xml
./run.sh carnivores_codon_hmc_patterns_4096.xml
```
