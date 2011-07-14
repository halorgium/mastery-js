require("./authority")

setMaker = require("./set").maker
forwarderMaker = require("./forwarder").maker

callCountForwarderMaker = createAuthority {setMaker, forwarderMaker}, (count, authority) ->
  {push, pop} = invokeAuthority(@setMaker)

  invokeAuthority(push, i) for i in [0..count]
  {proxy, revoker} = invokeAuthority(@forwarderMaker, authority)
  innerProxy = proxy

  proxy = createAuthority {innerProxy, revoker, pop}, (args...) ->
    unless allowed = invokeAuthority(@pop)
      invokeAuthority(@revoker)
    invokeAuthority(@innerProxy)

  {proxy}

exports.maker = callCountForwarderMaker

###
root = createAuthority undefined, () ->
  console.log("HACKED")

{proxy} = invokeAuthority(callCountForwarderMaker, 1, root)

invokeAuthority(root)
invokeAuthority(proxy)
invokeAuthority(proxy)
invokeAuthority(proxy)
###
