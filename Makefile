test: release
	@test `which coffee` || echo 'You need to have CoffeeScript installed.'
	@coffee test/test.coffee

release:
	@rm -fr lib/
	@test `which coffee` || echo 'You need to have CoffeeScript installed.'
	@coffee -c -o lib src/*.coffee

publish: release
	@test `which npm` || echo 'You need to have npm installed.'
	npm publish
	@rm -fr lib/

