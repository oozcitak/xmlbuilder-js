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
