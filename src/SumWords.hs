module SumWords (sumArgs, sumWords) where

import Data.List.Extra (trim)
import Data.Char (isDigit, isSpace)

spreadAnd :: (a -> Bool) -> (a -> Bool) -> a -> Bool
spreadAnd test1 test2 x = test1 x && test2 x

parseSumArgs :: [String] -> Maybe String
parseSumArgs args
  | size == 0       = Nothing
  | hasNonDigits xs = Nothing
  | size == 1       = Just (head xs)
  | otherwise       = Just (unwords xs)
  where size         = length xs
        hasNonDigits = any invalidChar . unwords
        xs           = filter (not . null) $ map trim args
        invalidChar  = spreadAnd (not . isSpace) (not . isDigit)

sumWords :: String -> String
sumWords = show . sum . map read . words

sumArgs :: String -> [String] -> String
sumArgs def = maybe def sumWords . parseSumArgs
