x = require './src/index.coffee'

xml = x.create('hello')
  .ele('element')
  .ins('xml-stylesheet', 'type="text/xsl" href="style.xsl"')
console.log xml.end({pretty:true})
