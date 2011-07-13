assert = require('assert')
builder = require '../src/index.coffee'

xml = '<root>' +
        '<xmlbuilder for="node-js">' +
          '<!-- CoffeeScript is awesome. -->' +
          '<repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>' +
        '</xmlbuilder>' +
        '<test escaped="chars &lt;&gt;&apos;&quot;&amp;">complete 100%</test>' +
        '<cdata><![CDATA[<test att="val">this is a test</test>]]></cdata>' +
        '<raw>&<>&</raw>' +
      '</root>'

builder.begin('root')
  .ele('xmlbuilder')
    .att('for', 'node-js')
    .com('CoffeeScript is awesome.')
    .ele('repo')
      .att('type', 'git')
      .txt('git://github.com/oozcitak/xmlbuilder-js.git')
    .up()
  .up()
  .ele('test')
    .att('escaped', 'chars <>\'"&')
    .txt('complete 100%')
  .up()
  .ele('cdata')
    .cdata('<test att="val">this is a test</test>')
  .up()
  .ele('raw')
    .raw('&<>&')

test = builder.toString()
assert.strictEqual(xml, test)

builder.begin('root')
  .ele('xmlbuilder', {'for': 'node-js' })
    .com('CoffeeScript is awesome.')
    .ele('repo', {'type': 'git'}, 'git://github.com/oozcitak/xmlbuilder-js.git')
    .up()
  .up()
  .ele('test', {'escaped': 'chars <>\'"&'}, 'complete 100%')
  .up()
  .ele('cdata')
    .cdata('<test att="val">this is a test</test>')
  .up()
  .ele('raw')
    .raw('&<>&')

test = builder.toString()
assert.strictEqual(xml, test)

builder.begin('root')
  .e('xmlbuilder', {'for': 'node-js' })
    .c('CoffeeScript is awesome.')
    .e('repo', {'type': 'git'}, 'git://github.com/oozcitak/xmlbuilder-js.git')
    .u()
  .u()
  .e('test', {'escaped': 'chars <>\'"&'}, 'complete 100%')
  .u()
  .e('cdata')
    .d('<test att="val">this is a test</test>')
  .u()
  .e('raw')
    .r('&<>&')

test = builder.toString()
assert.strictEqual(xml, test)

