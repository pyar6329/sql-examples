module Model.Internal where

import           Config                         ( Config
                                                , Postgres
                                                , postgres
                                                , postgresConf
                                                )
import           Control.Applicative
import           Control.Lens                   ( (^.) )
import           Control.Monad.Logger           ( runStdoutLoggingT )
import           Data.Text.Encoding             ( decodeUtf8
                                                , encodeUtf8
                                                )
import           Database.Persist
import           Database.Persist.Postgresql
import           Database.Persist.TH
import           Database.Persist.Types

pgPool :: Config -> IO ConnectionPool
pgPool config =
    let connection = encodeUtf8 . postgresConf $ config ^. postgres
    in  runStdoutLoggingT $ createPostgresqlPool connection 10
