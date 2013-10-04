# UNISON_OPTS=-auto -batch
SYNC_DIRS=templates contents/authors contents/style contents/img contents/script
BUILD_FILES=$(shell find .. -type d \( -path '../src' -o -path '../.*' \) -prune -o -name '*' -not -name '.*' -not -name 'README.md' -print)

all: update sync build push


update:
  npm install
  npm update

# sync:
#   todo

build:
  node ./node_modules/wintersmith/bin/wintersmith build

preview: 
  node ./node_modules/wintersmith/bin/wintersmith preview

clean:
  rm -rf $(BUILD_FILES)


.PHONY: update sync build preview clean
