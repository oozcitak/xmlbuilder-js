suite 'XPath:', ->
  test 'Evaluate', ->
    doc = xml('book').ele('title').txt('Harry Potter').doc()
    nodes = xpath.evaluate('//title', doc, null, xpath.XPathResult.ANY_TYPE, null).nodes

    eq(nodes[0].localName, "title")
    eq(nodes[0].firstChild.data, "Harry Potter")
    eq(nodes[0].toString(), "<title>Harry Potter</title>")

  test 'Select', ->
    doc = builder.begin()
      .ins('book', 'title="Harry Potter"')
      .ins('series', 'title="Harry Potter"')
      .ins('series', 'books="7"')
      .ele('root')
      .com('This is a great book')
      .ele('title')
      .txt('Harry Potter')
      .document()

    nodes = xpath.select('//title', doc)
    nodes2 = xpath.select('//node()', doc)
    pis = xpath.select("/processing-instruction('series')", doc)

    eq(nodes[0].localName, 'title')
    eq(nodes[0].firstChild.data, 'Harry Potter')
    eq(nodes[0].toString(), '<title>Harry Potter</title>')
    
    eq(nodes2.length, 7)
    
    eq(pis.length, 2)
    eq(pis[1].data, 'books="7"')

  test 'Select single node', ->
    doc = xml('book').ele('title').txt('Harry Potter').doc()
    eq(xpath.select('//title[1]', doc)[0].localName, 'title')

  test 'Select text node', ->
    doc = xml('book').ele('title').txt('Harry').up().ele('title').txt('Potter').doc()
    eq(xpath.select('local-name(/book)', doc), 'book')
    eq(xpath.select('//title/text()', doc).toString(), 'Harry,Potter')

  test 'Select number value', ->
    doc = xml('book').ele('title').txt('Harry').up().ele('title').txt('Potter').doc()
    eq(xpath.select('count(//title)', doc), 2)

  test 'Select attribute', -> 
    doc = xml('author').att('name', 'J. K. Rowling').doc()
    author = xpath.select1('/author/@name', doc).value
    eq(author, 'J. K. Rowling');

  test 'Select with multiple predicates', ->
    doc = xml('characters')
      .ele('character', { name: "Snape", sex: "M", age: "50" }).up()
      .ele('character', { name: "McGonnagal", sex: "F", age: "65" }).up()
      .doc()

    characters = xpath.select('/*/character[@sex = "M"][@age > 40]/@name', doc)

    eq(characters.length, 1)
    eq(characters[0].textContent, 'Snape')
