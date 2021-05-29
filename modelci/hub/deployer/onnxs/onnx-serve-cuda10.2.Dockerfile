# Stage1: Compile
FROM nvidia/cuda:10.2-cudnn8-devel-ubuntu18.04 AS compile-image
COPY . /content

RUN apt-get update \
 && apt-get install -y --no-install-recommends\
  gcc=4:7.4.0-1ubuntu2.3 \
  git=1:2.17.1-1ubuntu0.8 \
  python3.7=3.7.5-2~18.04.4 \
  python3-venv \
  python3.7-venv=3.7.5-2~18.04.4 \
  python3.7-dev=3.7.5-2~18.04.4 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Use venv
ENV VIRTUAL_ENV=/venv
RUN python3.7 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install dependencies
WORKDIR /content
RUN pip install --no-cache-dir pip -U \
 && pip install -r requirements.txt \
 && pip install onnxruntime-gpu==1.6.0

# Stage2: Build
FROM nvidia/cuda:10.2-cudnn8-runtime-ubuntu18.04 AS build-image
RUN apt-get update && apt-get install -y --no-install-recommends \
 python3.7=3.7.5-2~18.04.4 \
 python3.7-venv=3.7.5-2~18.04.4 \
 python3.7-dev=3.7.5-2~18.04.4 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY --from=compile-image /venv /venv
ENV PATH="/venv/bin:$PATH"
COPY . /content
WORKDIR /content
CMD python onnx_serve.py ${MODEL_NAME}