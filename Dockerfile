FROM python:3.11-slim

# Node.js needed for CodeMirror submodule build
RUN apt-get update && apt-get install -y --no-install-recommends \
    git nodejs npm \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy repo
COPY . .

# Initialize and build CodeMirror submodule
RUN git submodule update --init --recursive
RUN cd app/static/CodeMirror && npm install rollup && npm run build

# Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 7877

CMD ["gunicorn", "--config", "gunicorn_config.py", "wsgi:app"]
