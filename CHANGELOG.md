# Change Log

## [5.0.0] - 2016-03-06
- Added text case option for element names and attribute names. Valid cases are `lower`, `upper`, `camel`, `kebab` and `snake`.
- Attribute and element values are escaped according to the [Canonical XML 1.0 specification](http://www.w3.org/TR/2000/WD-xml-c14n-20000119.html#charescaping). See [#54](https://github.com/oozcitak/xmlbuilder-js/issues/54) and [#86](https://github.com/oozcitak/xmlbuilder-js/issues/86).
- Added the `allowEmpty` option to `end()`. When this option is set, empty elements are not self-closed.
- Added support for [nested CDATA](https://en.wikipedia.org/wiki/CDATA#Nesting). The triad `]]>` in CDATA is now automatically replaced with `]]]]><![CDATA[>`.

## [4.2.1] - 2016-01-15
- Updated lodash dependency to 4.0.0.

## [4.2.0] - 2015-12-16
- Added the `noDoubleEncoding` option to `create()` to control whether existing html entities are encoded.

## [4.1.0] - 2015-11-11
- Added the `separateArrayItems` option to `create()` to control how arrays are handled when converting from objects. e.g.

```js
root.ele({ number: [ "one", "two"  ]});
// with separateArrayItems: true
<number>
  <one/>
  <two/>
</number>
// with separateArrayItems: false
<number>one</number>
<number>two</number>
```

## [4.0.0] - 2015-11-02
- Removed the `#list` decorator. Array items are now created as child nodes by default.
- Fixed a bug where the XML encoding string was checked partially.

[5.0.0]: https://github.com/oozcitak/xmlbuilder-js/compare/v4.2.1...v5.0.0
[4.2.1]: https://github.com/oozcitak/xmlbuilder-js/compare/v4.2.0...v4.2.1
[4.2.0]: https://github.com/oozcitak/xmlbuilder-js/compare/v4.1.0...v4.2.0
[4.1.0]: https://github.com/oozcitak/xmlbuilder-js/compare/v4.0.0...v4.1.0
[4.0.0]: https://github.com/oozcitak/xmlbuilder-js/compare/v3.1.0...v4.0.0
