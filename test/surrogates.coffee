vows = require 'vows'
assert = require 'assert'

xmlbuilder = require '../src/index.coffee'

vows
    .describe('Surrogate Pairs')
    .addBatch
        'Do not allow surrogates':
            topic: () ->
                stringWithIssues = '𡬁𠻝𩂻耨鬲, 㑜䊑㓣䟉䋮䦓, ᡨᠥ᠙ᡰᢇ᠘ᠶ, ࿋ཇ࿂ོ༇ྒ, ꃌꈗꈉꋽ, Uighur, ᥗᥩᥬᥜᥦ '
                xmlbuilder.create('test15', {}, {}, {allowSurrogateChars: false})
                    .ele('node').txt(stringWithIssues)

            'should throw': (topic) ->
                assert.throws topic, Error

        'Allow surrogates':
            topic: () ->
                stringWithIssues = '𡬁𠻝𩂻耨鬲, 㑜䊑㓣䟉䋮䦓, ᡨᠥ᠙ᡰᢇ᠘ᠶ, ࿋ཇ࿂ོ༇ྒ, ꃌꈗꈉꋽ, Uighur, ᥗᥩᥬᥜᥦ '
                xmlbuilder.create('test15', {}, {}, {allowSurrogateChars: true})
                    .ele('node').txt(stringWithIssues)

            'should not throw': (topic) ->
                assert.doesNotThrow topic, Error


    .export(module)

