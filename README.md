# irsl_docker_xeus

## Usage
```bash
docker run --net=host -- repo.irsl.eiiris.tut.ac.jp/xeus3:22.04 jupyter lab --allow-root --no-browser --ip=0.0.0.0 --port=8888 --NotebookApp.token='' --FileContentsManager.delete_to_trash=False
```
## Docker Build

```bash
docker build . -f Dockerfile.xeus5all -t xeus5:latest
```

## Local Build

```bash
./local_build5.sh --apt-get --output-dir /opt/xeus
```

## Reference

https://github.com/jupyter-xeus/xeus
https://github.com/nlohmann/json

https://github.com/zeromq/cppzmq
https://github.com/jupyter-xeus/xeus-zmq

https://github.com/pybind/pybind11
https://github.com/pybind/pybind11_json
https://github.com/jupyter-xeus/xeus-python
