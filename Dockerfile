FROM python:3.8-alpine
COPY app.py test.py /app/
WORKDIR /app
ENV PIP_ROOT_USER_ACTION=ignore
RUN curl -fsSLO https://get.docker/builds/Linux/x86_64/docker-17.04.0-ce.tgz \
  && tar xzvf docker-17.04.0-ce.tgz \
  && mv docker/docker /usr/local/bin \
  && rm -r docker docker-17.04.0-ce.tgz
RUN pip --disable-pip-version-check install --user flask pytest flake8
CMD ["python", "app.py"]
