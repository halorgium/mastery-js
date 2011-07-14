#console.log("creating authority store")
{createAuthority, fetchAuthority, invokeAuthority, dumpAuthorities} = require("./authorityStore").make()

global.createAuthority = createAuthority
global.fetchAuthority = fetchAuthority
global.invokeAuthority = invokeAuthority
global.dumpAuthorities = dumpAuthorities
