FROM ubuntu:16.04

RUN apt-get update && apt-get install -y autoconf \
automake \
libtool \
curl \
make \
g++ \
unzip \
git \
vim

WORKDIR tmp/

RUN curl -LJO https://github.com/protocolbuffers/protobuf/releases/download/v3.6.1/protoc-3.6.1-linux-x86_64.zip && \
unzip protoc-3.6.1-linux-x86_64.zip && \
mv bin/protoc /usr/local/bin/ && \
mv ./include/google/ /usr/local/include/ && \
protoc --version

RUN curl -O https://dl.google.com/go/go1.11.linux-amd64.tar.gz && \
tar -xvf go1.11.linux-amd64.tar.gz && \
mv go /usr/local/

ENV GOROOT /usr/local/go
ENV GOPATH $HOME/go
ENV PATH $GOPATH/bin:$GOROOT/bin:$PATH

RUN go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway && \
go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger && \
go get -u github.com/golang/protobuf/protoc-gen-go && \
go get -d github.com/lyft/protoc-gen-validate && \
cd $GOPATH/src/github.com/lyft/protoc-gen-validate && make build

RUN curl -O https://swift.org/builds/swift-4.2.1-release/ubuntu1604/swift-4.2.1-RELEASE/swift-4.2.1-RELEASE-ubuntu16.04.tar.gz && \
tar xzvf swift-4.2.1-RELEASE-ubuntu16.04.tar.gz && \
mv swift-4.2.1-RELEASE-ubuntu16.04 /usr/local/bin/

ENV PATH /usr/local/bin/swift-4.2.1-RELEASE-ubuntu16.04/usr/bin:$PATH

RUN swiftc -v

RUN apt-get clean && apt-get update && apt-get install -y cmake \
ninja-build \
clang \
python \
uuid-dev \
libicu-dev \
icu-devtools \
libbsd-dev \
libedit-dev \
libxml2-dev \
libsqlite3-dev \
swig \
libpython-dev \
libncurses5-dev \
pkg-config \
libblocksruntime-dev \
libcurl4-openssl-dev \
systemtap-sdt-dev \
tzdata \
rsync

RUN git clone https://github.com/apple/swift-protobuf.git && \
cd swift-protobuf && \
swift build -c release && \
mv .build /usr/local/bin/swift-protobuf

ENV PATH /usr/local/bin/swift-protobuf/release:$PATH

RUN apt-get install -y nodejs \
npm && \
npm install -S ts-protoc-gen @types/google-protobuf google-protobuf @improbable-eng/grpc-web && \
ln -s /usr/bin/nodejs /usr/bin/node

WORKDIR /proto