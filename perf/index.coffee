builder = require('../src/index')
git = require('git-state')
fs = require('fs')
path = require('path')
{ performance, PerformanceObserver } = require('perf_hooks')

global.xml = builder.create
global.doc = builder.begin

global.perf = (description, count, func) ->

  startTime = performance.now()
  for i in [1..count]
    func()
  endTime = performance.now()
  totalTime = endTime - startTime
  averageTime = totalTime / count

  version = require('../package.json').version
  working = gitWorking(gitDir)
  if working then version = version + "*"
  if not perfObj[version] then perfObj[version] = { }

  perfObj[version][description] = averageTime.toFixed(4)

readPerf = (filename) ->
  if not fs.existsSync(filename) then fs.closeSync(fs.openSync(filename, 'w'))
  str = fs.readFileSync(filename, 'utf8')
  if str then JSON.parse(str) else { }

runPerf = (dirPath) ->
  for file from walkDir(dirPath)
    filename = path.basename(file)
    if filename is "index.coffee" or filename is "perf.list" then continue
    require(file)

walkDir = (dirPath) ->
  for file in fs.readdirSync(dirPath)
    filePath = path.join(dirPath, file)
    stat = fs.statSync(filePath)
    if stat.isFile() then yield filePath else if stat.isDirectory() then yield from walkDir(filePath)
  return undefined

gitWorking = (dirPath) ->
  return git.isGitSync(dirPath) and git.dirtySync(dirPath)

printPerf = (filename, perfObj) ->
  sorted = sortByVersion(perfObj)

  for version, items of perfObj
    console.log "\x1b[4mv%s:\x1b[0m", version
    for description, averageTime of items
      prevItem = findPrevPerf(sorted, version, description)
      if prevItem
        if averageTime < prevItem.item[description]
          console.log "  - \x1b[36m%s\x1b[0m => \x1b[1m\x1b[32m%s\x1b[0m ms (v%s was \x1b[1m%s\x1b[0m ms) \x1b[1m%s\x1b[0m% better", description, averageTime, prevItem.version, prevItem.item[description], (-100*(averageTime - prevItem.item[description]) / prevItem.item[description]).toFixed(0)
        else if averageTime > prevItem.item[description]
          console.log "  - \x1b[36m%s\x1b[0m => \x1b[1m\x1b[41m%s\x1b[0m ms (v%s was \x1b[1m%s\x1b[0m ms) \x1b[1m%s\x1b[0m% worse", description, averageTime, prevItem.version, prevItem.item[description], (100*(averageTime - prevItem.item[description]) / prevItem.item[description]).toFixed(0)
        else
          console.log "  - \x1b[36m%s\x1b[0m => \x1b[1m%s\x1b[0m ms (v%s was \x1b[1m%s\x1b[0m ms)", description, averageTime, prevItem.version, prevItem.item[description]
      else
        console.log "  - \x1b[36m%s\x1b[0m => \x1b[1m%s\x1b[0m ms", description, averageTime

  writePerf = { }
  for version, items of perfObj
    if not parseVersion(version)[3]
      writePerf[version] = items
  fs.writeFileSync(filename, JSON.stringify(writePerf, null, 2) , 'utf-8')

findPrevPerf = (sorted, version, description) ->
  prev = undefined
  for item in sorted
    if compareVersion(item.version, version) is -1
      if item.item[description]
        prev = item
  return prev

sortByVersion = (perfObj) ->
  sorted = []
  for version, items of perfObj
    sorted.push
      version: version
      item: items
  sorted.sort (item1, item2) ->
    compareVersion(item1.version, item2.version)

parseVersion = (version) ->
  isDirty = version[version.length - 1] is "*"
  if isDirty then version = version.substr(0, version.length - 1)
  v = version.split('.')
  v.push(isDirty)
  return v

compareVersion = (v1, v2) ->
  v1 = parseVersion(v1)
  v2 = parseVersion(v2)

  if v1[0] < v2[0]
    -1
  else if v1[0] > v2[0]
    1
  else # v1[0] = v2[0]
    if v1[1] < v2[1]
      -1
    else if v1[1] > v2[1]
      1
    else # v1[1] = v2[1]
      if v1[2] < v2[2]
        -1
      else if v1[2] > v2[2]
        1
      else # v1[2] = v2[2]
        if v1[3] and not v2[3]
          1
        else if v2[3] and not v1[3]
          -1
        else
          0


perfDir = __dirname
gitDir = path.resolve(__dirname, '..')
perfFile = path.join(perfDir, './perf.list')
perfObj = readPerf(perfFile)
runPerf(perfDir)
printPerf(perfFile, perfObj)
