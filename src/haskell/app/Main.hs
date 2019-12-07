{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Lib
import           Database.Persist
import           Database.Persist.Postgresql
import qualified Model.Post                    as P
import           Config
import           Model.Internal                 ( pgPool )
import           Control.Monad.IO.Class         ( liftIO )
import           Data.Time.Clock                ( getCurrentTime )

main :: IO ()
main = do
    config      <- fromFile
    pool        <- pgPool config
    currentTime <- getCurrentTime
    flip runSqlPool pool $ do
        let newPost = P.Post "sample" currentTime currentTime
        _     <- P.create newPost
        posts <- P.getAll
        liftIO $ print posts
        return ()
