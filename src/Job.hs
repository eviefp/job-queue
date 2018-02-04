{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE RankNTypes            #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE TypeOperators         #-}

module Job
  ( HardwareId (..)
  , ChannelId (..)
  , MediaId (..)
  , JobId (..)
  , PublishRequest (..)
  , JobType (..)
  ) where

import           Data.Aeson   (FromJSON, ToJSON)
import           GHC.Generics

newtype JobId = JobId Int deriving (Eq, Show, Generic)
newtype ChannelId = ChannelId Int deriving (Eq, Show, Generic)
newtype HardwareId = HardwareId Int deriving (Eq, Show, Generic)
newtype MediaId = MediaId Int deriving (Eq, Show, Generic)

instance FromJSON JobId
instance FromJSON ChannelId
instance FromJSON HardwareId
instance FromJSON MediaId

instance ToJSON JobId
instance ToJSON ChannelId
instance ToJSON HardwareId
instance ToJSON MediaId

data PublishRequest
    = PublishHardware [HardwareId]
    | PublishChannel [ChannelId]
    | ApplyChanges MediaId [HardwareId]
    deriving (Eq, Show, Generic)

instance FromJSON PublishRequest
instance ToJSON PublishRequest

data JobType
    = QueuePublish PublishRequest
    | Other
