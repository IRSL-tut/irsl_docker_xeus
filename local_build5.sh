#!/bin/bash

set -e

OUTPUT_DIR=/opt/xeus5

##
export PATH=$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export LD_LIBRARY_PATH=$HOME/.local/lib

#### xeus
## json
(mkdir json && wget https://github.com/nlohmann/json/archive/refs/tags/v3.11.3.tar.gz --quiet -O - | tar zxf - --strip-components 1 -C json)
(cd json; cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${OUTPUT_DIR} -DJSON_BuildTests=OFF . ; make install -j$(nproc) )
## xtl
(mkdir xtl && wget https://github.com/xtensor-stack/xtl/archive/refs/tags/0.7.7.tar.gz --quiet -O - | tar zxf - --strip-components 1 -C xtl)
(cd xtl; cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${OUTPUT_DIR} . ; make install -j$(nproc) )
## xeus / 5.1.1
(mkdir xeus && wget https://github.com/jupyter-xeus/xeus/archive/refs/tags/5.2.3.tar.gz --quiet -O - | tar zxf - --strip-components 1 -C xeus)
(cd xeus; cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${OUTPUT_DIR} . ; make install -j$(nproc) )

### xeus-zmp
## libzmq
#RUN (mkdir libzmq && wget https://github.com/zeromq/libzmq/archive/refs/tags/v4.3.4.tar.gz --quiet -O - | tar zxf - --strip-components 1 -C libzmq)
#RUN (cd libzmq; mkdir build; cd build; cmake -DWITH_PERF_TOOL=OFF -DZMQ_BUILD_TESTS=OFF -DENABLE_CPACK=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${OUTPUT_DIR} ..; make install -j$(nproc) )
## cppzmq
(mkdir cppzmq && wget https://github.com/zeromq/cppzmq/archive/refs/tags/v4.10.0.tar.gz --quiet -O - | tar zxf - --strip-components 1 -C cppzmq)
(cd cppzmq; cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${OUTPUT_DIR} -DCPPZMQ_BUILD_TESTS=OFF . ; make install -j$(nproc) )
## xeus-zmq
(mkdir -p xeus-zmq/build && wget https://github.com/jupyter-xeus/xeus-zmq/archive/refs/tags/3.1.0.tar.gz --quiet -O - | tar zxf - --strip-components 1 -C xeus-zmq)
(cd xeus-zmq/build; cmake -DCMAKE_PREFIX_PATH=${OUTPUT_DIR} -DCMAKE_INSTALL_PREFIX=${OUTPUT_DIR} -DCMAKE_BUILD_TYPE=Release ..; make install -j$(nproc) )

### xeus-python
## cmake
(mkdir -p /tmp/cmake; wget https://github.com/Kitware/CMake/releases/download/v3.30.3/cmake-3.30.3-linux-x86_64.tar.gz --quiet -O - | tar zxf - --strip-components 1 -C /tmp/cmake )
## pybind11
#(mkdir -p pybind11/build && wget https://github.com/pybind/pybind11/archive/refs/tags/v2.12.0.tar.gz --quiet -O - | tar zxf - --strip-components 1 -C pybind11 )## cnoid_compatible?
(mkdir -p pybind11/build && wget https://github.com/pybind/pybind11/archive/refs/tags/v2.13.6.tar.gz --quiet -O - | tar zxf - --strip-components 1 -C pybind11 )
(cd pybind11/build; /tmp/cmake/bin/cmake .. -DCMAKE_PREFIX_PATH=${OUTPUT_DIR} -DCMAKE_INSTALL_PREFIX=${OUTPUT_DIR} -DPYBIND11_TEST=OFF; make install)
## pybind11_json
(mkdir -p pybind11_json/build && wget https://github.com/pybind/pybind11_json/archive/refs/tags/0.2.15.tar.gz --quiet -O - | tar zxf - --strip-components 1 -C pybind11_json )
(cd pybind11_json/build; /tmp/cmake/bin/cmake .. -DCMAKE_PREFIX_PATH=${OUTPUT_DIR} -DCMAKE_INSTALL_PREFIX=${OUTPUT_DIR}; make install)
## xeus-python
(mkdir -p xeus-python/build && wget https://github.com/jupyter-xeus/xeus-python/archive/refs/tags/0.17.4.tar.gz --quiet -O - | tar zxf - --strip-components 1 -C xeus-python)
(cd xeus-python/build; /tmp/cmake/bin/cmake .. -DCMAKE_PREFIX_PATH=${OUTPUT_DIR} -DCMAKE_INSTALL_PREFIX=${OUTPUT_DIR} -DCMAKE_INSTALL_LIBDIR=lib -DPYTHON_EXECUTABLE=`which python3`; make install -j$(nproc) )

