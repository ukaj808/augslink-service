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
     presentInRoom  ::                   m [User]
  ,  enterRoom      ::   Connection m -> m ()
  ,  leaveRoom      ::   UserId       -> m ()
  ,  publishToRoom  ::   RoomEvent    -> m ()
  ,  nextIndex      ::                   m Int
  }

data User = User
 {
    userId :: UserId
 ,  userName :: UserName
 ,  spotInLine     :: Int
 }
data RoomEvent = UserEnterEvent User
  |              UserLeftEvent  UserId
  |              UserVoteEvent  UserId Vote

type RoomId   = UUID
type UserId   = UUID
type UserName = String
type Vote     = Bool


type family Connection (m :: * -> *) :: *

instance Eq User where
  u1 == u2 = userId u1 == userId u2
instance Ord User where
  u1 <= u2 = spotInLine u1 <= spotInLine u2 

instance ToJSON RoomEvent where
  toJSON :: RoomEvent -> Value
  toJSON (UserEnterEvent u) = Aeson.object 
    [
       "type"        .= ("UserEnterEvent" :: String)
    ,  "userId"      .= userId u
    ,  "userName"    .= userName u
    ,  "spotInLine"  .= spotInLine u
    ]
  
instance FromJSON RoomEvent where
  parseJSON :: Value -> Parser RoomEvent
  parseJSON = Aeson.withObject "RoomEvent" $ \obj -> do
      typ <- obj .: "type"
      case typ :: String of
        "UserEnterEvent" -> do
          userId     <- obj .: "userId"
          userName   <- obj .: "userName"
          spotInLine <- obj .: "spotInLine"
          return $ UserEnterEvent $ User userId userName spotInLine
