require("./authority")

dataMaker = require("./data").maker

setMaker = createAuthority {dataMaker}, () ->
  {reader, writer} = invokeAuthority(@dataMaker)
  invokeAuthority(writer, [])

  push = createAuthority {reader,writer}, (value) ->
    values = invokeAuthority(@reader)
    values.push(value)
    invokeAuthority(@writer, values)
    true
  pop = createAuthority {reader,writer}, () ->
    values = invokeAuthority(@reader)
    value = values.pop()
    invokeAuthority(@writer, values)
    value

  clear = createAuthority {writer}, () ->
    invokeAuthority(@writer, [])
    true

  {push, pop, clear}

exports.maker = setMaker

###
{push, pop, clear} = setMaker()

console.log(invokeAuthority(push, 1))
console.log(invokeAuthority(push, 2))
console.log(invokeAuthority(pop))
console.log(invokeAuthority(push, 3))
console.log(invokeAuthority(push, 4))
console.log(invokeAuthority(pop))
console.log(invokeAuthority(clear))
console.log(invokeAuthority(pop))
###
