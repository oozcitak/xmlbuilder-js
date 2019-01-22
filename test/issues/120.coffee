suite 'Tests specific to issues:', ->
  test 'toString or end with arguments sets writer forever. Issue 157', ->
    str1 = xml('root').ins('a', 'b').ele('xmlbuilder').end()
    xml('root').ins('a', 'b').ele('xmlbuilder').end({ pretty: true, spacebeforeslash: '  ' })
    str2 = xml('root').ins('a', 'b').ele('xmlbuilder').end()
    eq(str1, str2)
