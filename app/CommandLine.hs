module CommandLine
  ( CLArgs(..)
  , getCLArgs
  ) where

import Options.Applicative

data CLArgs =
  CLArgs
    { staticDirPath :: FilePath
    , homeViewPath :: FilePath
    , roomViewPath :: FilePath
    }
  deriving (Show)

parseOptions :: Parser CLArgs
parseOptions = CLArgs 
    <$> parseStaticDirPath 
    <*> parseHomeViewPath
    <*> parseRoomViewPath

parseStaticDirPath :: Parser FilePath
parseStaticDirPath =
    option str $ mconcat 
      [
        long "static"
      , help "Directory of the static files"
      ]

parseHomeViewPath :: Parser FilePath
parseHomeViewPath =
    option str $ mconcat 
      [
        long "home"
      , help "Path to the home view (html)"
      ]
    
parseRoomViewPath :: Parser FilePath
parseRoomViewPath =
    option str $ mconcat 
      [
        long "room"
      , help "Path to the room view (html)"
      ]

getCLArgs :: IO CLArgs
getCLArgs = execParser $ info (parseOptions <**> helper) fullDesc
