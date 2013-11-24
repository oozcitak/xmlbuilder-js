vows = require 'vows'
assert = require 'assert'

xmlbuilder = require '../src/index.coffee'

vows
    .describe('Editing')
    .addBatch
        'Remove item':
            topic: () ->
                root = xmlbuilder.create('test4', {}, {}, { headless: true })
                ele = root.e('node', 'element', {"first":"1", "second":"2", "third":"3"})
                ele.removeAttribute("second")
                root

            'resulting XML': (topic) ->
                xml = '<test4><node first="1" third="3">element</node></test4>'
                assert.strictEqual topic.end(), xml

    .export(module)

