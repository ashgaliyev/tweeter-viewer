{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}
module Lib
    ( someFunc
    ) where

import Data.Text as T
import qualified Data.ByteString.Char8 as C
import qualified Data.ByteString.Base64 as B64
import Data.ByteString as BS hiding (putStrLn)
import Data.ByteString.Char8 as Ch8 (pack)
import Data.ByteString.Lazy as BSL hiding (putStrLn)
import Codec.Binary.UTF8.String as UTF8 (decode)
import Network.Wreq
import Control.Lens

import Prelude hiding (putStrLn)
import Data.String.Class (putStrLn)
import Data.Aeson.Lens
import Data.Aeson

import Data.Time.Clock (UTCTime)

import GHC.Generics

getBase64BearerCredentials :: C.ByteString
getBase64BearerCredentials = B64.encode $ C.pack (consumerKey ++ ":" ++ consumerSecret)

data Timeline = Timeline { statuses :: [Tweet]
                         } deriving (Generic)

data Tweet = Tweet { text :: String,
                     created_at :: String
                   } deriving (Generic)

instance Show Timeline where
  show Timeline { statuses = [] }  = ""
  show Timeline { statuses = (x:xs) }  = show x ++ "\n\n" ++ show Timeline { statuses = xs }

instance Show Tweet where
  show Tweet { text = tweetText, created_at = date } = tweetText ++ "\n" ++ date

instance FromJSON Tweet
instance ToJSON Tweet

instance FromJSON Timeline
instance ToJSON Timeline

getTweetsFromResponse :: Response BSL.ByteString -> Either String Timeline
getTweetsFromResponse r = eitherDecode $ r ^. responseBody


someFunc :: IO ()
someFunc =
  do
  let opts = defaults & header "Authorization" .~ [C.pack $ "Basic " ++ C.unpack  getBase64BearerCredentials] & header "Content-Type" .~ ["application/x-www-form-urlencoded;charset=UTF-8"]
  r <- postWith opts "https://api.twitter.com/oauth2/token" (C.pack "grant_type=client_credentials")
  case access_token r of
    Nothing -> putStrLn ("Nothing 1" :: String)
    Just token -> do
      let n_opts = defaults & header "Authorization" .~ [C.pack $ "Bearer " ++ T.unpack token]
      d <- getWith n_opts ("https://api.twitter.com/1.1/search/tweets.json?q=" ++ "haskell")
      case getTweetsFromResponse d of
        Left str -> putStrLn str
        Right xs -> putStrLn $ show xs
  where
    access_token _r = _r ^? responseBody . key "access_token" . _String
