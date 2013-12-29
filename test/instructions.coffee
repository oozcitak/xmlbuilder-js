vows = require 'vows'
assert = require 'assert'

xmlbuilder = require '../src/index.coffee'

vows
    .describe('Processing Instructions')
    .addBatch
        'Simple':
            topic: () ->
                xmlbuilder.create('test17', { headless: true })
                    .ins('pi', 'mypi')

            'resulting XML': (doc) ->
                xml = '<?pi mypi?><test17/>'
                assert.strictEqual doc.end(), xml

        'From object':
            topic: () ->
                xmlbuilder.create('test17', { headless: true })
                    .ins({'pi': 'mypi', 'pi2': 'mypi2', 'pi3': null})

            'resulting XML': (doc) ->
                xml = '<?pi mypi?><?pi2 mypi2?><?pi3?><test17/>'
                assert.strictEqual doc.end(), xml

        'From array':
            topic: () ->
                xmlbuilder.create('test17', { headless: true })
                    .ins(['pi', 'pi2'])

            'resulting XML': (doc) ->
                xml = '<?pi?><?pi2?><test17/>'
                assert.strictEqual doc.end(), xml

        'Complex':
            topic: () ->
                xmlbuilder.create('test18', { headless: true })
                    .ins('renderCache.subset', '"Verdana" 0 0 ISO-8859-1 4 268 67 "#(),-./')
                    .ins('pitarget', () -> 'pivalue')

            'resulting XML': (doc) ->
                xml = '<?renderCache.subset "Verdana" 0 0 ISO-8859-1 4 268 67 "#(),-./?><?pitarget pivalue?><test18/>'
                assert.strictEqual doc.end(), xml


    .export(module)

