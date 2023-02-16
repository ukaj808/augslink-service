{-# LANGUAGE OverloadedStrings #-}

module AugsLink.Service.API
  ( API
  , HTML(..)
  , RawHtml(..)
  ) where

import Data.ByteString.Lazy as Lazy
import Network.HTTP.Media ((//), (/:))
import Servant
import Servant.API.WebSocket

data HTML =
  HTML

newtype RawHtml =
  RawHtml
    { unRaw :: Lazy.ByteString
    }

type PostSeeOther = Verb 'POST 303 

instance Accept HTML where
  contentType _ = "text" // "html" /: ("charset", "utf-8")

instance MimeRender HTML RawHtml where
  mimeRender _ = unRaw

type API =   
        Get '[HTML] RawHtml -- Home Page
        -- Create Room Button Click on Home Page -> Create Room -> Redirect to /room/<id>
   :<|> PostSeeOther '[PlainText] (Headers '[Header "Location" String] String) 
   :<|> Capture "roomid" String :> Get '[HTML] RawHtml
   :<|> Capture "roomid" String :> "ws" :> WebSocketPending
   :<|> "public" :> Raw
   -- Need more endpoints for music file download + delete
