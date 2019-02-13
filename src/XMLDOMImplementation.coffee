# Implements the DOMImplementation interface
module.exports = class XMLDOMImplementation


  # Tests if the DOM implementation implements a specific feature.
  #
  # `feature` The package name of the feature to test. In Level 1, the
  #           legal values are "HTML" and "XML" (case-insensitive).
  # `version` This is the version number of the package name to test. 
  #           In Level 1, this is the string "1.0". If the version is 
  #           not specified, supporting any version of the feature will 
  #           cause the method to return true.
  hasFeature: (feature, version) ->
    if feature.toUpper() is "XML" and version is "1.0"
      return true

    return false
