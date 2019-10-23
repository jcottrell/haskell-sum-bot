# haskell-sum-bot
Playing around with compiling haskell. The app just add together the arguments sent to it.

## Resources
[Stack guide](https://docs.haskellstack.org/en/stable/GUIDE/)  
The useful part of this guide were the following commands:
+ `stack new haskell-sum-bot new-template` to create a new project directory named haskell-sum-bot
+ `stack setup` to setup stack for building (as far as I can tell).
+ `stack build` actually build the app into an executable.
+ `stack ghci` loads the app for testing.
+ `stack exec haskell-sum-bot-exe 1 2 3` to run the executable last created with inputs of `1 2 3`.
+ I was also able to track down the built executable in `.stack-work/dist/` (etc. according to the OS) to copy to places I might use the executable.

## Iterations
From [Tsoding's first HaskellRank video](https://www.youtube.com/watch?v=h_D4P-KRNKs) I was hoping to use `interact` with
```haskell
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
I tried _do notation_ next.
```haskell
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
```haskell
main =
  getArgs >>=
  (\args -> putStrLn $ (sumWords.head) args)
```
Thankfully `hlint` was installed and suggested
```haskell
main =
  getArgs >>=
  putStrLn . sumWords . head
```
Either of these last two run the same way (see above).

It's significantly faster if you copy the _exe_ file to somewhere useful and run it directly
```
λ > cp .stack-work/dist/x86_64-osx/Cabal-2.4.0.1/build/haskell-sum-bot-exe/haskell-sum-bot-exe ./
```
Then run it with
```
λ > ./haskell-sum-bot-exe "1 2 3"
```

Next, I tried to make it _safe_ by adding defaults (via Maybe) and parsing the incoming arguments.

I organized a little by moving more to the library (now `src/SumWords.hs`).

Now it will handle failure nicely for non-numbers, empty arguments, and no arguments with a default of zero (0).

It will also total a single argument passed as `"1 2 3"` as well as several arguments passed as `1 2 3` or even `"1 23  4    55 6 "` (spaces between and after numbers).

Main then looked like (see below for dependancy additions)
```haskell
main =
  getArgs >>=
  putStrLn . sumArgs "0"
```

But _do notation_ is good to know so now main looks like
```haskell
main = do
  args <- getArgs
  putStrLn (sumArgs "0" args)
```

## Adding other libraries
I added `Data.List.Extra` and `Data.Char` to help parse the arguments. There are directions on the Stack guide linked above, "If you need to include another library" etc. Basically, add the package to the `dependencies` section at the far-left of the `package.yaml` file. Mine was added directly beneath `- base >= 4.7 && < 5` in the same format, i.e.
```yaml
dependencies:
- base >= 4.7 && < 5
- extra
```

## Examples calls
```
λ > stack exec haskell-sum-bot "1 2 3"
6
```
```
λ > stack exec haskell-sum-bot 1 2 3
6
```
```
λ > stack exec haskell-sum-bot "1 2   3  "
6
```
```
λ > stack exec haskell-sum-bot "1 2w 3"
0
```
