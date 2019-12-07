{-# LANGUAGE OverloadedStrings #-}
module Model.PostSpec where

import           Test.Hspec
import           Prelude                 hiding ( truncate )
import           Data.Time                      ( UTCTime )
import           Database.Persist               ( Entity(..)
                                                , entityKey
                                                , entityVal
                                                )
import           Database.Persist.Sql           ( toSqlKey
                                                , runSqlPool
                                                )
import           Config
import           Model.Internal                 ( pgPool )
import           Model.Post                     ( Post(..)
                                                , PostId
                                                )

import qualified Model.Post                    as P
                                                ( get
                                                , getAll
                                                , create
                                                , createAndUpdate
                                                , deleteAll
                                                , truncate
                                                )

spec :: Spec
spec = do
    describe "Mode.Post.getAll" $ do
        it "returns empty posts" $ do
            config <- fromFile
            pool   <- pgPool config
            runSqlPool P.truncate pool
            posts <- runSqlPool P.getAll pool
            posts `shouldBe` []
        it "returns a post" $ do
            config <- fromFile
            pool   <- pgPool config
            flip runSqlPool pool $ do
                P.truncate
                P.create post
            posts <- runSqlPool P.getAll pool
            posts `shouldNotBe` []
            (entityKey . head) posts `shouldBe` postId
            (entityVal . head) posts `shouldBe` post

postId :: PostId
postId = toSqlKey 1

post :: Post
post = Post ""
            (read "2019-12-03 17:39:34.417629 JST" :: UTCTime)
            (read "2019-12-03 17:39:34.417629 JST" :: UTCTime)
