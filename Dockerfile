ARG BUILD_IMAGE=python:3.9.5-slim

# wheels build stage
FROM $BUILD_IMAGE as wheels

WORKDIR /wheels

COPY requirements.txt requirements.txt

RUN apt-get update && \
    apt-get install -y build-essential && \
    pip3 wheel -r requirements.txt

# app build stage
FROM $BUILD_IMAGE

WORKDIR /data

COPY --from=wheels /wheels /wheels

RUN pip3 install --no-cache-dir --no-index --find-links=/wheels /wheels/*.whl && \
    printf "\nTo get app usage: story_downloader.py --help\n\n" > /etc/motd && \
    printf '[ -n "$TERM" -a -r /etc/motd ] && cat /etc/motd' >> /etc/bash.bashrc && \
    rm -fr /wheels

ENV PATH="/app:${PATH}"

COPY . /app/

ENTRYPOINT []
CMD ["/bin/bash"]
