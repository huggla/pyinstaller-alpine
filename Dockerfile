ARG TAG="20181204"

FROM huggla/python2.7-alpine:$TAG

ARG PIP_PACKAGES="pycrypto"
ARG PYINSTALLER_TAG="v3.4"

COPY ./bin /pyinstaller

RUN apk add zlib-dev musl-dev libc-dev gcc git pwgen upx tk tk-dev build-base binutils \
 && pip install --upgrade pip \
 && pip install $PIP_PACKAGES \
 && git clone --depth 1 --single-branch --branch $PYINSTALLER_TAG https://github.com/pyinstaller/pyinstaller.git /tmp/pyinstaller \
 && cd /tmp/pyinstaller/bootloader \
 && python ./waf configure --no-lsb all \
 && pip install .. \
 && rm -Rf /tmp/pyinstaller \
 && chmod a+x /pyinstaller/*

WORKDIR /src

ENV PYTHONOPTIMIZE="2"

ENTRYPOINT ["/pyinstaller/pyinstaller.sh"]
