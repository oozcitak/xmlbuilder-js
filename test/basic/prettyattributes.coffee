suite 'Creating XML with string writer:', ->
  test 'Pretty print attributes - 1', ->
    eq(
      xml('test', { headless: true })
        .ele('node', {"first":"1", "second":"2"})
        .end({ pretty: true, width: 20 })
      """
      <test>
        <node first="1"
          second="2"/>
      </test>
      """
    )

  test 'Pretty print attributes - 2', ->
    eq(
      xml('test', { headless: true })
        .ele('node', {"first":"1", "second":"2", "third":"33333333333333333333", "fourth": 4})
        .end({ pretty: true, width: 10 })
      """
      <test>
        <node
          first="1"
          second="2"
          third="33333333333333333333"
          fourth="4"/>
      </test>
      """
    )

  test 'Pretty print attributes - 3', ->
    eq(
      xml('test', { headless: true })
        .ele('node', {"first":"1", "second":"2", "third":"33333333333333333333", "fourth": 4})
        .end({ pretty: true, width: 1 })
      """
      <test>
        <node
          first="1"
          second="2"
          third="33333333333333333333"
          fourth="4"/>
      </test>
      """
    )

  test 'Pretty print attributes - 4', ->
    eq(
      xml('test', { headless: true })
        .ele('node', {"first":"1", "second":"2"}).ele('child')
        .end({ pretty: true, width: 10 })
      """
      <test>
        <node
          first="1"
          second="2">
          <child/>
        </node>
      </test>
      """
    )
