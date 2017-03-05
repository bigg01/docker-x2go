NAME = bigg01/centos7-x2goserver
VERSION = 0.1

.PHONY: all build test tag_latest 

all: build

build:
	sudo docker build --rm=true -t $(NAME):$(VERSION) .

test:
	sudo docker run -p 2222:22 --rm=true $(NAME):$(VERSION)

tag_latest:
	docker tag -f $(NAME):$(VERSION) $(NAME):latest


