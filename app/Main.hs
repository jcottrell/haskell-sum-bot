module Main where

import System.Environment
import Lib (sumWords)

main :: IO ()
main =
  getArgs >>=
  putStrLn . sumWords . head
