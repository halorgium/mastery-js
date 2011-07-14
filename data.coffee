require("./authority")

dataMaker = createAuthority undefined, () ->
  value = JSON.stringify(null)
  data = createAuthority {value}, () ->
    @
  reader = createAuthority {data}, () ->
    json = invokeAuthority(@data).value
    JSON.parse(json)
  writer = createAuthority {data}, (newValue) ->
    invokeAuthority(@data).value = JSON.stringify(newValue)
    true
  clear = createAuthority {data}, () ->
    invokeAuthority(@data).value = JSON.stringify(null)
    true

  {reader, writer, clear}

exports.maker = dataMaker

###
require("./authority")
dataMaker = require("./data").maker
data = invokeAuthority(dataMaker)

console.log(data)

{reader, writer, clear} = data

console.log(invokeAuthority(reader))
console.log(invokeAuthority(writer, "ZOMG"))
console.log(invokeAuthority(reader))
console.log(invokeAuthority(clear))
console.log(invokeAuthority(reader))
###
