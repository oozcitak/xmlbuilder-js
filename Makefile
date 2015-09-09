all: clean test

clean:
	$(RM) -r node_modules

test: node_modules lodash-install
	npm test --silent

node_modules:
	npm install --quiet

lodash-clean:
	$(RM) -r node_modules/lodash

lodash-install: lodash-clean
	npm run lodash:install --silent

.PHONY: test
