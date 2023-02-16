{-# LANGUAGE OverloadedStrings #-}
module AugsLink.Core.API where

import           Data.UUID  (UUID)
import           Data.Aeson.Types
import qualified Data.Aeson as Aeson

data Registry m = Registry
  {
     numRooms       ::             m Int
  ,  createRoom     ::             m RoomId
  ,  getRoom        ::   RoomId -> m (Maybe (Room m))
  }

data Room m = Room
  {
     presentInRoom  ::                   m [UserId]
  ,  enterRoom      ::   Connection m -> m ()
  ,  leaveRoom      ::   UserId       -> m ()
  ,  publishToRoom  ::   RoomEvent    -> m ()
  }

data RoomEvent = UserEnterEvent UserId Username
  |              UserLeftEvent  UserId
  |              UserVoteEvent  UserId Vote

type RoomId   = UUID
type UserId   = UUID
type Username = String
type Vote     = Bool


type family Connection (m :: * -> *) :: *

instance ToJSON RoomEvent where
  toJSON :: RoomEvent -> Value
  toJSON (UserEnterEvent uid uname) = Aeson.object 
    [
       "type"      .= ("UserEnterEvent" :: String)
    ,  "userId"    .= uid
    ,  "username"  .= uname
    ]
  
instance FromJSON RoomEvent where
  parseJSON :: Value -> Parser RoomEvent
  parseJSON = Aeson.withObject "RoomEvent" $ \obj -> do
      typ <- obj .: "type"
      case typ :: String of
        "UserEnterEvent" -> do
          userId   <- obj .: "userId"
          userName <- obj .: "username"
          return $ UserEnterEvent userId userName
