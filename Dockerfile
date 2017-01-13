FROM smithmicro/swift:3.0.1
MAINTAINER Claus

RUN apt-get update && apt-get install -y \
  libssl-dev \
  && rm -rf /var/lib/apt/lists/*