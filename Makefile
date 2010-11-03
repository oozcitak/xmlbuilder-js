dev:
	@rm -fr lib/
	@test `which coffee` || echo 'You need to have CoffeeScript installed.'
	@coffee -c -o lib src/*.coffee

publish: dev
	@test `which npm` || echo 'You need to have npm installed.'
	npm publish
	@rm -fr lib/

test: dev
	@test `which node` || echo 'You need to have node-js installed.'
	@node ./test/test.js
