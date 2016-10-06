{-# LANGUAGE FlexibleContexts #-}

module Main where

import Control.Monad (when)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Control.Monad.Reader (MonadReader, runReaderT, asks)
import Data.Maybe (fromMaybe)
import Data.Monoid ((<>))
import Options.Applicative
       (execParser, info, helper, fullDesc, long, short, switch,
        ParserInfo, help, progDesc, subparser, command, optional)
import System.IO (hPutStrLn, stderr)

data Cmd =
    Now
    deriving (Show, Read)

data Options = Options
    { o_verbose :: Bool
    , o_cmd :: Cmd
    } deriving (Show)

programInfo :: ParserInfo Options
programInfo =
    info (helper <*> options) $
    fullDesc <> progDesc "Tasknight command-line interface"
  where
    options =
        Options <$>
        switch
            (long "verbose" <> short 'v' <>
             help "Write to stderr what's happening") <*>
        (fromMaybe Now <$>
         optional
             (subparser $
              command "now" $
              info nowOptions $ progDesc "Show what you can do now (default)"))
    nowOptions = pure Now

main :: IO ()
main = do
    options <- execParser programInfo
    (`runReaderT` options) $ logVerbose $ "Options = " <> show options

logVerbose
    :: (MonadReader Options io, MonadIO io)
    => String -> io ()
logVerbose msg = do
    v <- asks o_verbose
    when v . liftIO $ hPutStrLn stderr msg
