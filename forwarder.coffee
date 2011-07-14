require("./authority")

dataMaker = require("./data").maker

forwarderMaker = createAuthority undefined, (authority) ->
  {reader, writer, clear} = invokeAuthority(dataMaker)
  invokeAuthority(writer, {authority})

  proxy = createAuthority {reader}, (args...) ->
    if data = invokeAuthority(@reader)
      {authority} = data
      invokeAuthority(authority, args...)
    else
      throw "Authority has been revoked"

  revoker = createAuthority {clear}, () ->
    invokeAuthority(@clear)

  {proxy, revoker}

root = createAuthority undefined, () ->
  console.log("HACKED")

{proxy, revoker} = invokeAuthority(forwarderMaker, root)

invokeAuthority(root)
invokeAuthority(proxy)
invokeAuthority(revoker)
invokeAuthority(proxy)
