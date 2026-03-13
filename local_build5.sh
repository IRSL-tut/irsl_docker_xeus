#!/bin/bash

set -e

OUTPUT_DIR=
RUN_APT_GET=0

usage() {
    cat <<'EOF'
Usage: local_build5.sh [--apt-get] [--output-dir OUTPUT_DIR]

Options:
  --apt-get                Install system dependencies via apt.
  --output-dir OUTPUT_DIR  Install prefix for built artifacts.
  -h, --help               Show this help.
EOF
}

while [ "$#" -gt 0 ]; do
    case "$1" in
        --apt-get)
            RUN_APT_GET=1
            shift
            ;;
        --output-dir)
            if [ -z "$2" ] || [ "${2#-}" != "$2" ]; then
                echo "error: --output-dir requires a value" >&2
                usage
                exit 2
            fi
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "error: unknown argument: $1" >&2
            usage
            exit 2
            ;;
    esac
done

if [ -z "${OUTPUT_DIR}" ]; then
    OUTPUT_DIR=/opt/xeus5
fi

if [ "${RUN_APT_GET}" -eq 1 ]; then
    sudo apt update -q -qq
    sudo apt install -q -qq -y wget make g++ git openssl pkg-config libzmq5-dev uuid-dev libssl-dev libsodium-dev python3-dev
fi

## use simple path
export PATH=$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export LD_LIBRARY_PATH=$HOME/.local/lib

## cmake => /tmp/cmake/bin/cmake
(mkdir -p /tmp/cmake; wget https://github.com/Kitware/CMake/releases/download/v3.30.3/cmake-3.30.3-linux-x86_64.tar.gz --quiet -O - | tar zxf - --strip-components 1 -C /tmp/cmake )

##
## build script main
##

### old
#>VER_JSON=v3.11.3
#>VER_XEUS=5.2.3
#>VER_CPPZMQ=v4.10.0
#>VER_XEUS_ZMQ=3.1.0
#>VER_PYBIND11=v2.13.6
#>VER_PYBIND_JSON=0.2.15
#>VER_XEUS_PYTHON=0.17.4

## stable xeus 5.2.x, xeus-zmq 3.1.x, xeus-python 0.17.x
VER_JSON=v3.12.0
VER_XEUS=5.2.8
VER_CPPZMQ=v4.11.0
VER_XEUS_ZMQ=3.1.2
VER_PYBIND11=v2.13.6
VER_PYBIND_JSON=0.2.15
VER_XEUS_PYTHON=0.17.8

#>## tip xeus 6.0.x, xeus-zmq 4.0.x, xeus-python 0.18.x
#>VER_JSON=v3.12.0
#>VER_XEUS=6.0.2
#>VER_CPPZMQ=v4.11.0
#>VER_XEUS_ZMQ=4.0.0
#>VER_PYBIND11=v2.13.6
#>VER_PYBIND_JSON=0.2.15
#>VER_XEUS_PYTHON=0.18.1

#### xeus
## json
(mkdir json && wget https://github.com/nlohmann/json/archive/refs/tags/${VER_JSON}.tar.gz --quiet -O - | tar zxf - --strip-components 1 -C json)
(cd json; cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${OUTPUT_DIR} -DJSON_BuildTests=OFF . ; make install -j$(nproc) )
### xtl
#(mkdir xtl && wget https://github.com/xtensor-stack/xtl/archive/refs/tags/0.7.7.tar.gz --quiet -O - | tar zxf - --strip-components 1 -C xtl)
#(cd xtl; cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${OUTPUT_DIR} . ; make install -j$(nproc) )
## xeus
(mkdir xeus && wget https://github.com/jupyter-xeus/xeus/archive/refs/tags/${VER_XEUS}.tar.gz --quiet -O - | tar zxf - --strip-components 1 -C xeus)
(cd xeus; cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${OUTPUT_DIR} . ; make install -j$(nproc) )

### xeus-zmp
## libzmq
#(mkdir libzmq && wget https://github.com/zeromq/libzmq/archive/refs/tags/v4.3.4.tar.gz --quiet -O - | tar zxf - --strip-components 1 -C libzmq)
#(cd libzmq; mkdir build; cd build; cmake -DWITH_PERF_TOOL=OFF -DZMQ_BUILD_TESTS=OFF -DENABLE_CPACK=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${OUTPUT_DIR} ..; make install -j$(nproc) )
## cppzmq
(mkdir cppzmq && wget https://github.com/zeromq/cppzmq/archive/refs/tags/${VER_CPPZMQ}.tar.gz --quiet -O - | tar zxf - --strip-components 1 -C cppzmq)
(cd cppzmq; cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${OUTPUT_DIR} -DCPPZMQ_BUILD_TESTS=OFF . ; make install -j$(nproc) )
## xeus-zmq
(mkdir -p xeus-zmq/build && wget https://github.com/jupyter-xeus/xeus-zmq/archive/refs/tags/${VER_XEUS_ZMQ}.tar.gz --quiet -O - | tar zxf - --strip-components 1 -C xeus-zmq)
(cd xeus-zmq/build; cmake -DCMAKE_PREFIX_PATH=${OUTPUT_DIR} -DCMAKE_INSTALL_PREFIX=${OUTPUT_DIR} -DCMAKE_BUILD_TYPE=Release ..; make install -j$(nproc) )

### xeus-python
## pybind11
(mkdir -p pybind11/build && wget https://github.com/pybind/pybind11/archive/refs/tags/${VER_PYBIND11}.tar.gz --quiet -O - | tar zxf - --strip-components 1 -C pybind11 )
(cd pybind11/build; /tmp/cmake/bin/cmake .. -DCMAKE_PREFIX_PATH=${OUTPUT_DIR} -DCMAKE_INSTALL_PREFIX=${OUTPUT_DIR} -DPYBIND11_TEST=OFF; make install)
## pybind11_json
(mkdir -p pybind11_json/build && wget https://github.com/pybind/pybind11_json/archive/refs/tags/${VER_PYBIND_JSON}.tar.gz --quiet -O - | tar zxf - --strip-components 1 -C pybind11_json )
(cd pybind11_json/build; /tmp/cmake/bin/cmake .. -DCMAKE_PREFIX_PATH=${OUTPUT_DIR} -DCMAKE_INSTALL_PREFIX=${OUTPUT_DIR}; make install)
## xeus-python
(mkdir -p xeus-python/build && wget https://github.com/jupyter-xeus/xeus-python/archive/refs/tags/${VER_XEUS_PYTHON}.tar.gz --quiet -O - | tar zxf - --strip-components 1 -C xeus-python)
(cd xeus-python/build; /tmp/cmake/bin/cmake .. -DCMAKE_PREFIX_PATH=${OUTPUT_DIR} -DCMAKE_INSTALL_PREFIX=${OUTPUT_DIR} -DCMAKE_INSTALL_LIBDIR=lib -DPYTHON_EXECUTABLE=`which python3`; make install -j$(nproc) )
