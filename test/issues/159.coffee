suite 'Tests specific to issues:', ->
  test 'multiple elements with different values. Issue 159', ->
    obj = {
      'mdui:UIInfo': {
        "mdui:DisplayName": [
          { "@xml:lang": "de", "#text": "AAA" }
          { "@xml:lang": "en", "#text": "BBB" }
        ]
      }
    }

    eq(
      xml(obj, { headless: true }).end()

      '<mdui:UIInfo>' +
        '<mdui:DisplayName xml:lang="de">AAA</mdui:DisplayName>' +
        '<mdui:DisplayName xml:lang="en">BBB</mdui:DisplayName>' +
      '</mdui:UIInfo>'
    )


  test 'nested array. Issue 159', ->
    obj = {
        "category": {
            "@category-id": "twe-root",
            "display-name": {
                "#text": "Root",
                "@xml:lang": "x-default"
            },
            "description": {
                "#text": "Master Catalogue for Treasury Wines",
                "@xml:lang": "x-default"
            },
            "online-flag": {
                "#text": true
            },
            "attribute-groups": [{
                "attribute-group": {
                    "@group-id": "wine",
                    "display-name": {
                        "#text": "Wine Attributes",
                        "@xml:lang": "x-default"
                    },
                    "attribute": [{
                        "@attribute-id": "wineContentChannels",
                        "@system": false
                    },
                    {
                        "@attribute-id": "wineTastingNotesPDF",
                        "@system": false
                    },
                    {
                        "@attribute-id": "wineCOGS",
                        "@system": false
                    },
                    {
                        "@attribute-id": "wineCollection",
                        "@system": false
                    },
                    {
                        "@attribute-id": "wineType",
                        "@system": false
                    },
                    {
                        "@attribute-id": "wineVariety",
                        "@system": false
                    },
                    {
                        "@attribute-id": "wineBottleType",
                        "@system": false
                    },
                    {
                        "@attribute-id": "wineVintage",
                        "@system": false
                    }
                    ]
                }
            },
            {
                "attribute-group": {
                    "@group-id": "coreProduct",
                    "display-name": {
                        "#text": "Core Product Attributes",
                        "@xml:lang": "x-default"
                    },
                    "attribute": [{
                        "@attribute-id": "csrOnly",
                        "@system": false
                    }]
                }
            }
            ]
        }
    }
    
    eq(
      xml(obj, { headless: true }).end({ pretty: true })

      """
      <category category-id="twe-root">
        <display-name xml:lang="x-default">Root</display-name>
        <description xml:lang="x-default">Master Catalogue for Treasury Wines</description>
        <online-flag>true</online-flag>
        <attribute-groups>
          <attribute-group group-id="wine">
            <display-name xml:lang="x-default">Wine Attributes</display-name>
            <attribute attribute-id="wineContentChannels" system="false"/>
            <attribute attribute-id="wineTastingNotesPDF" system="false"/>
            <attribute attribute-id="wineCOGS" system="false"/>
            <attribute attribute-id="wineCollection" system="false"/>
            <attribute attribute-id="wineType" system="false"/>
            <attribute attribute-id="wineVariety" system="false"/>
            <attribute attribute-id="wineBottleType" system="false"/>
            <attribute attribute-id="wineVintage" system="false"/>
          </attribute-group>
        </attribute-groups>
        <attribute-groups>
          <attribute-group group-id="coreProduct">
            <display-name xml:lang="x-default">Core Product Attributes</display-name>
            <attribute attribute-id="csrOnly" system="false"/>
          </attribute-group>
        </attribute-groups>
      </category>
      """
    )