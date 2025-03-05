#!/bin/bash

set -e

OUTPUT_DIR=/tmp/xeus5

#### xeus
## json
(mkdir json && wget https://github.com/nlohmann/json/archive/refs/tags/v3.11.3.tar.gz --quiet -O - | tar zxf - --strip-components 1 -C json)
(cd json; cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${OUTPUT_DIR} -DJSON_BuildTests=OFF . ; make install -j$(nproc) )
## xtl
(mkdir xtl && wget https://github.com/xtensor-stack/xtl/archive/refs/tags/0.7.7.tar.gz --quiet -O - | tar zxf - --strip-components 1 -C xtl)
(cd xtl; cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${OUTPUT_DIR} . ; make install -j$(nproc) )
## xeus / 5.1.1
(mkdir xeus && wget https://github.com/jupyter-xeus/xeus/archive/refs/tags/5.1.1.tar.gz --quiet -O - | tar zxf - --strip-components 1 -C xeus)
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
