# UNISON_OPTS=-auto -batch
SYNC_DIRS=templates contents/authors contents/style contents/img contents/script
BUILD_FILES=$(shell find .. -type d \( -path '../src' -o -path '../.*' \) -prune -o -name '*' -not -name '.*' -not -name 'README.md' -print)

all: update sync build

update:
	npm install
	npm update

build:
	node ./node_modules/wintersmith/bin/wintersmith build

preview:
	node ./node_modules/wintersmith/bin/wintersmith preview

deploy:
	rm -rf ./build
	wintersmith build
	cd ./build && \
	git init . && \
	git add . && \
	git commit -m "Deploy"; \
	git push "git@github.com:icdocsoc/icdocsoc.github.io.git" master:master --force && \
	rm -rf .git

clean:
	rm -rf $(BUILD_FILES)


.PHONY: update sync build preview clean
