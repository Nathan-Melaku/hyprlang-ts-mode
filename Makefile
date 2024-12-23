EASK ?= eask

all: autoloads compile install

compile:
	$(EASK) compile

install:
	$(EASK) package
	$(EASK) install

autoloads:
	$(EASK) generate autoloads

clean:
	$(EASK) clean all

test: clean all install
	$(EASK) test ert ./tests/hyprlang-ts-mode-tests.el

.PHONY: all autoloads clean test
