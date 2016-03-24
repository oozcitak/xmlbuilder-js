suite 'Creating XML:', ->
  test 'begin()', ->
    eq(
      doc({ headless: true }).ele('root', { att: 'val' }).ele('test').end()
      '<root att="val"><test/></root>'
    )

  test 'begin() with prolog', ->
    eq(
      doc().dec().dtd().up().ele('root').end()
      '<?xml version="1.0"?><!DOCTYPE root><root/>'
    )
