#log = console.log
log = () ->

none = () =>

uuid = require("node-uuid")

authorityStoreMaker = () ->
  authorities = {}

  uriMaker = () ->
    "authority://#{uuid()}"

  wrap = (data, fn) ->
    if !fn
      throw data
    () ->
      fn.apply(data, arguments)

  fetch = (uri) ->
    unless uri.match?(/^authority:\/\//)
      throw JSON.stringify(uri)
    if meta = authorities[uri]
      {data, fnBody} = meta
      log({data})
      log(fnBody)
      fn = eval("(#{fnBody})")
      wrap(data, fn)
    else
      throw "No authority found for #{uri}"

  {
    createAuthority: (data, fn) ->
      uri = uriMaker()
      fnBody = fn.toString()
      authorities[uri] = {data, fnBody}
      uri
    fetchAuthority: (uri) ->
      fetch(uri)
    invokeAuthority: (uri, args...) ->
      log "Invoking #{uri} with #{JSON.stringify(args)}"
      authority = fetch(uri)
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
