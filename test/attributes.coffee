vows = require 'vows'
assert = require 'assert'

xmlbuilder = require '../src/index.coffee'

vows
    .describe('Editing')
    .addBatch
        'Add attribute':
            topic: () ->
                xmlbuilder.create('test4', { headless: true })
                    .ele('node', 'element', {"first":"1", "second":"2"})
                        .att("third", "3")

            'resulting XML': (doc) ->
                xml = '<test4><node first="1" second="2" third="3">element</node></test4>'
                assert.strictEqual doc.end(), xml

        'Remove attribute':
            topic: () ->
                root = xmlbuilder.create('test4', { headless: true })
                ele = root.ele('node', 'element', {"first":"1", "second":"2", "third":"3"})
                ele.removeAttribute("second")
                root

            'resulting XML': (doc) ->
                xml = '<test4><node first="1" third="3">element</node></test4>'
                assert.strictEqual doc.end(), xml

        'Throw if null attribute (ele)':
            topic: () ->
                xmlbuilder.create('test4', { headless: true })

            'resulting XML': (root) ->
                assert.throws ->
                    root.ele('node', 'element', {"first":null, "second":"2"})

        'Throw if null attribute (att)':
            topic: () ->
                xmlbuilder.create('test4', { headless: true })

            'resulting XML': (root) ->
                assert.throws ->
                    root.ele('node').att("first")

        'Throw if null attribute (JSON)':
            topic: () ->
                xmlbuilder.create('test4', { headless: true })

            'resulting XML': (root) ->
                assert.throws ->
                    root.ele({'@first': null})

        'Skip if null attribute (ele)':
            topic: () ->
                xmlbuilder.create('test4', { headless: true, skipNullAttributes: true })
                    .ele('node', 'element', {"first":null, 'second': '2'})

            'resulting XML': (doc) ->
                xml = '<test4><node second="2">element</node></test4>'
                assert.strictEqual doc.end(), xml

        'Skip if null attribute (att)':
            topic: () ->
                xmlbuilder.create('test4', { headless: true, skipNullAttributes: true })
                    .ele('node').att("first")

            'resulting XML': (doc) ->
                xml = '<test4><node/></test4>'
                assert.strictEqual doc.end(), xml

        'Skip if null attribute (JSON)':
            topic: () ->
                xmlbuilder.create('test4', { headless: true, skipNullAttributes: true })
                    .ele({'@first': null, '@second': '2'})

            'resulting XML': (doc) ->
                xml = '<test4 second="2"/>'
                assert.strictEqual doc.end(), xml

    .export(module)

