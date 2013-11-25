vows = require 'vows'
assert = require 'assert'

xmlbuilder = require '../src/index.coffee'

vows
    .describe('Surrogate Pairs')
    .addBatch
        'Do not allow surrogates':
            topic: () ->
                xmlbuilder.create('test15', {}, {}, {allowSurrogateChars: false})

            'should throw': (xml) ->
                stringWithIssues = '𡬁𠻝𩂻耨鬲, 㑜䊑㓣䟉䋮䦓, ᡨᠥ᠙ᡰᢇ᠘ᠶ, ࿋ཇ࿂ོ༇ྒ, ꃌꈗꈉꋽ, Uighur, ᥗᥩᥬᥜᥦ '
                assert.throws ->
                    xml.ele('node').txt(stringWithIssues)

        'Allow surrogates':
            topic: () ->
                xmlbuilder.create('test16', {}, {}, {allowSurrogateChars: true})

            'should not throw': (xml) ->
                stringWithIssues = '𡬁𠻝𩂻耨鬲, 㑜䊑㓣䟉䋮䦓, ᡨᠥ᠙ᡰᢇ᠘ᠶ, ࿋ཇ࿂ོ༇ྒ, ꃌꈗꈉꋽ, Uighur, ᥗᥩᥬᥜᥦ '
                assert.doesNotThrow ->
                    xml.ele('node').txt(stringWithIssues)


    .export(module)

