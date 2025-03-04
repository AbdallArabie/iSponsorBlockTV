# syntax=docker/dockerfile:1
FROM python:3.11-alpine3.19 as compiler

WORKDIR /app

COPY src .

RUN python3 -m compileall -b -f . && \
    find . -name "*.py" -type f -delete

FROM python:3.11-alpine3.19

ENV PIP_NO_CACHE_DIR=off iSPBTV_docker=True iSPBTV_data_dir=data TERM=xterm-256color COLORTERM=truecolor

COPY requirements.txt .

RUN pip install --upgrade pip wheel && \
    pip install -r requirements.txt && \
    pip uninstall -y pip wheel && \
    python3 -m compileall -b -f /usr/local/lib/python3.11/site-packages && \
    find /usr/local/lib/python3.11/site-packages -name "*.py" -type f -delete && \
    find /usr/local/lib/python3.11/ -name "__pycache__" -type d -exec rm -rf {} +

WORKDIR /app

COPY --from=compiler /app .

ENTRYPOINT ["python3", "-u", "main.pyc"]
