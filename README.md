# xmlbuilder-js

An XMLBuilder for [node.js](http://nodejs.org/) similar to [java-xmlbuilder](http://code.google.com/p/java-xmlbuilder/).

### Installation:

``` sh
npm install xmlbuilder
```

### Usage:

``` js
var builder = require('xmlbuilder');
    
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
    
console.log(builder.toString({ pretty: true });
```

will result in:

``` xml
<root>
  <xmlbuilder for="node-js" awesome="CoffeeScript">
    <repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>
  </xmlbuilder>
  <test>complete</test>
</root>
```

If you need to do some processing:

``` js
var root = builder.begin('squares');
root.com('f(x) = x^2');
for(var i = 1; i <= 5; i++)
{
  var item = root.ele('data');
  item.att('x', i);
  item.att('y', i * i);
}
```

This will result in:

``` xml
<squares>
  <!-- f(x) = x^2 -->
  <data x="1" y="1"/>
  <data x="2" y="4"/>
  <data x="3" y="9"/>
  <data x="4" y="16"/>
  <data x="5" y="25"/>
</squares>
```
