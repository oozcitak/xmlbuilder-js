vows = require 'vows'
assert = require 'assert'

xmlbuilder = require '../src/index.coffee'

vows
    .describe('Navigation')
    .addBatch
        'Prev/next/root':
            topic: () ->
                xmlbuilder.create('test5', {}, {}, { headless: true })
                    .e('node','1')
                    .up()
                    .e('node','element')
                    .up()
                    .e('node','2')
                    .prev()
                    .prev()
                    .att('prev','yes')
                    .next()
                    .next()
                    .att('next','yes')
                    .root()
                    .att('root', 'yes')

            'resulting XML': (topic) ->
                xml = '<test5 root="yes"><node prev="yes">1</node><node>element</node><node next="yes">2</node></test5>'
                assert.strictEqual topic.end(), xml

    .export(module)

