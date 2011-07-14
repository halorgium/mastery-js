require("./authority")

setMaker = require("./set").maker

notiferMaker = createAuthority {setMaker}, () ->
  {push, pop} = invokeAuthority(@setMaker)
  #console.log({push, pop})

  notify = createAuthority {pop}, () ->
    #console.log("Notifying people inside #{@pop}")
    iterate = () =>
      observer = invokeAuthority(@pop)
      if observer
        #console.log("Notifying #{observer}")
        invokeAuthority(observer)
        iterate()
    iterate()
    true

  register = createAuthority {push}, (observer) ->
    invokeAuthority(@push, observer)

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
