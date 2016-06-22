module Main where

import Lib

getKeyword :: [String] -> Either String String
getKeyword [] = Left "Keywords empty."
getKeyword [x] = Right x
getKeyword (x:xs) = Left "Too many keywords."

main :: IO ()
main = loop

loop = do
  putStrLn "Please, type keyword for seach in twitter or q for quit: "
  kw <- getLine
  case getKeyword (words kw) of
    Left str ->  putStrLn str >> putStrLn "Try again." >> loop
    Right x -> if x == "q" then putStrLn "Bye!" else  someFunc x >> loop
