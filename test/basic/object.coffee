suite 'Creating XML:', ->
  test 'From JS object (simple)', ->
    obj =
        root:
          xmlbuilder:
            '@for': 'node-js'
            repo:
              '@type': 'git'
              '#text': 'git://github.com/oozcitak/xmlbuilder-js.git'

    eq(
      xml(obj).end()
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

    eq(
      xml(obj).end()
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

    eq(
      xml('root', { headless: true })
        .ele(obj).up()
        .ele('added')
        .end()

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
          '<added/>' +
      '</root>'
    )

  test 'From JS object (ignore decorators)', ->
    obj =
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

    eq(
      xml('root', { headless: true, ignoreDecorators: true })
        .ele(obj).up()
        .ele('added')
        .end()

      '<root>' +
          '<ele>simple element</ele>' +
          '<person>' +
              '<name>John</name>' +
              '<@age>35</@age>' +
              '<?pi>mypi</?pi>' +
              '<#comment>Good guy</#comment>' +
              '<#cdata>well formed!</#cdata>' +
              '<unescaped><#raw>&amp;&lt;&gt;&amp;</#raw></unescaped>' +
              '<address>' +
                  '<city>Istanbul</city>' +
                  '<street>End of long and winding road</street>' +
              '</address>' +
              '<phone>555-1234</phone>' +
              '<phone>555-1235</phone>' +
              '<id>42</id>' +
              '<details><#text>classified</#text></details>' +
          '</person>' +
          '<added/>' +
      '</root>'
    )

  test 'From JS object (deep nesting)', ->
    obj =
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

    eq(
      xml('root', { headless: true }).ele(obj).end()
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

    eq(
      xml(obj, { headless: true }).ele('added').end()
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
          '<added/>' +
      '</myroot>'
    )

  test 'From JS object (simple array)', ->
    obj = [
            "one"
            "two"
            () -> return "three"
        ]

    eq(
      xml('root', { headless: true }).ele(obj).end()
      '<root>' +
          '<one/>' +
          '<two/>' +
          '<three/>' +
      '</root>'
    )

  test 'From JS object (empty array)', ->
    eq(
      xml({ root: [] }).end()
      '<?xml version="1.0"?><root/>'
    )

  test 'From JS object (empty object)', ->
    eq(
      xml({ root: {} }).end()
      '<?xml version="1.0"?><root/>'
    )

