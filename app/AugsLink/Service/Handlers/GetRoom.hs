module AugsLink.Service.Handlers.GetRoom 
  ( room
  ) where

import Control.Monad.IO.Class ( liftIO )
import qualified Data.ByteString.Lazy as Lazy
import Servant

import AugsLink.Service.API ( RawHtml (..) )
import CommandLine ( Options ( roomViewPath ) )

room :: Options -> String -> Handler RawHtml
room opts _ = do
  roomHtmlFile <- liftIO $ Lazy.readFile $ roomViewPath opts
  return $ RawHtml roomHtmlFile
