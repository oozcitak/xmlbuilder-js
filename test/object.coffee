vows = require 'vows'
assert = require 'assert'

xmlbuilder = require '../src/index.coffee'

vows
    .describe('Creating XML')
    .addBatch
        'From JS object (simple)':
            topic: () ->
                obj =
                    root:
                      xmlbuilder:
                        '@for': 'node-js'
                        repo:
                          '@type': 'git'
                          '#text': 'git://github.com/oozcitak/xmlbuilder-js.git'
    
                xmlbuilder.create(obj)

            'resulting XML': (topic) ->
                xml = '<?xml version="1.0"?>' +
                      '<root>' +
                          '<xmlbuilder for="node-js">' +
                            '<repo type="git">git://github.com/oozcitak/xmlbuilder-js.git</repo>' +
                          '</xmlbuilder>' +
                      '</root>'

                assert.strictEqual topic.end(), xml

        'From JS object (functions)':
            topic: () ->
                obj =
                    squares:
                      '#comment': 'f(x) = x^2'
                      '#list': () ->
                        ret = for i in [1..5]
                          { data: { '@x': i, '@y': i * i } }

    
                xmlbuilder.create(obj)

            'resulting XML': (topic) ->
                xml = '<?xml version="1.0"?>' +
                      '<squares>' +
                          '<!-- f(x) = x^2 -->' +
                          '<data x="1" y="1"/>' +
                          '<data x="2" y="4"/>' +
                          '<data x="3" y="9"/>' +
                          '<data x="4" y="16"/>' +
                          '<data x="5" y="25"/>' +
                      '</squares>'

                assert.strictEqual topic.end(), xml

        'From JS object (decorators)':
            topic: () ->
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
                        contact: [
                            { phone: "555-1234" }
                            { phone: "555-1235" }
                        ]
                        id: () -> return 42
                        details:
                          '#text': 'classified'
    
                xmlbuilder.create('root', { headless: true })
                    .ele(obj)
                        .up()
                    .ele('added')

            'resulting XML': (topic) ->
                xml = '<root>' +
                          '<ele>simple element</ele>' +
                          '<?pi mypi?>' +
                          '<person age="35">' +
                              '<name>John</name>' +
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

                assert.strictEqual topic.end(), xml

        'From JS object (ignore decorators)':
            topic: () ->
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
                        '#list': [
                            { phone: "555-1234" }
                            { phone: "555-1235" }
                        ]
                        id: () -> return 42
                        details:
                          '#text': 'classified'
    
                xmlbuilder.create('root', { headless: true, ignoreDecorators: true })
                    .ele(obj)
                        .up()
                    .ele('added')

            'resulting XML': (topic) ->
                xml = '<root>' +
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
                              '<#list>' +
                                  '<phone>555-1234</phone>' +
                                  '<phone>555-1235</phone>' +
                              '</#list>' +
                              '<id>42</id>' +
                              '<details><#text>classified</#text></details>' +
                          '</person>' +
                          '<added/>' +
                      '</root>'

                assert.strictEqual topic.end(), xml

        'From JS object (deep nesting)':
            topic: () ->
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
    
                xmlbuilder.create('root', { headless: true })
                    .ele(obj)

            'resulting XML': (topic) ->
                xml = '<root>' +
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

                assert.strictEqual topic.end(), xml

        'From JS object (root level)':
            topic: () ->
                obj =
                    myroot:
                        ele: "simple element"
                        person:
                            name: "John"
                            '@age': 35
                            address:
                                city: "Istanbul"
                                street: "End of long and winding road"
                            '#list': [ 
                                { phone: { '#text': "555-1234", '@type': 'home' } }
                                { phone: { '#text': "555-1235", '@type': 'mobile' } }
                            ]
                            id: () -> return 42
    
                xmlbuilder.create(obj, { headless: true })
                    .ele('added')

            'resulting XML': (topic) ->
                xml = '<myroot>' +
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

                assert.strictEqual topic.end(), xml

        'From JS object (simple array)':
            topic: () ->
                obj = [
                        "one"
                        "two"
                        () -> return "three"
                    ]
    
                xmlbuilder.create('root', { headless: true })
                    .ele(obj)

            'resulting XML': (topic) ->
                xml = '<root>' +
                          '<one/>' +
                          '<two/>' +
                          '<three/>' +
                      '</root>'

                assert.strictEqual topic.end(), xml

        'From JS object (empty array)':
            topic: () ->
                obj =
                    root: []
    
                xmlbuilder.create(obj)

            'resulting XML': (topic) ->
                xml = '<?xml version="1.0"?>' +
                      '<root/>'

                assert.strictEqual topic.end(), xml

        'From JS object (empty object)':
            topic: () ->
                obj =
                    root: {}
    
                xmlbuilder.create(obj)

            'resulting XML': (topic) ->
                xml = '<?xml version="1.0"?>' +
                      '<root/>'

                assert.strictEqual topic.end(), xml




    .export(module)

