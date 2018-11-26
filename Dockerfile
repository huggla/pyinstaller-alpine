# Python base image is needed or some applications will segfault.
FROM huggla/python2.7-alpine

ARG PIP_PACKAGES="pycrypto flask gunicorn"
ARG PYINSTALLER_TAG="v3.4"

COPY ./bin /pyinstaller

RUN apk add zlib-dev musl-dev libc-dev gcc git pwgen upx tk \
 && pip install --upgrade pip \
 && pip install $PIP_PACKAGES \
 && git clone --depth 1 --single-branch --branch $PYINSTALLER_TAG https://github.com/pyinstaller/pyinstaller.git /tmp/pyinstaller \
 && cd /tmp/pyinstaller/bootloader \
 && python ./waf configure --no-lsb all \
 && pip install .. \
 && rm -Rf /tmp/pyinstaller \
 && chmod a+x /pyinstaller/*

WORKDIR /src

ENTRYPOINT ["/pyinstaller/pyinstaller.sh"]
