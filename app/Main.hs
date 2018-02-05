{-# LANGUAGE OverloadedStrings #-}

module Main where

import           Database.Redis           (checkedConnect, defaultConnectInfo,
                                           runRedis, set)
import           Job                      (JobId (JobId), PublishRequest (..))
import           Network.Wai.Handler.Warp (run)
import           Prelude                  (IO, const, print, return, ($), (.))
import           Server                   (app)


handler :: PublishRequest -> IO ()
handler x = do
    conn <- checkedConnect defaultConnectInfo
    runRedis conn $
        case x of
            PublishHardware _ -> set "work" "publish"
            PublishChannel _  -> set "work" "channel"
            ApplyChanges _ _  -> set "work" "apply"
    return ()

main :: IO ()
main = run 8081 (app handler)
