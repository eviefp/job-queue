{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE RankNTypes            #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE TypeOperators         #-}

module Server
    ( app
    ) where

import           Control.Monad.IO.Class (liftIO)
import           Data.Aeson             (FromJSON)
import           Job                    (JobId (JobId))
import           Prelude                (IO, return, ($), (.))
import           Servant

type JobQueueAPI a
    = "queue" :> ReqBody '[JSON] a :> Post '[JSON] JobId

type JobHandler a = a -> IO ()

api :: Proxy (JobQueueAPI a)
api = Proxy

server :: JobHandler a -> Server (JobQueueAPI a)
server f x = do
    liftIO . f $ x
    return $ JobId 1

app :: FromJSON a => JobHandler a -> Application
app x = serve api (server x)
