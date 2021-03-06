module HelloChan.Print
  ( Console(..)
  , Receiver(..)
  , main
  , step
  , PrintM
  , runIO
  ) where

import Control.Monad (join, forever)
import Control.Monad.Error.Class (MonadError)
import Control.Monad.Reader (MonadReader(..), ReaderT, runReaderT)
import Control.Monad.IO.Class (MonadIO(..))
import Control.Exception.Safe (MonadCatch, MonadThrow)
import Control.Monad.Except (ExceptT(..), runExceptT)
import qualified Data.Text.IO as T (putStrLn)
import Data.Text (Text, unpack)

class Monad m => Console m where
  writeLine :: Text -> m ()

class Monad m => Receiver m where
  receiveMessage :: m Text


main :: (Console m, Receiver m) => m ()
main = forever step

step :: (Console m, Receiver m) => m ()
step = do
  message <- receiveMessage
  writeLine message


newtype PrintM a = PrintM { unPrintM :: ReaderT (IO Text) (ExceptT Text IO) a }
  deriving (Functor, Applicative, Monad, MonadIO, MonadError Text, MonadCatch, MonadThrow, MonadReader (IO Text))

runIO :: MonadIO m => PrintM a -> IO Text -> m a
runIO (PrintM m) receive = liftIO $ do
  result <- runExceptT (runReaderT m receive)
  either (error . unpack) return result

instance Console PrintM where
  writeLine = liftIO . T.putStrLn

instance Receiver PrintM where
  receiveMessage = ask >>= \recvMsg -> liftIO recvMsg
