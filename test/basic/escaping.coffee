suite 'Text Processing', ->
  test 'Escaping element value', ->
    eq(
      xml('root', { headless: true })
        .ele('e', 'escaped <>\'"&\t\n').up()
        .ele('e', 'escaped <>\'"&\t\r\n').up()
        .ele('e', 'escaped <>\'"&\t\n\r').up()
        .ele('e')
          .att('a1', 'escaped <>\'"&\t\n')
          .att('a2', 'escaped <>\'"&\t\r')
          .att('a3', 'escaped <>\'"&\t\n\r')
          .att('a4', 'escaped <>\'"&\t\r\n')
        .up()
      .end()

      '<root>' +
        '<e>escaped &lt;&gt;\'"&amp;\t\n</e>' +
        '<e>escaped &lt;&gt;\'"&amp;\t&#xD;\n</e>' +
        '<e>escaped &lt;&gt;\'"&amp;\t\n&#xD;</e>' +
        '<e' +
          ' a1="escaped &lt;>\'&quot;&amp;&#x9;&#xA;"' +
          ' a2="escaped &lt;>\'&quot;&amp;&#x9;&#xD;"' +
          ' a3="escaped &lt;>\'&quot;&amp;&#x9;&#xA;&#xD;"' +
          ' a4="escaped &lt;>\'&quot;&amp;&#x9;&#xD;&#xA;"' +
        '/>' +
      '</root>'
    )

