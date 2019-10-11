module Lib (sumWords) where

sumWords :: String -> String
sumWords = show . sum . map read . words
