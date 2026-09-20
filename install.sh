#!/usr/bin/env bash
set -euo pipefail

# Options: edit these before running ./install.sh.
VERSION=7.5
PREFIX="${PWD}/qe-install"    # Installation directory (absolute path).
JOBS=8                      # Parallel compilation jobs; adjust for available RAM.
MPI=ON
OPENMP=ON
SCALAPACK=OFF                # ON requires a ScaLAPACK library matching your MPI.
LIBRARY_PATHS=""             # Optional library prefixes, separated by ; (e.g. /opt/math).

# Requires git, make, CMake >= 3.20, C/Fortran compilers, BLAS and LAPACK.
# With MPI=ON, load a matching MPI installation into your environment first.
# CMake selects compilers from PATH; CC and FC can override them.
# FFT libraries are auto-detected, with QE's internal FFT as a fallback.
# Internet access is needed for QE and its bundled dependencies.
# After changing compilers or libraries, use a clean build directory.
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="${ROOT}/qe-${VERSION}"
BUILD="${ROOT}/build-${VERSION}"

for tool in git cmake make; do
    command -v "$tool" >/dev/null || { echo "Missing required tool: $tool" >&2; exit 1; }
done
[[ "$PREFIX" = /* ]] || { echo "PREFIX must be an absolute path." >&2; exit 1; }

if [[ ! -d "$SOURCE" ]]; then
    git clone --depth 1 --branch "qe-${VERSION}" --recurse-submodules \
        https://github.com/QEF/q-e.git "$SOURCE"
fi
git -C "$SOURCE" submodule update --init --recursive

cmake -S "$SOURCE" -B "$BUILD" -G "Unix Makefiles" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DCMAKE_PREFIX_PATH="$LIBRARY_PATHS" \
    -DQE_ENABLE_MPI="$MPI" \
    -DQE_ENABLE_OPENMP="$OPENMP" \
    -DQE_ENABLE_SCALAPACK="$SCALAPACK" \
    -DQE_ENABLE_TEST=OFF
cmake --build "$BUILD" --parallel "$JOBS"
cmake --install "$BUILD"

printf '\nInstalled Quantum ESPRESSO in %s\n' "$PREFIX"
printf 'Add %s/bin to PATH.\n' "$PREFIX"
printf 'Set OMP_NUM_THREADS to the CPU threads allocated per MPI rank (start with 1).\n'
