module Main where

import           Data.Aeson                 (encode, toJSON)
import           Data.ByteString.Lazy.Char8 (unpack)
import           Job                        (HardwareId (HardwareId),
                                             PublishRequest (PublishHardware))
import           Network.Wai.Handler.Warp   (run)
import           Server                     (app)

main :: IO ()
main = do
    print . unpack . encode $ PublishHardware [HardwareId 1]
    run 8081 app
