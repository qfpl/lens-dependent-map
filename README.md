<img src="http://i.imgur.com/0h9dFhl.png" width="300px"/>

# Lenses for Dependent Maps

Implementation of some useful typeclasses and functions for using lenses to work with `DMap` structures.

So you can do awesome and delicious things like:

```haskell
|
-- DMap for generic range input attributes
--
import Data.Dependent.Map.Lens (dat)

data MyDMap a where
  AString :: MyDMap String
  AInt    :: MyDMap Int

-- This is okay and sets the value at `AString` to be "fred"
ok = dat AString ?~ "Fred"

-- This is a type error because of the constraints of our DMap that carry through to our lenses! Yay!
no = dat AInt ?~ "33"
```

The functions and typeclasses are all a shameless imitation of their
counterparts in [`Control.Lens.At`](https://hackage.haskell.org/package/lens-4.16.1/docs/Control-Lens-At.html),
with a `D` prefix. So `ix` becomes `dix` and the constraint `At` becomes `DAt`.

This is still very very very new package so it may be deprecated by a superior solution or change rapidly. :)
