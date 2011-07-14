#console.log("creating authority store")
{createAuthority, fetchAuthority, invokeAuthority} = require("./authorityStore").make()

global.createAuthority = createAuthority
global.fetchAuthority = fetchAuthority
global.invokeAuthority = invokeAuthority
