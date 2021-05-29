FROM python:3.7-slim AS compile-image
RUN apt-get update \
 && apt-get install -y --no-install-recommends\
  build-essential \
  gcc


# Use venv
ENV VIRTUAL_ENV=/venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install dependencies
COPY . /content/

WORKDIR /content
RUN pip install --no-cache-dir pip -U \
 && pip install -r requirements.txt \
 && pip install onnxruntime==1.6.0

FROM python:3.7-slim AS build-image
COPY --from=compile-image /venv /venv

ENV PATH="/venv/bin:$PATH"
COPY . /content
WORKDIR /content
CMD python onnx_serve.py ${MODEL_NAME}
