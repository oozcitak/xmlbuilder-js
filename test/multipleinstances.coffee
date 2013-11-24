vows = require 'vows'
assert = require 'assert'

xmlbuilder = require '../src/index.coffee'

vows
    .describe('Creating XML')
    .addBatch
        'Multiple Instances':
            topic: () ->
                xml1 = xmlbuilder.create('first')
                    .ele('node1', { 'testatt1': 'testattval1' }, 'text1')
                xml2 = xmlbuilder.create('second')
                    .ele('node2', { 'testatt2': 'testattval2' }, 'text2')

                [xml1, xml2]

            'resulting XML': (topic) ->
                xml1 = '<?xml version="1.0"?>' +
                       '<first>' +
                          '<node1 testatt1="testattval1">text1</node1>' +
                      '</first>'
                assert.strictEqual topic[0].end(), xml1
                xml2 = '<?xml version="1.0"?>' +
                       '<second>' +
                          '<node2 testatt2="testattval2">text2</node2>' +
                      '</second>'
                assert.strictEqual topic[1].end(), xml2

                # First instance should remain unchanged
                assert.strictEqual topic[0].end(), xml1

    .export(module)

