require("./authority")

notifierMaker = require("./notifier").maker
dataMaker = require("./data").maker

promiseMaker = createAuthority {dataMaker, notifierMaker}, () ->
  {reader, writer} = invokeAuthority(@dataMaker)
  {notify, register} = invokeAuthority(@notifierMaker)

  #console.log({reader, writer})
  #console.log({notify, register})

  resolve = createAuthority {writer, notify}, (value) ->
    invokeAuthority(@writer, value)
    invokeAuthority(@notify)

  {reader, register, resolve}

exports.maker = promiseMaker

###
{reader, register, resolve} = invokeAuthority(promiseMaker)

observer = createAuthority {reader}, () ->
  console.log("IT HAPPENED")
  console.log("data is #{invokeAuthority(@reader)}")

invokeAuthority(register, observer)
invokeAuthority(resolve, "ZOMG")
###
