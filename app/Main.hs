module Main( main ) where

import Network.Wai.Handler.Warp ( run )

import AugsLink.Core.Room
import AugsLink.Service.Application ( server )
import CommandLine ( getCLArgs )

main :: IO ()
main = do
  clArgs <- getCLArgs
  roomRegistry <- newRegistry
  run 8080 $ server clArgs roomRegistry
