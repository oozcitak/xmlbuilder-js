dev:
	@rm -fr lib/
	@test `which coffee` || echo 'You need to have CoffeeScript installed.'
	@coffee -c -o lib src/*.coffee

publish: dev
	@test `which npm` || echo 'You need to have npm installed.'
	npm publish
	@rm -fr lib/

