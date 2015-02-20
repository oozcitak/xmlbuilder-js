suite 'Creating XML:', ->
  test 'Multiple Instances', ->
  
    xml1 = xml('first').ele('node1', { 'testatt1': 'testattval1' }, 'text1')
    eq(
      xml1.end()
      '<?xml version="1.0"?><first><node1 testatt1="testattval1">text1</node1></first>'
    )
    
    xml2 = xml('second').ele('node2', { 'testatt2': 'testattval2' }, 'text2')
    eq(
      xml2.end()
      '<?xml version="1.0"?><second><node2 testatt2="testattval2">text2</node2></second>'
    )
    
    # First instance should remain unchanged
    eq(
      xml1.end()
      '<?xml version="1.0"?><first><node1 testatt1="testattval1">text1</node1></first>'
    )

