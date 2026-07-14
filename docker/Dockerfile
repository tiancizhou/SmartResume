FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libgl1 \
    libglib2.0-0 \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt

COPY . .

RUN pip install --no-cache-dir flask && \
    pip install --no-cache-dir -e .

ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1
ENV SMARTRESUME_CONFIG=/app/configs/config.yaml

EXPOSE 4999

CMD ["python", "scripts/start.py", "--help"]
