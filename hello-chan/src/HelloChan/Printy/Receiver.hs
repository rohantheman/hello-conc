module HelloChan.Printy.Receiver
  ( Receiver(..)
  ) where

import Data.Text (Text)

class Monad m => Receiver m where
  receiveMessage :: m Text