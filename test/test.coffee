assert = require('assert')
xmlbuilder = require '../src/index.coffee'

# Test XML
xml = '<root>' +
        '<xmlbuilder for="node-js">' +
          '<!-- CoffeeScript is awesome. -->' +
          '<repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>' +
        '</xmlbuilder>' +
        '<test escaped="chars &lt;&gt;&apos;&quot;&amp;">complete 100%</test>' +
        '<cdata><![CDATA[<test att="val">this is a test</test>\nSecond line]]></cdata>' +
        '<raw>&<>&</raw>' +
        '<atttest att="val">text</atttest>' +
        '<atttest>text</atttest>' +
      '</root>'

# Test long form
builder = xmlbuilder.create()
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
    .cdata('<test att="val">this is a test</test>\nSecond line')
  .up()
  .ele('raw')
    .raw('&<>&')
    .up()
  .ele('atttest', { 'att': 'val' }, 'text')
    .up()
  .ele('atttest', 'text')

test = builder.toString()
assert.strictEqual(xml, test)

# Test long form with attributes
builder.begin('root')
  .ele('xmlbuilder', {'for': 'node-js' })
    .com('CoffeeScript is awesome.')
    .ele('repo', {'type': 'git'}, 'git://github.com/oozcitak/xmlbuilder-js.git')
    .up()
  .up()
  .ele('test', {'escaped': 'chars <>\'"&'}, 'complete 100%')
  .up()
  .ele('cdata')
    .cdata('<test att="val">this is a test</test>\nSecond line')
  .up()
  .ele('raw')
    .raw('&<>&')
    .up()
  .ele('atttest', { 'att': 'val' }, 'text')
    .up()
  .ele('atttest', 'text')

test = builder.toString()
assert.strictEqual(xml, test)

# Test short form
builder.begin('root')
  .e('xmlbuilder', {'for': 'node-js' })
    .c('CoffeeScript is awesome.')
    .e('repo', {'type': 'git'}, 'git://github.com/oozcitak/xmlbuilder-js.git')
    .u()
  .u()
  .e('test', {'escaped': 'chars <>\'"&'}, 'complete 100%')
  .u()
  .e('cdata')
    .d('<test att="val">this is a test</test>\nSecond line')
  .u()
  .e('raw')
    .r('&<>&')
    .u()
  .e('atttest', { 'att': 'val' }, 'text')
    .u()
  .e('atttest', 'text')

test = builder.toString()
assert.strictEqual(xml, test)

# Test multiple instances
xml2 = '<test2><node>second instance</node></test2>'
builder2 = xmlbuilder.create()
builder2.begin('test2')
  .ele('node', 'second instance')
test2 = builder2.toString()
assert.strictEqual(xml2, test2)

# First instance should remain unchanged
test1 = builder.toString()
assert.strictEqual(xml, test1)

# Remove item
xml3 = '<test3><node>first instance</node><node>third instance</node></test3>'
builder.begin('test3')
  .e('node', 'first instance')
  .u()
  .e('node', 'second instance')
  .remove()
  .e('node', 'third instance')

test3 = builder.toString()
assert.strictEqual(xml3, test3)

# Remove attribute
xml4 = '<test4><node first="1" third="3">element</node></test4>'
root = builder.begin('test4')
ele = root.e('node', 'element', {"first":"1", "second":"2", "third":"3"})
ele.removeAttribute("second")
test4 = builder.toString()
assert.strictEqual(xml4, test4)

# Prev/next/root
xml5 = '<test5 root="yes"><node prev="yes">1</node><node>element</node><node next="yes">2</node></test5>'
builder.begin('test5')
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
test5 = builder.toString()
assert.strictEqual(xml5, test5)

# Insert
xml6 = '<test6><node>1</node><node>2</node><node>last</node></test6>'
builder.begin('test6')
  .e('node','last')
  .insertBefore('node','1')
  .insertAfter('node','2')
test6 = builder.toString()
assert.strictEqual(xml6, test6)

# Test the doc() method
xml7 = '<test7><nodes><node>1</node><node>2</node><node>3</node></nodes></test7>'
test7 = builder.begin('test7')
      .ele('nodes',)
        .ele('node', '1').up()
        .ele('node', '2').up()
        .ele('node', '3')
        .doc().toString()
assert.strictEqual(xml7, test7)

# Test text node with empty string
xml9 = '<test9></test9>'
test9 = builder.begin('test9').text('')
  .doc().toString()
assert.strictEqual(xml9, test9)
