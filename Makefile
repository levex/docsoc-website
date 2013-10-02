OTHER_DIR=../../blog.mnewton.com/src
UNISON_OPTS=-auto -batch
SYNC_DIRS=templates contents/authors contents/style contents/img contents/script
BUILD_FILES=$(shell find .. -type d \( -path '../src' -o -path '../.*' \) -prune -o -name '*' -not -name '.*' -not -name 'README.md' -print)

ifdef M
	GIT_COMMIT_OPTS=-m "$(M)"
else
	GIT_COMMIT_OPTS=-m "updated stuff"
endif


all: update sync build push


update:
	npm install
	npm update

sync:
	$(foreach dir,$(SYNC_DIRS),unison $(UNISON_OPTS) ./$(dir) $(OTHER_DIR)/$(dir);)

build:
	node ./node_modules/wintersmith/bin/wintersmith build
	
push:
	git add ..
	git add -u ..
	git commit $(GIT_COMMIT_OPTS)
	git push

preview: 
	node ./node_modules/wintersmith/bin/wintersmith preview

clean:
	rm -rf $(BUILD_FILES)


.PHONY: update sync build push preview clean
