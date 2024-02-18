FROM python:3.8-alpine
COPY app.py test.py /app/
WORKDIR /app
ENV PIP_ROOT_USER_ACTION=ignore
RUN pip --disable-pip-version-check install --user flask pytest flake8
CMD ["python", "app.py"]
