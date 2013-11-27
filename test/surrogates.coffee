vows = require 'vows'
assert = require 'assert'

xmlbuilder = require '../src/index.coffee'

vows
    .describe('Surrogate Pairs')
    .addBatch
        'Do not allow surrogates':
            topic: () ->
                xmlbuilder.create('test15', {allowSurrogateChars: false})

            'should throw': (xml) ->
                stringWithIssues = '\uD841\uDF0E\uD841\uDF0E'
                assert.throws ->
                    xml.ele('node').txt(stringWithIssues)

        'Allow surrogates':
            topic: () ->
                xmlbuilder.create('test16', {allowSurrogateChars: true})

            'should not throw': (xml) ->
                stringWithIssues = '\uD841\uDF0E\uD841\uDF0E'
                assert.doesNotThrow ->
                    xml.ele('node').txt(stringWithIssues)


    .export(module)

