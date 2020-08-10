FROM alpine:3.7 as download_stage

ARG RDFOX_VERSION=3.1.1
ARG RDFOX_URL=https://rdfox-distribution.s3.eu-west-2.amazonaws.com/release/v${RDFOX_VERSION}/RDFox-linux-${RDFOX_VERSION}.zip
RUN apk add --no-cache curl libarchive-tools

RUN mkdir -p /tmp/rdfox && \
    cd /tmp/rdfox && \
    set -x && \
    curl --location --output rdfox.zip --url "${RDFOX_URL}" && \
    bsdtar --strip-components=1 -xvf rdfox.zip && \
    rm rdfox.zip && \
    ls -al

FROM debian:buster-slim

#
# We cannot run this as root on Openshift so we run all processes under the user 'ekgprocess' and the group 'root'.
#
ARG UID=2000
ENV HOME=/home/ekgprocess
RUN useradd --system --no-user-group --home-dir /home/ekgprocess --create-home --shell /bin/bash --uid ${UID} --gid 0 ekgprocess && \
   chgrp -Rf root /home/ekgprocess && chmod -Rf g+w /home/ekgprocess

COPY --chown=ekgprocess:root --from=download_stage /tmp/rdfox ${HOME}/rdfox

ENV PATH=${PATH}:/home/ekgprocess/rdfox

ENV RDFOX_ROLE=admin
ENV RDFOX_PASSWORD=admin

USER ekgprocess

ENTRYPOINT ["/home/ekgprocess/rdfox/RDFox"]

CMD [ "sandbox"]

