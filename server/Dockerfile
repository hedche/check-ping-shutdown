# Use the official Python 3.9 image as the base image
FROM python:3.9-slim AS build

# Install system dependencies required for ping
RUN apt-get update && \
    apt-get install -y gcc libpq-dev iputils-ping && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt /app/

# Install dependencies (using --no-cache-dir to avoid pip cache)
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code into the container
COPY app.py /app/

# Expose the necessary port
EXPOSE 8080

# Set the default command to run your app
CMD ["python", "app.py"]
