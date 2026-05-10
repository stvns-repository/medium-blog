# Use the slim version of Python to keep the image small
FROM python:3.9-slim

# Install system tools needed for the Postgres driver
RUN apt-get update && apt-get install -y libpq-dev gcc && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file first
COPY requirements.txt .

# Install the Python libraries
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your app code
COPY . .

# Tell the container to listen on port 5000
EXPOSE 5000

# Start the application
CMD ["python", "app.py"]
