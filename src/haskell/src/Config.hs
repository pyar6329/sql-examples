{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module Config where

import           Control.Lens
import           Data.Maybe                     ( fromMaybe )
import qualified Data.Text                     as T
                                                ( concat
                                                , dropWhile
                                                , unwords
                                                )
import           Dhall                   hiding ( auto )
import           System.Environment             ( lookupEnv )

auto :: Interpret a => Type a
auto =
    autoWith (defaultInterpretOptions { fieldModifier = T.dropWhile (== '_') })

data Postgres = Postgres
    { _pgHost     :: Text
    , _pgDbName   :: Text
    , _pgUser     :: Text
    , _pgPassword :: Text
    , _pgPort     :: Text
    } deriving(Show, Generic)
instance Interpret Postgres
makeLenses ''Postgres

data Config = Config
    { _postgres    :: Postgres
    } deriving (Show, Generic)
instance Interpret Config
makeLenses ''Config

fromFile :: IO Config
fromFile = do
    env <- lookupEnv "ENV"
    env <- return $ fromMaybe "dev" env
    let fileName = concat ["./config/config.", env, ".dhall"]
    inputFile (auto :: Type Config) fileName

postgresConf :: Postgres -> Text
postgresConf p = T.unwords $ map
    toString
    [ ("host"    , _pgHost)
    , ("dbname"  , _pgDbName)
    , ("user"    , _pgUser)
    , ("password", _pgPassword)
    , ("port"    , _pgPort)
    ]
    where toString (name, getter) = T.concat [name, "=", getter p]
