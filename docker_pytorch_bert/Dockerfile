FROM ubuntu:18.04

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  build-essential \
  wget \
  curl \
  file \
  sudo \
  unzip \
  zlibc zlib1g zlib1g-dev \
  git \
  python3 \
  python3-pip \
  python3-dev

RUN wget http://nlp.ist.i.kyoto-u.ac.jp/nl-resource/juman/juman-7.01.tar.bz2
RUN tar jxvf juman-7.01.tar.bz2 \
 && cd juman-7.01 \
 && ./configure \
 && make \
 && make install \
 && echo "include /usr/local/lib" >> /etc/ld.so.conf \
 && ldconfig

RUN wget http://nlp.ist.i.kyoto-u.ac.jp/nl-resource/knp/knp-4.19.tar.bz2
RUN tar jxvf knp-4.19.tar.bz2 \
 && cd knp-4.19 \
 && ./configure \
 && make \
 && make install

RUN pip3 install --upgrade pip
RUN pip3 install setuptools six

RUN wget http://nlp.ist.i.kyoto-u.ac.jp/nl-resource/knp/pyknp-0.3.tar.gz
RUN tar xvf pyknp-0.3.tar.gz \
 && cd pyknp-0.3 \
 && python3 setup.py install

RUN pip3 install jupyterlab ipywidgets
RUN jupyter nbextension enable --py widgetsnbextension

RUN apt-get install -y nodejs npm \
  && export NODE_OPTIONS=--max-old-space-size=4096 \
  && jupyter labextension install @jupyter-widgets/jupyterlab-manager@1.0 --no-build \
  && jupyter lab build \
  && unset NODE_OPTIONS

RUN pip3 install torch==1.1.0 torchvision==0.4.0+cpu -f https://download.pytorch.org/whl/cpu/torch_stable.html
RUN pip3 install pytorch_pretrained_bert

RUN sed -i -e \
    "s#text = self._tokenize_chinese_chars(text)#\# text = self._tokenize_chinese_chars(text)#" \
    /usr/local/lib/python3.6/dist-packages/pytorch_pretrained_bert/tokenization.py

COPY ./requirements.txt /requirements.txt
RUN pip3 install -r /requirements.txt

RUN mkdir /work
WORKDIR /work

ARG JUPYTER_PORT
ENV ENV_JUPYTER_PORT $JUPYTER_PORT

EXPOSE $ENV_JUPYTER_PORT

CMD jupyter lab --port=${ENV_JUPYTER_PORT} --ip=0.0.0.0 --allow-root --no-browser