suite 'Tests specific to issues:', ->
  test 'ReDos', ->
    eq(
      xml('root', {encoding: 'UTF-8'}).end()
      '<?xml version="1.0" encoding="UTF-8"?><root/>'
    )

    err(
      () -> xml('root', {encoding: 'A------------------------------------!'})
      /Invalid encoding: A------------------------------------!/
    )


