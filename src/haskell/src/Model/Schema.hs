{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}

module Model.Schema where

import           Data.Text                      ( Text )
import           Data.Time                      ( UTCTime )
import           Database.Persist.TH            ( mkPersist
                                                , mkMigrate
                                                , share
                                                , derivePersistField
                                                , persistLowerCase
                                                , sqlSettings
                                                )

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Post sql=posts
    title Text sqltype=text
    createdAt UTCTime default=now()
    updatedAt UTCTime default=now()
    deriving Show
    deriving Eq
|]
