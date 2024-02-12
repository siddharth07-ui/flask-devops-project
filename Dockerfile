FROM python:3.6
COPY . /app/
WORKDIR /app
RUN pip install flask pytest flake8
CMD ["python", "app.py"]