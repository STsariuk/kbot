APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=stsariuk
DOCKERREGISTRY=svts
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=arm64

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build: format
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/STsariuk/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${DOCKERREGISTRY}/${APP}:${VERSION}-${TARGETARCH}
	
# for push image into repo need to have the same tag as your repo
push:
	docker push ${DOCKERREGISTRY}/${APP}:${VERSION}-${TARGETARCH}
clean:
	rm -rf kbot
