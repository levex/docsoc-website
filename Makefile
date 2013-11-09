# UNISON_OPTS=-auto -batch
SYNC_DIRS=templates contents/authors contents/style contents/img contents/script
BUILD_FILES=$(shell find .. -type d \( -path '../src' -o -path '../.*' \) -prune -o -name '*' -not -name '.*' -not -name 'README.md' -print)

all: update sync build

update:
	npm install
	npm update

build:
	rm -rf ./build && \
	node ./node_modules/wintersmith/bin/wintersmith build && \
	cd ./build && \
	find ./articles -name "*.jpg" -o -name "*.png" | while read line ; do mogrify -verbose -resize '800x800>' -quality 80 "$$line" ; done

preview:
	node ./node_modules/wintersmith/bin/wintersmith preview

deploy:
	make build
	cd ./build && \
	git init . && \
	git add . && \
	git commit -m "Deploy"; \
	git push "git@github.com:icdocsoc/icdocsoc.github.io.git" master:master --force && \
	rm -rf .git

clean:
	rm -rf $(BUILD_FILES)

resize_images:
	find ./contents -name "*.jpg" -o -name "*.png" | while read line ; do mogrify -verbose -resize '800x800>' "$$line" ; done

.PHONY: update sync build preview clean resize_images
