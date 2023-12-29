FROM alpine:3.14

RUN apk add --no-cache \
    python3 \
		py3-pip

RUN pip3 install --upgrade pip

COPY requirements.txt /tmp/requirements.txt

RUN pip3 install -r /tmp/requirements.txt
