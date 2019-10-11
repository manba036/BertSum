#!/bin/bash

JUPYTER_PORT=$1
NAME=$(basename `pwd`)

if [ -z "${JUPYTER_PORT}" ]; then
  JUPYTER_PORT=8888
fi

echo "NAME         = ${NAME}"
echo "JUPYTER_PORT = ${JUPYTER_PORT}"

if [ ! -e ./Japanese_L-12_H-768_A-12_E-30_BPE.zip ]; then
  wget "http://nlp.ist.i.kyoto-u.ac.jp/DLcounter/lime.cgi?down=http://nlp.ist.i.kyoto-u.ac.jp/nl-resource/JapaneseBertPretrainedModel/Japanese_L-12_H-768_A-12_E-30_BPE.zip" -O ./Japanese_L-12_H-768_A-12_E-30_BPE.zip
fi

if [ ! -e ./models/Japanese_L-12_H-768_A-12_E-30_BPE/pytorch_model.bin -o ! -e ./models/Japanese_L-12_H-768_A-12_E-30_BPE/vocab.txt ]; then
  unzip -o ./Japanese_L-12_H-768_A-12_E-30_BPE.zip -d ./models/
fi

docker build -t ${NAME,,} --build-arg JUPYTER_PORT=${JUPYTER_PORT} ./docker_pytorch_bert
docker run --rm -it --name=${NAME,,} -p ${JUPYTER_PORT}:${JUPYTER_PORT} -v `pwd`:/work/${NAME} ${NAME,,}