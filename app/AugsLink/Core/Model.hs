module AugsLink.Core.Model where

import qualified Data.UUID as UUID
import qualified Data.HashMap.Lazy as HM
import qualified Data.Map as M

import AugsLink.Core.API
import AugsLink.Internal.State

type InternalId = Int

data RoomState = RoomState

data Model = Model {
   modelRooms   ::   M.Map      Int    RoomState
 , modelRoomIds ::   HM.HashMap RoomId InternalId
 , modelNextId  ::   InternalId
 }

initialRoomState :: RoomState --todo: models roomstate; not io roomstate
initialRoomState = undefined

modelRegistry :: Registry (State Model)
modelRegistry = Registry
  {
    numRooms = M.size . modelRooms <$> get
  , createRoom = State $ \st ->
      let iId = modelNextId st
          rId = UUID.fromWords 0 0 0 (fromIntegral iId) --Where is the type enforcement coming from?
      in ( rId
         , st { modelRooms  = M.insert iId initialRoomState (modelRooms st)
              , modelNextId = succ iId
              , modelRoomIds = HM.insert rId iId (modelRoomIds st)
              }
         )
  , getRoom = undefined
  }

modelRoom :: Room (State Model)
modelRoom = Room
  {
    presentInRoom = undefined
  , enterRoom = undefined
  , leaveRoom = undefined 
  , publishToRoom = undefined
  }

