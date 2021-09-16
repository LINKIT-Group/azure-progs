# --------------------------------------------------------------------
# Copyright (c) 2020 Anthony Potappel - The Netherlands.
# SPDX-License-Identifier: MIT
# --------------------------------------------------------------------

NAME := azprogs
SERVICE_TARGET ?= $(NAME)

ifeq ($(user),)
# USER retrieved from env, UID from shell.
HOST_USER ?= $(strip $(if $(USER),$(USER),root))
HOST_UID ?= $(strip $(if $(shell id -u),$(shell id -u),0))
HOST_GID ?= $(strip $(if $(shell id -u),$(shell id -g),0))
else
# allow override by adding user= and/ or uid=  (lowercase!).
# uid= defaults to 0 if user= set (i.e. root).
HOST_USER = $(user)
HOST_UID = $(strip $(if $(uid),$(uid),0))
endif

# export such that its passed to shell functions for Docker to pick up.
export HOST_USER
export HOST_UID
export HOST_GID


.PHONY: shell
shell:
	@# start new shell
	@[ -d $(WORKDIR) ] || mkdir $(WORKDIR)
	docker-compose -p $(NAME) run --service-ports --rm $(SERVICE_TARGET)

.PHONY: build
build:
	docker-compose -p $(NAME) build $(SERVICE_TARGET)

.PHONY: clean
clean:
	[ ! -d .build ] || rm -rf .build
