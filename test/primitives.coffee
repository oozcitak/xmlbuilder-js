vows = require 'vows'
assert = require 'assert'

xmlbuilder = require '../src/index.coffee'

vows
    .describe('Implicit Conversion to Primitives')
    .addBatch
        'String':
            topic: () ->
                t1 = xmlbuilder.create('test', {}, {}, { headless: true })
                    .ele('node', 'hello')
                    .nod('node', 'hello')
                    .ins('node', 'hello')
                t2 = xmlbuilder.create('test', {}, {}, { headless: true })
                    .ele('node', new String('hello'))
                    .nod('node', new String('hello'))
                    .ins('node', new String('hello'))
                return [t1, t2]

            'resulting XML': (topic) ->
                assert.strictEqual topic[0].end(), topic[1].end()

        'Boolean':
            topic: () ->
                t1 = xmlbuilder.create('test', {}, {}, { headless: true })
                    .ele('node', true)
                t2 = xmlbuilder.create('test', {}, {}, { headless: true })
                    .ele('node', new Boolean(true))
                return [t1, t2]

            'resulting XML': (topic) ->
                assert.strictEqual topic[0].end(), topic[1].end()

        'Number':
            topic: () ->
                t1 = xmlbuilder.create('test', {}, {}, { headless: true })
                    .ele('node', 123)
                t2 = xmlbuilder.create('test', {}, {}, { headless: true })
                    .ele('node', new Number(123))
                return [t1, t2]

            'resulting XML': (topic) ->
                assert.strictEqual topic[0].end(), topic[1].end()


    .export(module)

