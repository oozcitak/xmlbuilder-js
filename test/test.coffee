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

# test escape of "
xml8 = '<test8><node>&quot;</node></test8>'
test8 = builder.begin('test8')
      .ele('node', '"')
      .doc().toString()
assert.strictEqual(xml8, test8)

# Test text node with empty string
xml9 = '<test9></test9>'
test9 = builder.begin('test9').text('')
  .doc().toString()
assert.strictEqual(xml9, test9)

# Test the clone() method (not deep clone)
xml10 = '<test10><nodes><node>1</node></nodes></test10>'
xml10cloned = '<test10><added>3</added></test10>'
test10 = builder.begin('test10')
      .ele('nodes',)
        .ele('node', '1')
        .root()
test10cloned = test10.root().clone()
test10cloned.ele('added', '3')
assert.strictEqual(xml10cloned, test10cloned.toString())
assert.strictEqual(xml10, test10.doc().toString())

# Test the clone() method (deep clone)
xml11 = '<test11><nodes><node>1</node><node>2</node></nodes></test11>'
xml11cloned = '<test11><nodes><node>1</node><node>2</node></nodes><added>3</added></test11>'
test11 = builder.begin('test11')
      .ele('nodes',)
        .ele('node', '1').up()
        .ele('node', '2')
        .root()
test11cloned = test11.root().clone(true)
test11cloned.ele('added', '3')
assert.strictEqual(xml11cloned, test11cloned.toString())
assert.strictEqual(xml11, test11.doc().toString())

# Test the importXMLBuilder() method
xml12 = '<test12><test12imported><node>imported</node></test12imported></test12>'
test12imported = xmlbuilder.create().begin('test12imported')
      .ele('node', 'imported')
      .doc()
test12 = builder.begin('test12')
      .importXMLBuilder(test12imported)
      .doc().toString()
assert.strictEqual(xml12, test12)

# Test the create() method with arguments
xml13 = '<?xml version="1.0"?><test13><node>test</node></test13>'
test13 = xmlbuilder.create('test13').ele('node').txt('test').doc().toString()
assert.strictEqual(xml13, test13)

# Test the create() method with arguments
xml14 = '<?xml version="1.1"?><test14><node>test</node></test14>'
test14 = xmlbuilder.create('test14', { 'version': '1.1' } ).ele('node').txt('test').doc().toString()
assert.strictEqual(xml14, test14)

# Test the end() method
xml15 = '<?xml version="1.1"?><test14><node>test</node></test14>'
test15 = xmlbuilder.create('test14', { 'version': '1.1' } ).ele('node').txt('test').end()
assert.strictEqual(xml15, test15)

# Test the use of surrogate pair characters
stringWithIssues = '𡬁𠻝𩂻耨鬲, 㑜䊑㓣䟉䋮䦓, ᡨᠥ᠙ᡰᢇ᠘ᠶ, ࿋ཇ࿂ོ༇ྒ, ꃌꈗꈉꋽ, Uighur, ᥗᥩᥬᥜᥦ '
makeXml = (xmlbuilder) ->
  xmlbuilder.create('test15', {'version': '1.1'}).ele('node').txt(stringWithIssues).end()

assert.throws () -> makeXml(xmlbuilder) Error

# if this doesn't throw we're good
makeXml xmlbuilder.withopts({allowSurrogateChars: true})
