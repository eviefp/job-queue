{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE RankNTypes            #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE TypeOperators         #-}

module Server
    ( app
    ) where

import           Control.Monad.IO.Class (liftIO)
import           Data.List
import           Data.Maybe
import           Database.Redis         (checkedConnect, defaultConnectInfo,
                                         runRedis, set)
import           Job                    (JobId (JobId), PublishRequest (..))
import           Prelude                (const, print, return, ($), (.))
import           Servant

type JobQueueAPI
    = "queue" :> ReqBody '[JSON] PublishRequest :> Post '[JSON] JobId

api :: Proxy JobQueueAPI
api = Proxy

server :: Server JobQueueAPI
server x = do
    liftIO $ print x
    conn <- liftIO $ checkedConnect defaultConnectInfo
    liftIO . runRedis conn $
        case x of
            PublishHardware _ -> set "work" "publish"
            PublishChannel _  -> set "work" "channel"
            ApplyChanges _ _  -> set "work" "apply"
    return $ JobId 1

app :: Application
app = serve api server
