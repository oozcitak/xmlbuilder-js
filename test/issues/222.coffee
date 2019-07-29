suite 'Tests specific to issues:', ->
  test 'Issue #222: Cant remove attribute heired from root', ->

    uuid = "24ff5e22-09af-42cc-aaf6-b475137e6304"
    xml = builder.begin({ encoding: 'utf-8' }).ele({
        "AuthnRequest": {
          "@ID": uuid,
          "@Version": "2.0",
          "@IssueInstant": "2019-07-28T18:02:19.511Z",
          "@Destination": "https://autenticacao.gov.pt/fa/Default.aspx",
          "@ProtocolBinding": "urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST",
          "@AssertionConsumerServiceURL": "http://clav-auth.di.uminho.pt/assertion",
          "@ProviderName": "CLAV",
          "@xmlns":"urn:oasis:names:tc:SAML:2.0:protocol",
          "@xmlns:xsi":"http://www.w3.org/2001/XMLSchema-instance",
          "@xmlns:xsd":"http://www.w3.org/2001/XMLSchema",
          "@Consent":"urn:oasis:names:tc:SAML:2.0:consent:unspecified" 
        }
      }).ele(
        "Issuer", {
          "xmlns": "urn:oasis:names:tc:SAML:2.0:assertion"
        }, "http://clav-auth.di.uminho.pt"
      ).up().ele(
        "Extensions"
      ).ele(
        "fa:RequestedAttributes", {
          "xmlns:fa": "http://autenticacao.cartaodecidadao.pt/atributos"
        }
      ).ele(
        "fa:RequestedAttribute", {
          "Name": "http://interop.gov.pt/MDC/Cidadao/NIC", "NameFormat": "urn:oasis:names:tc:SAML:2.0:attrname-format:uri"
        }
      )
    .end({ pretty: true })

    eq(
      xml

      """
      <AuthnRequest ID="24ff5e22-09af-42cc-aaf6-b475137e6304" Version="2.0" IssueInstant="2019-07-28T18:02:19.511Z" Destination="https://autenticacao.gov.pt/fa/Default.aspx" ProtocolBinding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST" AssertionConsumerServiceURL="http://clav-auth.di.uminho.pt/assertion" ProviderName="CLAV" xmlns="urn:oasis:names:tc:SAML:2.0:protocol" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" Consent="urn:oasis:names:tc:SAML:2.0:consent:unspecified">
        <Issuer xmlns="urn:oasis:names:tc:SAML:2.0:assertion">http://clav-auth.di.uminho.pt</Issuer>
        <Extensions>
          <fa:RequestedAttributes xmlns:fa="http://autenticacao.cartaodecidadao.pt/atributos">
            <fa:RequestedAttribute Name="http://interop.gov.pt/MDC/Cidadao/NIC" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:uri"/>
          </fa:RequestedAttributes>
        </Extensions>
      </AuthnRequest>
      """
    )



