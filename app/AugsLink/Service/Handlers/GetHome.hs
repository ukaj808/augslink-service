module AugsLink.Service.Handlers.GetHome 
  ( home
  ) where

import Control.Monad.IO.Class ( liftIO )
import qualified Data.ByteString.Lazy as Lazy
import Servant

import AugsLink.Service.API ( RawHtml (..) )
import CommandLine ( homeViewPath , CLArgs )

home :: CLArgs -> Handler RawHtml
home opts = do
  homeHtmlFile <- liftIO $ Lazy.readFile $ homeViewPath opts 
  return $ RawHtml homeHtmlFile
