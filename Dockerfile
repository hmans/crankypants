# First of all, let's compile our web assets in production mode.
FROM node:9 AS webpack
WORKDIR /work
COPY yarn.lock package.json /work/
RUN yarn install
ADD . /work
RUN yarn web:build:release

# Next, we'll want to compile Crankypants. Let's start with the official
# Crystal image and go from there.
FROM crystallang/crystal:0.25.0 AS crystal
RUN apt-get update && apt-get install -y libsqlite3-dev

ADD . /work
WORKDIR /work

# Install all those shards we need
RUN shards install

# Copy the web assets we compiled in the previous stage.
COPY --from=webpack /work/public/assets/ /work/public/assets/

# Now it's time to compile Crankypants!
RUN crystal build src/crankypants_cli.cr -o ./crankypants --release --no-debug
RUN strip crankypants

# We use this to identify dependencies used later:
RUN crystal run ./support/list-deps.cr -- ./crankypants

# Finally, let's build the actual Docker image... from scratch.
FROM scratch

# We'll copy over our dependencies from the previously used crystal container.
# If we ever need to refresh this list, uncomment the `crystal run` line found
# above.
COPY --from=crystal /usr/lib/x86_64-linux-gnu/libxml2.so.2 /usr/lib/x86_64-linux-gnu/libxml2.so.2
COPY --from=crystal /usr/lib/x86_64-linux-gnu/libxml2.so.2.9.3 /usr/lib/x86_64-linux-gnu/libxml2.so.2.9.3
COPY --from=crystal /lib/x86_64-linux-gnu/libz.so.1 /lib/x86_64-linux-gnu/libz.so.1
COPY --from=crystal /lib/x86_64-linux-gnu/libz.so.1.2.8 /lib/x86_64-linux-gnu/libz.so.1.2.8
COPY --from=crystal /lib/x86_64-linux-gnu/libssl.so.1.0.0 /lib/x86_64-linux-gnu/libssl.so.1.0.0
COPY --from=crystal /lib/x86_64-linux-gnu/libcrypto.so.1.0.0 /lib/x86_64-linux-gnu/libcrypto.so.1.0.0
COPY --from=crystal /usr/lib/x86_64-linux-gnu/libsqlite3.so.0 /usr/lib/x86_64-linux-gnu/libsqlite3.so.0
COPY --from=crystal /usr/lib/x86_64-linux-gnu/libsqlite3.so.0.8.6 /usr/lib/x86_64-linux-gnu/libsqlite3.so.0.8.6
COPY --from=crystal /lib/x86_64-linux-gnu/libpcre.so.3 /lib/x86_64-linux-gnu/libpcre.so.3
COPY --from=crystal /lib/x86_64-linux-gnu/libpcre.so.3.13.2 /lib/x86_64-linux-gnu/libpcre.so.3.13.2
COPY --from=crystal /lib/x86_64-linux-gnu/libm.so.6 /lib/x86_64-linux-gnu/libm.so.6
COPY --from=crystal /lib/x86_64-linux-gnu/libm-2.23.so /lib/x86_64-linux-gnu/libm-2.23.so
COPY --from=crystal /lib/x86_64-linux-gnu/libpthread.so.0 /lib/x86_64-linux-gnu/libpthread.so.0
COPY --from=crystal /lib/x86_64-linux-gnu/libpthread-2.23.so /lib/x86_64-linux-gnu/libpthread-2.23.so
COPY --from=crystal /usr/lib/x86_64-linux-gnu/libevent-2.0.so.5 /usr/lib/x86_64-linux-gnu/libevent-2.0.so.5
COPY --from=crystal /usr/lib/x86_64-linux-gnu/libevent-2.0.so.5.1.9 /usr/lib/x86_64-linux-gnu/libevent-2.0.so.5.1.9
COPY --from=crystal /lib/x86_64-linux-gnu/librt.so.1 /lib/x86_64-linux-gnu/librt.so.1
COPY --from=crystal /lib/x86_64-linux-gnu/librt-2.23.so /lib/x86_64-linux-gnu/librt-2.23.so
COPY --from=crystal /lib/x86_64-linux-gnu/libdl.so.2 /lib/x86_64-linux-gnu/libdl.so.2
COPY --from=crystal /lib/x86_64-linux-gnu/libdl-2.23.so /lib/x86_64-linux-gnu/libdl-2.23.so
COPY --from=crystal /lib/x86_64-linux-gnu/libgcc_s.so.1 /lib/x86_64-linux-gnu/libgcc_s.so.1
COPY --from=crystal /lib/x86_64-linux-gnu/libc.so.6 /lib/x86_64-linux-gnu/libc.so.6
COPY --from=crystal /lib/x86_64-linux-gnu/libc-2.23.so /lib/x86_64-linux-gnu/libc-2.23.so
COPY --from=crystal /lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
COPY --from=crystal /lib/x86_64-linux-gnu/ld-2.23.so /lib/x86_64-linux-gnu/ld-2.23.so
COPY --from=crystal /usr/lib/x86_64-linux-gnu/libicuuc.so.55 /usr/lib/x86_64-linux-gnu/libicuuc.so.55
COPY --from=crystal /usr/lib/x86_64-linux-gnu/libicuuc.so.55.1 /usr/lib/x86_64-linux-gnu/libicuuc.so.55.1
COPY --from=crystal /lib/x86_64-linux-gnu/liblzma.so.5 /lib/x86_64-linux-gnu/liblzma.so.5
COPY --from=crystal /lib/x86_64-linux-gnu/liblzma.so.5.0.0 /lib/x86_64-linux-gnu/liblzma.so.5.0.0
COPY --from=crystal /usr/lib/x86_64-linux-gnu/libicudata.so.55 /usr/lib/x86_64-linux-gnu/libicudata.so.55
COPY --from=crystal /usr/lib/x86_64-linux-gnu/libicudata.so.55.1 /usr/lib/x86_64-linux-gnu/libicudata.so.55.1
COPY --from=crystal /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /usr/lib/x86_64-linux-gnu/libstdc++.so.6
COPY --from=crystal /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.21 /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.21

COPY --from=crystal /work/crankypants /crankypants

EXPOSE 3000
ENTRYPOINT ["/crankypants"]
