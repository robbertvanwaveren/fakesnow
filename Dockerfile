FROM public.ecr.aws/docker/library/python:3.14-slim

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

RUN apt-get update \
        && apt-get upgrade -y \
        && apt-get install -y --no-install-recommends build-essential \
        && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir "fakesnow[server]"

# Patch fakesnow with configurable host
COPY ./fakesnow/__init__.py /usr/local/lib/python3.14/site-packages/fakesnow/
COPY ./fakesnow/cli.py /usr/local/lib/python3.14/site-packages/fakesnow/

# Expose default port (adjust if needed)
EXPOSE 8080

# Set default command to run the server
CMD ["fakesnow", "-s", "-o", "0.0.0.0", "-p", "8080"]