module AugsLink.Service.Application ( server ) where

import Servant 

import AugsLink.Service.API ( API )
import CommandLine ( CLArgs ( staticDirPath ) )
import AugsLink.Service.Handlers.GetHome ( home )
import AugsLink.Service.Handlers.PostHome ( create )
import AugsLink.Service.Handlers.RoomWs ( enter )
import AugsLink.Service.Handlers.GetRoom ( room )

import AugsLink.Core.API

handlers :: CLArgs -> Registry IO -> Server API
handlers opts rr = 
         home opts
    :<|> create rr
    :<|> room opts
    :<|> enter rr
    :<|> public
  where 
    public = serveDirectoryWebApp $ staticDirPath opts

server :: CLArgs -> Registry IO -> Application
server opts rr = serve (Proxy @API) (handlers opts rr) 
