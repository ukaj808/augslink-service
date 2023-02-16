module AugsLink.Core.Room
  (
    initialRegistryState 
  , initialRoomState
  , newRegistry
  , Registry (..)
  , RegistryState (..)
  , RoomState (..)
  , RoomEvent (..)
  , Room (..)
  , RoomId
  )
  where

import qualified Data.Aeson as Aeson
import           Control.Concurrent.MVar (newMVar, readMVar, MVar)
import qualified Data.HashMap.Lazy as HM
import           Control.Concurrent      (modifyMVar_)
import           Data.UUID.V4            (nextRandom)
import qualified Network.WebSockets as WS
import Control.Monad (forM_)
import qualified Data.Text as T

import  AugsLink.Core.API

newtype RegistryState = RegistryState
  {
     rooms :: HM.HashMap RoomId (Room IO)
  }

data RoomState = RoomState
  {
    roomUsers       :: HM.HashMap UserId UserState               
  , roomCurrentSong :: Maybe Song
  , roomVote        :: [Vote]
  }

data UserState = UserState
  {
     userConn  :: WS.Connection
  ,  userQueue :: [Song]
  ,  userOrder :: Int
  ,  userName  :: Username
  }

          

data Song = Song
  {
    title    :: String
  , artist   :: String
  , duration :: Int
  }

type instance Connection IO = WS.PendingConnection

initialRegistryState :: RegistryState
initialRegistryState = RegistryState {rooms=HM.empty}

initialRoomState :: RoomState
initialRoomState = RoomState {roomUsers=HM.empty, roomCurrentSong=Nothing, roomVote=[]}

newRegistry :: IO (Registry IO)
newRegistry = do
  stateVar <- newMVar initialRegistryState
  return $ Registry
    {
      numRooms = 
        HM.size . rooms <$> readMVar stateVar
    , getRoom = \rId ->
        HM.lookup rId . rooms <$> readMVar stateVar
    , createRoom = do
        room <- newRoom
        rId <- nextRandom
        modifyMVar_ stateVar $ \st -> return st{
            rooms =  HM.insert rId room (rooms st)
          }
        return rId
    }

newRoom :: IO (Room IO)
newRoom = do
  stateVar <- newMVar initialRoomState
  return $ Room {
      presentInRoom =
        HM.keys . roomUsers <$> readMVar stateVar

    , enterRoom = enterRoomImpl stateVar
    , leaveRoom = \u ->
        modifyMVar_ stateVar $ \st -> return st{roomUsers = HM.delete u (roomUsers st)}
    , publishToRoom = publishToRoomImpl stateVar
    }

enterRoomImpl :: MVar RoomState -> Connection IO -> IO ()
enterRoomImpl stateVar pend = do
       
    conn <- WS.acceptRequest pend
    putStrLn "accepted connection"
    uuid <- nextRandom 
    let uid = uuid
    let user = UserState {userConn=conn, userQueue=[], userOrder=1, userName="fisnik"} 
    publishToRoomImpl stateVar $ UserEnterEvent uid $ userName user
    modifyMVar_ stateVar $ \st -> return st{roomUsers = HM.insert uid user $ roomUsers st}
    WS.withPingThread conn 30 (return ()) $ handleIncomingEvents stateVar conn
    -- todo: deal with async threads
    -- we should keep a reference to the thread so when room is empty we can terminate it 

publishToRoomImpl :: MVar RoomState -> RoomEvent -> IO ()
publishToRoomImpl stateVar e = do
  rmSt <- readMVar stateVar
  forM_ (roomUsers rmSt) $ \u ->
    WS.sendTextData (userConn u) (Aeson.encode e)
  
handleIncomingEvents :: MVar RoomState -> WS.Connection -> IO ()
handleIncomingEvents stateVar conn = do
  putStrLn "Start handle events"
  go
  where
    go :: IO () 
    go  = do 
      msg <- WS.receiveData conn
      print msg
      case Aeson.eitherDecode msg of
        Left e -> do 
          print e
          WS.sendClose conn $ T.pack e
        Right event -> do 
          publishToRoomImpl stateVar event
          go
