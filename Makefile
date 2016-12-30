all: build

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth

ENV_VARS = \
	--env="USER_UID=$(shell id -u)" \
	--env="USER_GID=$(shell id -g)" \
	--env="DISPLAY=${DISPLAY}" \
	--env="XAUTHORITY=${XAUTH}"

VOLUMES = \
	--volume=$(HOME)/.config/skype:/home/skype/.config/skype \
	--volume=$(HOME)/Downloads:/home/skype/Downloads \
	--volume=${XSOCK}:${XSOCK} \
	--volume=${XAUTH}:${XAUTH} \
	--volume=/run/user/$(shell id -u)/pulse:/run/pulse

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "   1. make build            - build the skype image"
	@echo "   1. make install          - install launch wrappers"
	@echo "   2. make skypeforlinux    - launch skypeforlinux"
	@echo "   2. make bash             - bash login"
	@echo ""

build:
	@docker build --tag=sameersbn/skypeforlinux:$(shell cat VERSION) .

install uninstall: build
	@docker run -it --rm \
		--volume=/usr/local/bin:/target \
		sameersbn/skypeforlinux:$(shell cat VERSION) $@

skypeforlinux bash:
	@docker run -it --rm \
		${ENV_VARS} \
		${VOLUMES} \
		sameersbn/skypeforlinux:$(shell cat VERSION) $@
