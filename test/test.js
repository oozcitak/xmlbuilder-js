assert = require('assert');

var builder = require('../lib/index.js').builder();
var xml = '<root>' +
            '<xmlbuilder for="node-js" awesome="CoffeeScript">' +
              '<repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>' +
            '</xmlbuilder>' +
	    '<cdata><![CDATA[<test>this is a test</test>]]></cdata>' +
	    '<test>complete</test>' +
          '</root>';

builder.begin('root')
  .ele('xmlbuilder')
    .att('for', 'node-js')
    .att('awesome', 'CoffeeScript')
    .ele('repo')
      .att('type', 'git')
      .txt('git://github.com/oozcitak/xmlbuilder-js.git')	
    .up()
  .up()
.up()
.ele('cdata')
  .txt('<![CDATA[<test>this is a test</test>]]>')
  .up()
.up()
.ele('test')
  .txt('complete');


var test = builder.toString();
assert.strictEqual(xml, test);

