rem
rem command-prompt
rem

set OUTPUT_DIR=c:\opt\xeus

set CMAKE_PREFIX_PATH=%OUTPUT_DIR%

rem # json
cd json
cmake -B build -G "Visual Studio 16 2019" -A x64 -DJSON_BuildTests=OFF
cmake --build build --config Release -- -m
cmake --install build --config Release --prefix %OUTPUT_DIR%
cd ..

rem # xtl
cd xtl
cmake -B build -G "Visual Studio 16 2019" -A x64
cmake --build build --config Release -- -m
cmake --install build --config Release --prefix %OUTPUT_DIR%
cd ..

rem # xeus
cd xeus
cmake -B build -G "Visual Studio 16 2019" -A x64 -DCMAKE_PREFIX_PATH=%OUTPUT_DIR%
cmake --build build --config Release -- -m
cmake --install build --config Release --prefix %OUTPUT_DIR%
cd ..

rem # libzmq
cd libzmq
cmake -B build -G "Visual Studio 16 2019" -A x64 -DWITH_PERF_TOOL=OFF -DZMQ_BUILD_TESTS=OFF -DENABLE_CPACK=OFF -DCMAKE_PREFIX_PATH=%OUTPUT_DIR%
cmake --build build --config Release -- -m
cmake --install build --config Release --prefix %OUTPUT_DIR%
cd ..

rem # cppzmq
cd cppzmq
cmake -B build -G "Visual Studio 16 2019" -A x64 -DCPPZMQ_BUILD_TESTS=OFF -DCMAKE_PREFIX_PATH=%OUTPUT_DIR%
cmake --build build --config Release -- -m
cmake --install build --config Release --prefix %OUTPUT_DIR%
cd ..

rem # xeus_zmq
cd xeus_zmq
cmake -B build -G "Visual Studio 16 2019" -A x64 -DCMAKE_PREFIX_PATH=%OUTPUT_DIR%
cmake --build build --config Release -- -m
cmake --install build --config Release --prefix %OUTPUT_DIR%
cd ..

rem # pybind11
cd pybind11
cmake -B build -G "Visual Studio 16 2019" -A x64 -DPYBIND11_TEST=OFF
cmake --build build --config Release -- -m
cmake --install build --config Release --prefix %OUTPUT_DIR%
cd ..

rem # pybind11_json
cd py_json
cmake -B build -G "Visual Studio 16 2019" -A x64
cmake --build build --config Release -- -m
cmake --install build --config Release --prefix %OUTPUT_DIR%
cd ..

rem # xeus-python
cd xeus_py
cmake -B build -G "Visual Studio 16 2019" -A x64 -DCMAKE_INSTALL_LIBDIR=lib
cmake --build build --config Release -- -m
cmake --install build --config Release --prefix %OUTPUT_DIR%
cd ..
