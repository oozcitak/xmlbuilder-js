# xmlbuilder-js

An XMLBuilder for [node.js](http://nodejs.org/) similar to [java-xmlbuilder](http://code.google.com/p/java-xmlbuilder/).

### Installation:

    npm install xmlbuilder

### Usage:

    var builder = require('xmlbuilder').builder();
    
    builder.begin()
      .ele('root')
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
    
    console.log(builder.toString({ pretty: true });

will result in:

    <root>
      <xmlbuilder for="node-js" awesome="CoffeeScript">
        <repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>
      </xmlbuilder>
      <test>complete</test>
    </root>

If you need to do some processing:

    var root = builder.begin().ele('root');
    for(var i = 1; i < 5; i++)
      root.ele('item-' + i);

This will result in:

    <root>
      <item-1/>
      <item-2/>
      <item-3/>
      <item-4/>
    </root>

