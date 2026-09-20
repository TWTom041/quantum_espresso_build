# QE build

## How to use

```
git clone https://github.com/TWTom041/quantum_espresso_build
cd quantum_espresso_build
./install.sh
```

Edit the options at the top of `install.sh` first. The script builds Quantum
ESPRESSO 7.5 with CMake and installs into `qe-install` in the current directory.
It requires Git, Make, CMake 3.20 or newer, C/Fortran compilers, BLAS/LAPACK,
and an MPI installation on your environment's search paths (or set `MPI=OFF`).
Optional library installation prefixes can be set with `LIBRARY_PATHS`.

On this cluster, load the system Intel compiler, MPI, and MKL environment:

```bash
module load intel/2023_2
CC=mpiicc FC=mpiifort ./install.sh
```

Load the same module when running the installed executables. Set
`OMP_NUM_THREADS` to the threads allocated per MPI rank (start with `1`).
Use a clean `build-7.5` directory when changing compilers or libraries.
