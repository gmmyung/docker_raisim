FROM ubuntu:jammy

WORKDIR /root/

RUN apt update && apt-get install -y
RUN apt install libeigen3-dev cmake git python3 clang python3-distutils python3-dev python3-pip -y

RUN git clone https://github.com/raisimTech/raisimlib

RUN pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu116

RUN cd raisimlib\
    && mkdir build\
    && cd build\
    && cmake .. -DCMAKE_INSTALL_PREFIX=/root/raisim_build/ -DRAISIM_EXAMPLE=ON -DRAISIM_PY=ON -DPYTHON_EXECUTABLE=$(python3 -c "import sys; print(sys.executable)")\
    && make install -j4

RUN export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/root/raisim_build/lib \
    && export PYTHONPATH=$PYTHONPATH:/root/raisim_build/lib

COPY activation.raisim /root/.raisim/activation.raisim

WORKDIR /root/raisimlib/raisimGymTorch/

RUN python3 setup.py develop



