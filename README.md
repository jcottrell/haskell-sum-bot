# haskell-sum-bot
Playing around with compiling haskell

## Resources
[Stack guide](https://docs.haskellstack.org/en/stable/GUIDE/)

##Iterations
From [Tsoding's first HaskellRank video](https://www.youtube.com/watch?v=h_D4P-KRNKs) I was hoping to use `interact` with
```
main = interact sumWords
```
That was a wash, in my mind because I had to run it with
```
λ > stack exec haskell-sum-bot-exe
```
Then enter the input numbers (`1 2 3`), hit Enter, hit Ctrl-D (on a mac) so the whole thing looked like
```
λ > stack exec haskell-sum-bot-exe
1 2 3
6D
```
I tried _Do notation_ next.
```
main = do
  args <- getArgs
  putStrLn $ (sumWords.head) args
```
The command and its output became
```
λ > stack exec haskell-sum-bot-exe "1 2 3"
6

```
Finally I tried to desugar the _do notation_ and with
```
main =
  getArgs >>=
  (\args -> putStrLn $ (sumWords.head) args)
```
Thankfully `hlint` was installed and suggested
```
main =
  getArgs >>=
  putStrLn . sumWords . head
```
Either of these last two run the same way (see above).

It's significantly faster if you copy the _exe_ file to somewhere useful and run it directly
```
cp .stack-work/dist/x86_64-osx/Cabal-2.4.0.1/build/haskell-sum-bot-exe/haskell-sum-bot-exe ./
```
Then run it with
```
./haskell-sum-bot-exe "1 2 3"
```