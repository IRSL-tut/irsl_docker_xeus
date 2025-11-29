#!/bin/bash
#
# In cygwin or git-bash
#
(mkdir json && cat json.tgz | tar zxf - --strip-components 1 -C json)
(mkdir  xtl && cat xtl.tgz  | tar zxf - --strip-components 1 -C  xtl)
(mkdir xeus && cat xeus.tgz | tar zxf - --strip-components 1 -C xeus)
(mkdir libzmq && cat libzmq.tgz | tar zxf - --strip-components 1 -C libzmq)
(mkdir cppzmq && cat cppzmq.tgz | tar zxf - --strip-components 1 -C cppzmq)
(mkdir xeus_zmq && cat xeus_zmq.tgz | tar zxf - --strip-components 1 -C xeus_zmq)
#
(mkdir pybind11 && cat pybind11.tgz | tar zxf - --strip-components 1 -C pybind11)
(mkdir py_json && cat py_json.tgz | tar zxf - --strip-components 1 -C py_json)
(mkdir xeus_py && cat xeus_py.tgz | tar zxf - --strip-components 1 -C xeus_py)
