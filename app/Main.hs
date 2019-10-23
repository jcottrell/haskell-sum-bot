module Main where

import System.Environment
import SumWords (sumArgs)

main :: IO ()
main = do
  args <- getArgs
  putStrLn (sumArgs "0" args)
