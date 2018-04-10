# STAGE 1: compile crankypants
FROM crystallang/crystal:latest
RUN apt-get update && apt-get install -y libsqlite3-dev

ADD . /work
WORKDIR /work
RUN shards install
RUN crystal build src/crankypants.cr --release --no-debug
RUN strip crankypants

# This should be...:
# RUN shards build --production

# We use this to identify dependencies and generate the lower
# part of the Dockerfile:
# RUN crystal run ./support/list-deps.cr -- ./crankypants

# STAGE 2: build the actual image
FROM scratch
COPY --from=0 /lib/x86_64-linux-gnu/libz.so.1 /lib/x86_64-linux-gnu/libz.so.1
COPY --from=0 /lib/x86_64-linux-gnu/libz.so.1.2.8 /lib/x86_64-linux-gnu/libz.so.1.2.8
COPY --from=0 /lib/x86_64-linux-gnu/libssl.so.1.0.0 /lib/x86_64-linux-gnu/libssl.so.1.0.0
COPY --from=0 /lib/x86_64-linux-gnu/libcrypto.so.1.0.0 /lib/x86_64-linux-gnu/libcrypto.so.1.0.0
COPY --from=0 /usr/lib/x86_64-linux-gnu/libsqlite3.so.0 /usr/lib/x86_64-linux-gnu/libsqlite3.so.0
COPY --from=0 /usr/lib/x86_64-linux-gnu/libsqlite3.so.0.8.6 /usr/lib/x86_64-linux-gnu/libsqlite3.so.0.8.6
COPY --from=0 /lib/x86_64-linux-gnu/libpcre.so.3 /lib/x86_64-linux-gnu/libpcre.so.3
COPY --from=0 /lib/x86_64-linux-gnu/libpcre.so.3.13.2 /lib/x86_64-linux-gnu/libpcre.so.3.13.2
COPY --from=0 /lib/x86_64-linux-gnu/libm.so.6 /lib/x86_64-linux-gnu/libm.so.6
COPY --from=0 /lib/x86_64-linux-gnu/libm-2.23.so /lib/x86_64-linux-gnu/libm-2.23.so
COPY --from=0 /lib/x86_64-linux-gnu/libpthread.so.0 /lib/x86_64-linux-gnu/libpthread.so.0
COPY --from=0 /lib/x86_64-linux-gnu/libpthread-2.23.so /lib/x86_64-linux-gnu/libpthread-2.23.so
COPY --from=0 /usr/lib/x86_64-linux-gnu/libevent-2.0.so.5 /usr/lib/x86_64-linux-gnu/libevent-2.0.so.5
COPY --from=0 /usr/lib/x86_64-linux-gnu/libevent-2.0.so.5.1.9 /usr/lib/x86_64-linux-gnu/libevent-2.0.so.5.1.9
COPY --from=0 /lib/x86_64-linux-gnu/librt.so.1 /lib/x86_64-linux-gnu/librt.so.1
COPY --from=0 /lib/x86_64-linux-gnu/librt-2.23.so /lib/x86_64-linux-gnu/librt-2.23.so
COPY --from=0 /lib/x86_64-linux-gnu/libdl.so.2 /lib/x86_64-linux-gnu/libdl.so.2
COPY --from=0 /lib/x86_64-linux-gnu/libdl-2.23.so /lib/x86_64-linux-gnu/libdl-2.23.so
COPY --from=0 /lib/x86_64-linux-gnu/libgcc_s.so.1 /lib/x86_64-linux-gnu/libgcc_s.so.1
COPY --from=0 /lib/x86_64-linux-gnu/libc.so.6 /lib/x86_64-linux-gnu/libc.so.6
COPY --from=0 /lib/x86_64-linux-gnu/libc-2.23.so /lib/x86_64-linux-gnu/libc-2.23.so
COPY --from=0 /lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
COPY --from=0 /lib/x86_64-linux-gnu/ld-2.23.so /lib/x86_64-linux-gnu/ld-2.23.so
COPY --from=0 /work/crankypants /crankypants

EXPOSE 3000
ENV KEMAL_ENV=production
ENTRYPOINT ["/crankypants"]
