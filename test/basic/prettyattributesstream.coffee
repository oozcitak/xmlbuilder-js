suite 'Creating XML with stream writer:', ->
  hook = null
  setup 'hook stdout.write', ->
    hook = captureStream(process.stdout)
    return
  teardown 'unhook stdout.write', ->
    hook.unhook()
    return
    
  test 'Pretty print attributes - 1', ->
    xml('test', { headless: true })
      .ele('node', {"first":"1", "second":"2"})
      .end(builder.streamWriter(process.stdout, { pretty: true, width: 20 }))
    eq(
      hook.captured()
      """
      <test>
        <node first="1"
          second="2"/>
      </test>
      """
    )

  test 'Pretty print attributes - 2', ->
    xml('test', { headless: true })
      .ele('node', {"first":"1", "second":"2", "third":"33333333333333333333", "fourth": 4})
      .end(builder.streamWriter(process.stdout, { pretty: true, width: 10 }))
    eq(
      hook.captured()
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
    xml('test', { headless: true })
      .ele('node', {"first":"1", "second":"2", "third":"33333333333333333333", "fourth": 4})
      .end(builder.streamWriter(process.stdout, { pretty: true, width: 1 }))
    eq(
      hook.captured()
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
    xml('test', { headless: true })
      .ele('node', {"first":"1", "second":"2"}).ele('child')
      .end(builder.streamWriter(process.stdout, { pretty: true, width: 10 }))
    eq(
      hook.captured()
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
