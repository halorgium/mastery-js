promiseMaker = require("./promise").maker

{reader, register, resolve} = invokeAuthority(promiseMaker)

observer = createAuthority {reader}, () ->
  console.log("IT HAPPENED")
  console.log("data is #{invokeAuthority(@reader)}")

invokeAuthority(register, observer)

producer = createAuthority {resolve}, () ->
  console.log("Producing info")
  invokeAuthority(resolve, "ZOMG")

invokeAuthority(producer)
