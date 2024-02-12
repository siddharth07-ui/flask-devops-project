FROM python:3.8
COPY . /app/
WORKDIR /app
RUN pip install flask pytest flake8
CMD ["python", "app.py"]