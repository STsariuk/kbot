APP=$(shell basename $(shell git remote get-url origin))
DOCKERREGISTRY=svts
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux #Linux darwin Windows
TARGETARCH=amd64 # arm64 amd64
GCPPROJECT=devops-week-three-49104

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/STsariuk/kbot/cmd.appVersion=${VERSION}

image:
#	docker build . -t ${DOCKERREGISTRY}/${APP}:${VERSION}-${TARGETARCH}
	docker build . -t gcr.io/${GCPPROJECT}/${APP}:${VERSION}-${TARGETARCH}
	
# for push image into repo need to have the same tag as your repo
push:
#	docker push ${DOCKERREGISTRY}/${APP}:${VERSION}-${TARGETARCH}
	docker push gcr.io/${GCPPROJECT}/${APP}:${VERSION}-${TARGETARCH}
clean:
	rm -rf kbot
	docker rmi gcr.io/${GCPPROJECT}/${APP}:${VERSION}-${TARGETARCH}
