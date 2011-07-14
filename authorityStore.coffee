#log = console.log
log = () ->

authorityStoreMaker = () ->
  authorities = {}
  count = 1

  uuidMaker = (count) ->
    "authority://#{count}"

  wrap = (data, fn) ->
    if !fn
      throw data
    () ->
      fn.apply(data, arguments)

  fetch = (uuid) ->
    unless uuid.match?(/^authority:\/\//)
      throw JSON.stringify(uuid)
    log({uuid, authorities})
    if meta = authorities[uuid]
      {data, fn} = meta
      log({data, fn})
      log(fn.toString())
      wrap(data, fn)
    else
      throw "No authority found for #{uuid}"

  {
    createAuthority: (data, fn) ->
      uuid = uuidMaker(count)
      authorities[uuid] = {data, fn}
      count += 1
      uuid
    fetchAuthority: (uuid) ->
      fetch(uuid)
    invokeAuthority: (uuid, args...) ->
      log "Invoking #{uuid} with #{JSON.stringify(args)}"
      authority = fetch(uuid)
      log({authority})
      authority(args...)
  }

exports.make = () ->
  authorityStoreMaker()

###
{fetchAuthority, createAuthority} = require("./authorityStore").make()
uri = createAuthority foo: 0, () ->
  @foo += 1
  @foo

console.log(uri)

auth = fetchAuthority(uri)

console.log(auth())
console.log(auth())
console.log(auth())
###
