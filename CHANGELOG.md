# Change Log

## [5.0.0] - 2016-03-05
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

## [4.0.0] - 2015-11-01
- Removed the `#list` decorator. Array items are now created as child nodes by default.
- Fixed a bug where the XML encoding string was checked partially.

## [3.1.0] - 2015-09-19
- `#list` decorator ignores empty arrays.

## [3.0.0] - 2015-09-10
- Allow `\r`, `\n` and `\t` in attribute values without escaping. See [#86](https://github.com/oozcitak/xmlbuilder-js/issues/86).

## [2.6.5] - 2015-09-09
## [2.6.4] - 2015-05-27
## [2.6.3] - 2015-05-27
## [2.6.2] - 2015-03-10
## [2.6.1] - 2015-02-20
## [2.6.0] - 2015-02-20
## [2.5.2] - 2015-02-16
## [2.5.1] - 2015-02-09
## [2.5.0] - 2015-02-03
## [2.4.6] - 2015-01-26
## [2.4.5] - 2014-11-15
## [2.4.4] - 2014-09-08
## [2.4.3] - 2014-08-13
## [2.4.2] - 2014-08-13
## [2.4.1] - 2014-08-12
## [2.4.0] - 2014-08-04
## [2.3.0] - 2014-07-17
## [2.2.1] - 2014-04-04
## [2.2.0] - 2014-04-04
## [2.1.0] - 2013-12-30
## [2.0.1] - 2013-12-24
## [2.0.0] - 2013-12-24
## [1.1.2] - 2013-12-11
## [1.1.1] - 2013-12-11
## [1.1.0] - 2013-12-10
## [1.0.2] - 2013-11-27
## [1.0.1] - 2013-11-27
## [1.0.0] - 2013-11-27
## [0.4.3] - 2013-11-08
## [0.4.2] - 2012-09-14
## [0.4.1] - 2012-08-31
## [0.4.0] - 2012-08-31
## [0.3.3] - 2012-08-13
## [0.3.2] - 2012-08-13
## [0.3.11] - 2012-07-27
## [0.3.10] - 2012-07-20
## [0.3.1] - 2011-11-28
## [0.3.0] - 2011-11-28
## [0.2.2] - 2011-11-28
## [0.2.1] - 2011-11-28
## [0.2.0] - 2011-11-21
## [0.1.7] - 2011-10-25
## [0.1.6] - 2011-10-25
## [0.1.5] - 2011-08-08
## [0.1.4] - 2011-07-29
## [0.1.3] - 2011-07-27
## [0.1.2] - 2011-06-03
## [0.1.1] - 2011-05-19
## [0.1.0] - 2011-04-27
## [0.0.7] - 2011-04-23
## [0.0.6] - 2011-02-23
## [0.0.5] - 2010-12-31
## [0.0.4] - 2010-12-28
## [0.0.3] - 2010-12-27
## [0.0.2] - 2010-11-03
## 0.0.1 - 2010-11-02
- Initial release

[5.0.0]: https://github.com/oozcitak/xmlbuilder-js/compare/v4.2.1...v5.0.0
[4.2.1]: https://github.com/oozcitak/xmlbuilder-js/compare/v4.2.0...v4.2.1
[4.2.0]: https://github.com/oozcitak/xmlbuilder-js/compare/v4.1.0...v4.2.0
[4.1.0]: https://github.com/oozcitak/xmlbuilder-js/compare/v4.0.0...v4.1.0
[4.0.0]: https://github.com/oozcitak/xmlbuilder-js/compare/v3.1.0...v4.0.0
[3.1.0]: https://github.com/oozcitak/xmlbuilder-js/compare/v3.0.0...v3.1.0
[3.0.0]: https://github.com/oozcitak/xmlbuilder-js/compare/v2.6.5...v3.0.0
[2.6.5]: https://github.com/oozcitak/xmlbuilder-js/compare/v2.6.4...v2.6.5
[2.6.4]: https://github.com/oozcitak/xmlbuilder-js/compare/v2.6.3...v2.6.4
[2.6.3]: https://github.com/oozcitak/xmlbuilder-js/compare/v2.6.2...v2.6.3
[2.6.2]: https://github.com/oozcitak/xmlbuilder-js/compare/v2.6.1...v2.6.2
[2.6.1]: https://github.com/oozcitak/xmlbuilder-js/compare/v2.6.0...v2.6.1
[2.6.0]: https://github.com/oozcitak/xmlbuilder-js/compare/v2.5.2...v2.6.0
[2.5.2]: https://github.com/oozcitak/xmlbuilder-js/compare/v2.5.1...v2.5.2
[2.5.1]: https://github.com/oozcitak/xmlbuilder-js/compare/v2.5.0...v2.5.1
[2.5.0]: https://github.com/oozcitak/xmlbuilder-js/compare/v2.4.6...v2.5.0
[2.4.6]: https://github.com/oozcitak/xmlbuilder-js/compare/v2.4.5...v2.4.6
[2.4.5]: https://github.com/oozcitak/xmlbuilder-js/compare/v2.4.4...v2.4.5
[2.4.4]: https://github.com/oozcitak/xmlbuilder-js/compare/v2.4.3...v2.4.4
[2.4.3]: https://github.com/oozcitak/xmlbuilder-js/compare/v2.4.2...v2.4.3
[2.4.2]: https://github.com/oozcitak/xmlbuilder-js/compare/v2.4.1...v2.4.2
[2.4.1]: https://github.com/oozcitak/xmlbuilder-js/compare/v2.4.0...v2.4.1
[2.4.0]: https://github.com/oozcitak/xmlbuilder-js/compare/v2.3.0...v2.4.0
[2.3.0]: https://github.com/oozcitak/xmlbuilder-js/compare/v2.2.1...v2.3.0
[2.2.1]: https://github.com/oozcitak/xmlbuilder-js/compare/v2.2.0...v2.2.1
[2.2.0]: https://github.com/oozcitak/xmlbuilder-js/compare/v2.1.0...v2.2.0
[2.1.0]: https://github.com/oozcitak/xmlbuilder-js/compare/v2.0.1...v2.1.0
[2.0.1]: https://github.com/oozcitak/xmlbuilder-js/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/oozcitak/xmlbuilder-js/compare/v1.1.2...v2.0.0
[1.1.2]: https://github.com/oozcitak/xmlbuilder-js/compare/v1.1.1...v1.1.2
[1.1.1]: https://github.com/oozcitak/xmlbuilder-js/compare/v1.1.0...v1.1.1
[1.1.0]: https://github.com/oozcitak/xmlbuilder-js/compare/v1.0.2...v1.1.0
[1.0.2]: https://github.com/oozcitak/xmlbuilder-js/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/oozcitak/xmlbuilder-js/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.4.3...v1.0.0
[0.4.3]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.4.2...v0.4.3
[0.4.2]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.4.1...v0.4.2
[0.4.1]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.4.0...v0.4.1
[0.4.0]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.3.3...v0.4.0
[0.3.3]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.3.2...v0.3.3
[0.3.2]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.3.11...v0.3.2
[0.3.11]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.3.10...v0.3.11
[0.3.10]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.3.1...v0.3.10
[0.3.1]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.2.2...v0.3.0
[0.2.2]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.1.7...v0.2.0
[0.1.7]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.1.6...v0.1.7
[0.1.6]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.1.5...v0.1.6
[0.1.5]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.1.4...v0.1.5
[0.1.4]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.1.3...v0.1.4
[0.1.3]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.1.2...v0.1.3
[0.1.2]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.0.7...v0.1.0
[0.0.7]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.0.6...v0.0.7
[0.0.6]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.0.5...v0.0.6
[0.0.5]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.0.4...v0.0.5
[0.0.4]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.0.3...v0.0.4
[0.0.3]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/oozcitak/xmlbuilder-js/compare/v0.0.1...v0.0.2

