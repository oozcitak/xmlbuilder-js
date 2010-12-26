var xml = '<root>' +
            '<xmlbuilder for="node-js" awesome="CoffeeScript">' +
              '<repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>' +
            '</xmlbuilder>' +
            '<test>complete</test>' +
          '</root>';

var builder = require('../lib/index.js').builder();
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
.ele('test')
  .txt('complete');
var test = builder.toString();

var assert = require('assert');
assert.ok(xml === test);

