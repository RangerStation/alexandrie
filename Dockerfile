#
# Dockerfile for the Alexandrie crate registry application
#

FROM ubuntu:latest

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        tzdata \
    && rm -rf /var/lib/apt/lists/*

RUN apt update
RUN apt install -y clang libssl-dev pkg-config
# install proper dependencies for each database
# for postgresql and mysql, install diesel as well to set up the database
# for sqlite make a dummy file for Docker to copy
RUN apt install -y sqlite3 libsqlite3-dev
# Cruft we might want
#mkdir -p /usr/local/cargo/bin/; \
#        touch /usr/local/cargo/bin/diesel;

WORKDIR /alexandrie

# Manual Rust install and configures cargo path
RUN apt-get update
RUN apt-get install curl -y
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:$PATH"

# Copy everything from docker context into current working dir of docker image being built
COPY ./ ./

# Checks to see if these crate-index and crate-storage exist
RUN [ ! -d "./crate-index" ] && mkdir -p "./crate-index"
RUN [ ! -d "./crate-storage" ] && mkdir -p "./crate-storage"

RUN pwd
RUN ls

# build the app
RUN cargo build --release

CMD cargo run --release