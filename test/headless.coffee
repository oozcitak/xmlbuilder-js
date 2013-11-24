vows = require 'vows'
assert = require 'assert'

xmlbuilder = require '../src/index.coffee'

vows
    .describe('Creating XML')
    .addBatch
        'Headless':
            topic: () ->
                xmlbuilder.create('root', {}, {}, { headless: true })
                    .ele('xmlbuilder', { 'for': 'node-js' })
                        .ele('repo', { 'type': 'git' }, 'git://github.com/oozcitak/xmlbuilder-js.git')

            'resulting XML': (topic) ->
                xml = '<root>' +
                          '<xmlbuilder for="node-js">' +
                              '<repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>' +
                          '</xmlbuilder>' +
                      '</root>'
                assert.strictEqual topic.end(), xml

    .export(module)

