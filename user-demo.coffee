require("./authority")

dataMaker = require("./data").maker
forwarderMaker = require("./forwarder").maker

userMaker = createAuthority {dataMaker}, (name) ->
  {reader, writer} = invokeAuthority(@dataMaker)
  info = {name}
  authorities = {}
  invokeAuthority(writer, {info, authorities})

  introducer = createAuthority {reader, writer}, (name, authority) ->
    value = invokeAuthority(@reader)
    value.authorities[name] = authority
    invokeAuthority(@writer, value)

  {reader, introducer}

ed = invokeAuthority(userMaker, "Ed")
tim = invokeAuthority(userMaker, "Tim")

{reader, writer} = invokeAuthority(dataMaker)
proxy = invokeAuthority(forwarderMaker, reader).proxy
invokeAuthority(ed.introducer, "data_from_tim", proxy)

console.log(invokeAuthority(ed.reader))

invokeAuthority(writer, "YOU CAN READ THIS")

console.log(invokeAuthority(invokeAuthority(ed.reader).authorities.data_from_tim))
