# xmlbuilder-js

An XMLBuilder for [node.js](http://nodejs.org/) similar to 
[java-xmlbuilder](http://code.google.com/p/java-xmlbuilder/).

### Installation:

``` sh
npm install xmlbuilder
```

### Important:

I had to break compatibility while adding multiple instances in 0.1.3. 
As a result, version from v0.1.3 are **not** compatible with previous versions.

### Usage:

``` js
var builder = require('xmlbuilder');
var doc = builder.create();

doc.begin('root')
  .ele('xmlbuilder')
    .att('for', 'node-js')
    .ele('repo')
      .att('type', 'git')
      .txt('git://github.com/oozcitak/xmlbuilder-js.git') 
    .up()
  .up()
  .ele('test')
    .txt('complete');
    
console.log(doc.toString({ pretty: true }));
```

will result in:

``` xml
<root>
  <xmlbuilder for="node-js">
    <repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>
  </xmlbuilder>
  <test>complete</test>
</root>
```

If you need to do some processing:

``` js
var root = doc.begin('squares');
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
