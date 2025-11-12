FROM python:3.11-slim

# System deps for audio + ffmpeg
RUN apt-get update && apt-get install -y --no-install-recommends \
    git ffmpeg libsndfile1 ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app

# Install Poetry & deps (prod only)
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir poetry && \
    poetry config virtualenvs.create false && \
    poetry install --no-root --only main

# Use the OPEN SOURCE 8B model (your requirement)
ENV MODEL_ID=fixie-ai/ultravox-v0_6-llama-3_1-8b
ENV HF_HOME=/app/.cache/huggingface

EXPOSE 5000
CMD ["python", "-m", "ultravox.inference.server", "--model", "fixie-ai/ultravox-v0_6-llama-3_1-8b", "--port", "5000"]
