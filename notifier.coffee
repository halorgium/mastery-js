require("./authority")

dataMaker = require("./data").maker

notiferMaker = createAuthority undefined, () ->
  {reader, writer} = invokeAuthority(dataMaker)
  invokeAuthority(writer, [])

  notify = createAuthority {reader}, () ->
    #console.log("Notifying people inside #{@reader}")
    observers = invokeAuthority(@reader)
    for observer in observers
      #console.log("Notifying #{observer}")
      invokeAuthority(observer)

  register = createAuthority {reader, writer}, (observer) ->
    observers = invokeAuthority(@reader)
    observers.push(observer)
    invokeAuthority(@writer, observers)

  {notify, register}

exports.maker = notiferMaker

###
{notify, register} = invokeAuthority(notifierMaker)

console.log({notify, register})

observer = createAuthority undefined, () ->
  console.log("IT HAPPENED")

invokeAuthority(notify)
invokeAuthority(register, observer)
invokeAuthority(notify)
###
