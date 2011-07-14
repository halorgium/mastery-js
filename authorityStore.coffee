#log = console.log
log = () ->

none = () =>

authorityStoreMaker = () ->
  authorities = {}
  count = 1

  uriMaker = () ->
    uri = "authority://#{count}"
    count += 1
    uri

  wrap = (data, fn) ->
    if !fn
      throw data
    () ->
      fn.apply(data, arguments)

  fetch = (uri) ->
    unless uri.match?(/^authority:\/\//)
      throw JSON.stringify(uri)
    log({uri, authorities})
    if meta = authorities[uri]
      {data, fn} = meta
      log({data, fn})
      log(fn.toString())
      safeFn = eval("(#{fn.toString()})")
      wrap(data, safeFn)
    else
      throw "No authority found for #{uri}"

  {
    createAuthority: (data, fn) ->
      uri = uriMaker()
      authorities[uri] = {data, fn}
      uri
    fetchAuthority: (uri) ->
      fetch(uri)
    invokeAuthority: (uri, args...) ->
      log "Invoking #{uri} with #{JSON.stringify(args)}"
      authority = fetch(uri)
      log({authority})
      authority(args...)
    dumpAuthorities: () ->
      console.log({authorities})
      fns = {}
      for uri of authorities
        authority = authorities[uri]
        {data,fn} = authority
        console.log("--------------------------------")
        console.log({uri,data})
        console.log(fn.toString())
        fns[fn.toString()] ||= 0
        fns[fn.toString()] += 1
      console.log(fns)
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
