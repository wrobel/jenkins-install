include settings.mk
include hudson.mk

.PHONY:install
install: hudson-install

.PHONY:install-latest
install-latest: hudson-install-latest

PHONY:clean
clean: hudson-clean
