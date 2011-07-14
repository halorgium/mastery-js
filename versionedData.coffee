require("./authority")

dataMaker = require("./data").maker

versionedDataMaker = createAuthority {dataMaker}, () ->
  data = invokeAuthority(@dataMaker)
  [dataReader, dataWriter] = [data.reader, data.writer]

  invokeAuthority(dataWriter, versions: [])

  reader = createAuthority {dataReader}, () ->
    invokeAuthority(@dataReader).current
  writer = createAuthority {dataReader,dataWriter}, (newValue) ->
    value = invokeAuthority(@dataReader)
    value.current = newValue
    value.versions.push(newValue)
    invokeAuthority(@dataWriter, value)
    true
  versions = createAuthority {dataReader}, () ->
    invokeAuthority(@dataReader).versions

  invokeAuthority(writer, null)

  {reader, writer, versions}

exports.maker = versionedDataMaker

###
{reader, writer, versions} = invokeAuthority(versionedDataMaker)

console.log(invokeAuthority(reader))
console.log(invokeAuthority(writer, "ZOMG"))
console.log(invokeAuthority(reader))
console.log(invokeAuthority(writer, "ZOMG 2"))
console.log(invokeAuthority(reader))
console.log(invokeAuthority(versions))
###
