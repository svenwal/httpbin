FROM ubuntu:18.04
LABEL name="httpbin"
LABEL version="0.9.2"
LABEL description="A simple HTTP service."
LABEL org.kennethreitz.vendor="Kenneth Reitz"
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get -y update && apt-get -y install libffi-dev libssl-dev && apt update -y && apt install python3-pip git -y && pip3 install --no-cache-dir pipenv

ADD Pipfile Pipfile.lock /httpbin/
WORKDIR /httpbin
RUN /bin/bash -c "pip3 install --no-cache-dir -r <(pipenv lock -r)"
ADD . /httpbin
RUN pip3 install --no-cache-dir /httpbin

RUN useradd -ms /bin/bash httpbin
USER httpbin

EXPOSE 8080

CMD ["gunicorn", "-b", "0.0.0.0:8080", "httpbin:app", "-k", "gevent"]