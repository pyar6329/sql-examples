{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings #-}
module Model.Post
    ( Post(..)
    , PostId
    , EntityField(PostId)
    , get
    , getAll
    , create
    , createAndUpdate
    , deleteAll
    , truncate
    )
where

import           Prelude                 hiding ( truncate )
import           Control.Monad.Reader           ( ReaderT )
import           Control.Monad.IO.Class         ( MonadIO )
import           Data.Text                      ( Text )
import           Data.List                      ( find )
import           Database.Persist               ( Entity
                                                , selectFirst
                                                , selectList
                                                , insertEntity
                                                , putMany
                                                , (==.)
                                                , entityVal
                                                , entityKey
                                                )
import           Database.Persist.Postgresql    ( SqlBackend )
import           Database.Esqueleto             ( delete
                                                , from
                                                , rawExecute
                                                , SqlExpr
                                                )
import           Model.Schema                   ( Post(..)
                                                , PostId
                                                , EntityField(PostId)
                                                )

get :: MonadIO m => PostId -> ReaderT SqlBackend m (Maybe (Entity Post))
get postId = selectFirst [PostId ==. postId] []

getAll :: MonadIO m => ReaderT SqlBackend m [Entity Post]
getAll = selectList [] []

create :: MonadIO m => Post -> ReaderT SqlBackend m (Entity Post)
create = insertEntity

createAndUpdate :: MonadIO m => [Post] -> ReaderT SqlBackend m ()
createAndUpdate = putMany

deleteAll :: MonadIO m => ReaderT SqlBackend m ()
deleteAll = delete $ from $ \(post :: SqlExpr (Entity Post)) -> return ()

truncate :: MonadIO m => ReaderT SqlBackend m ()
truncate = do
    rawExecute
        "SELECT SETVAL ('posts_id_seq', 1, FALSE); TRUNCATE TABLE posts;"
        []
    return ()
