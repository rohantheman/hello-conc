module HelloChan.Control.HasNumber
  ( HasNumber(..)
  ) where

class Monad m => HasNumber m where
  getNumber :: m Int
  putNumber :: Int -> m ()