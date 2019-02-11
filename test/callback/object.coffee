suite 'Creating XML using begin() callbacks:', ->
  
  result = ''
  data = (chunk, level) ->
    result += chunk
  
  test 'From JS object (simple)', ->
    obj =
        root:
          xmlbuilder:
            '@for': 'node-js'
            repo:
              '@type': 'git'
              '#text': 'git://github.com/oozcitak/xmlbuilder-js.git'

    result = ''
    doc(data).dec().ele(obj).end()

    eq(
      result

      '<?xml version="1.0"?>' +
      '<root>' +
          '<xmlbuilder for="node-js">' +
            '<repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>' +
          '</xmlbuilder>' +
      '</root>'
    )
  
  test 'From JS object (functions)', ->
    obj =
        squares:
          '#comment': 'f(x) = x^2'
          'data': () ->
            ret = for i in [1..5]
              { '@x': i, '@y': i * i }

    result = ''
    doc(data).dec().ele(obj).end()

    eq(
      result

      '<?xml version="1.0"?>' +
      '<squares>' +
          '<!-- f(x) = x^2 -->' +
          '<data x="1" y="1"/>' +
          '<data x="2" y="4"/>' +
          '<data x="3" y="9"/>' +
          '<data x="4" y="16"/>' +
          '<data x="5" y="25"/>' +
      '</squares>'
    )
  
  test 'From JS object (decorators)', ->
    obj = 
      root:
        ele: "simple element"
        person:
            name: "John"
            '@age': 35
            '?pi': 'mypi'
            '#comment': 'Good guy'
            '#cdata': 'well formed!'
            unescaped:
              '#raw': '&<>&'
            address:
                city: "Istanbul"
                street: "End of long and winding road"
            contact:
                phone: [ "555-1234", "555-1235" ]
            id: () -> return 42
            details:
              '#text': 'classified'

    result = ''
    doc(data).ele(obj).end()

    eq(
      result

      '<root>' +
          '<ele>simple element</ele>' +
          '<person age="35">' +
              '<name>John</name>' +
              '<?pi mypi?>' +
              '<!-- Good guy -->' +
              '<![CDATA[well formed!]]>' +
              '<unescaped>&<>&</unescaped>' +
              '<address>' +
                  '<city>Istanbul</city>' +
                  '<street>End of long and winding road</street>' +
              '</address>' +
              '<contact>' +
                  '<phone>555-1234</phone>' +
                  '<phone>555-1235</phone>' +
              '</contact>' +
              '<id>42</id>' +
              '<details>classified</details>' +
          '</person>' +
      '</root>'
    )

  test 'From JS object (ignore decorators)', ->
    obj =
      root:
        ele: "simple element"
        person:
            name: "John"
            '@age': 35
            '?pi': 'mypi'
            '#comment': 'Good guy'
            '#cdata': 'well formed!'
            unescaped:
              '#raw': '&<>&'
            address:
                city: "Istanbul"
                street: "End of long and winding road"
            phone: [
                "555-1234"
                "555-1235"
            ]
            id: () -> return 42
            details:
              '#text': 'classified'

    result = ''
    doc({ ignoreDecorators: true, noValidation: true }, data).ele(obj).end()

    eq(
      result

      '<root>' +
          '<ele>simple element</ele>' +
          '<person>' +
              '<name>John</name>' +
              '<@age>35</@age>' +
              '<?pi>mypi</?pi>' +
              '<#comment>Good guy</#comment>' +
              '<#cdata>well formed!</#cdata>' +
              '<unescaped><#raw>&<>&</#raw></unescaped>' +
              '<address>' +
                  '<city>Istanbul</city>' +
                  '<street>End of long and winding road</street>' +
              '</address>' +
              '<phone>555-1234</phone>' +
              '<phone>555-1235</phone>' +
              '<id>42</id>' +
              '<details><#text>classified</#text></details>' +
          '</person>' +
      '</root>'
    )

  test 'From JS object (deep nesting)', ->
    obj =
      root:
        one:
          '@val': 1
          two:
            '@val': 2
            three:
              '@val': 3
              four:
                '@val': 4
                five:
                  '@val': 5
                  six:
                    '@val': 6
                    ends: 'here'

    result = ''
    doc(data).ele(obj).end()

    eq(
      result

      '<root>' +
          '<one val="1">' +
            '<two val="2">' +
              '<three val="3">' +
                '<four val="4">' +
                  '<five val="5">' +
                    '<six val="6">' +
                      '<ends>here</ends>' +
                    '</six>' +
                  '</five>' +
                '</four>' +
              '</three>' +
            '</two>' +
          '</one>' +
      '</root>'
    )

  test 'From JS object (root level)', ->
    obj =
        myroot:
            ele: "simple element"
            person:
                name: "John"
                '@age': 35
                address:
                    city: "Istanbul"
                    street: "End of long and winding road"
                phone: [
                    { '#text': "555-1234", '@type': 'home' }
                    { '#text': "555-1235", '@type': 'mobile' }
                ]
                id: () -> return 42

    result = ''
    doc(data).ele(obj).end()

    eq(
      result

      '<myroot>' +
          '<ele>simple element</ele>' +
          '<person age="35">' +
              '<name>John</name>' +
              '<address>' +
                  '<city>Istanbul</city>' +
                  '<street>End of long and winding road</street>' +
              '</address>' +
              '<phone type="home">555-1234</phone>' +
              '<phone type="mobile">555-1235</phone>' +
              '<id>42</id>' +
          '</person>' +
      '</myroot>'
    )
  
  test 'From JS object (simple array)', ->
    obj = [
            "one"
            "two"
            () -> return "three"
        ]

    result = ''
    doc(data).ele('root').ele(obj).end()

    eq(
      result

      '<root>' +
          '<one/>' +
          '<two/>' +
          '<three/>' +
      '</root>'
    )
  
  test 'From JS object (empty array should produce no nodes)', ->
    result = ''
    doc(data).ele('root').ele({ item: [] }).end()

    eq(
      result
      '<root/>'
    )

  test 'From JS object (empty array should produce one node if separateArrayItems is set)', ->
    result = ''
    doc({ separateArrayItems: true }, data).ele('root').ele({ item: [] }).end()

    eq(
      result
      '<root><item/></root>'
    )

  test 'From JS object (empty object should produce one node)', ->
    result = ''
    doc(data).ele('root').ele({ item: {} }).end()

    eq(
      result
      '<root><item/></root>'
    )

  test 'From JS object (empty array with empty object should produce one node)', ->
    result = ''
    doc(data).ele('root').ele({ item: [{}] }).end()

    eq(
      result
      '<root><item/></root>'
    )

  test 'From JS object (null should produce no nodes)', ->
    result = ''
    doc(data).ele('root').ele({ item: null }).end()

    eq(
      result
      '<root/>'
    )
  