suite 'Tests specific to issues:', ->
  test 'Issue #93 (Auto-generating arrays)', ->
    obj =
        root:
            Title:
                '@lang': 'eng'
                '#text': 'Show Title'
            Cast: [
                {
                    '@role': 'Host'
                    '#text': 'Interview Person'
                }
                {
                    '@role': 'Guest'
                    '#text': 'Guest Person'
                }
            ]
            Category: [
                {
                    '@lang': 'eng'
                    '@type': 'B23'
                    '#text': 'Game Show'
                }
                {
                    '@lang': 'eng'
                    '@type': 'C34'
                    '#text': 'Family'
                }
                {
                    '@lang': 'eng'
                    '@type': 'B23'
                    '#text': 'Topical'
                }
            ]

    eq(
      xml(obj).end()
      '<?xml version="1.0"?>' +
      '<root>' +
        '<Title lang="eng">Show Title</Title>' +
        '<Cast role="Host">Interview Person</Cast>' +
        '<Cast role="Guest">Guest Person</Cast>' +
        '<Category lang="eng" type="B23">Game Show</Category>' +
        '<Category lang="eng" type="C34">Family</Category>' +
        '<Category lang="eng" type="B23">Topical</Category>' +
      '</root>'
    )

