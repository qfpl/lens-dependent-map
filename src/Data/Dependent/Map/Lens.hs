{-# LANGUAGE DefaultSignatures #-}
{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE RankNTypes        #-}
{-# LANGUAGE TypeFamilies      #-}
-- | An extension of the typeclasses and functions that are available in
-- 'Control.Lens.At' for use with the 'Data.Dependent.Map.DMap' type.
module Data.Dependent.Map.Lens
  ( DAt (..)
  , DIxed (..)
  , ValF (..)
  , KeyF (..)
  , dsans
  , diat
  , diix
  ) where

import           Control.Applicative (Applicative)
import           Control.Lens       (IndexedLens', IndexedTraversal', Lens',
                                     LensLike', Traversal', indexed, (.~),
                                     (<&>))

import           Data.Traversable   (traverse)

import           Data.Dependent.Map (DMap, GCompare)
import qualified Data.Dependent.Map as DM

-- | Type family to define the constructor for the value wrapper of the 'DMap'
type family ValF w :: * -> *

-- |  Type family for defining the type of the key index type for the 'DMap'
type family KeyF w :: * -> *

-- | Provides a simple Traversal lets you traverse the value at a given key in a @DMap@.
class DIxed m where
  -- |
  -- /NB:/ Setting the value of this 'Traversal' will only set the value in
  -- 'at' if it is already present.
  --
  -- If you want to be able to insert /missing/ values, you want 'dat'.
  dix :: KeyF m v -> Traversal' m (ValF m v)

  default dix :: (Applicative f, DAt m) => KeyF m v -> LensLike' f m (ValF m v)
  dix k = dat k . traverse
  {-# INLINE dix #-}

-- | 'DAt' provides a 'Lens' that can be used to read,
-- write or delete the value associated with a key in a 'DMap'-like
-- container on an ad hoc basis.
--
-- An instance of 'DAt' should satisfy:
--
-- @
-- 'dix' k ≡ 'dat' k '.' 'traverse'
-- @
class DIxed m => DAt m where
  dat :: KeyF m v -> Lens' m (Maybe (ValF m v))

type instance ValF (DMap k f) = f
type instance KeyF (DMap k f) = k

instance (Functor f, GCompare k) => DIxed (DMap k f) where
instance (Functor f, GCompare k) => DAt (DMap k f) where
  -- This is the way to do it, until `alterF` is merged into Data.Dependent.Map
  dat k f dm = f (DM.lookup k dm) <&> \v' -> DM.alter (const v') k dm
  {-# INLINE dat #-}

dsans :: DAt m => KeyF m v -> m -> m
dsans k = dat k .~ Nothing
{-# INLINE dsans #-}

diat :: DAt m => KeyF m v -> IndexedLens' (KeyF m v) m (Maybe (ValF m v))
diat k f = dat k (indexed f k)
{-# INLINE diat #-}

diix :: DIxed m => KeyF m v -> IndexedTraversal' (KeyF m v) m (ValF m v)
diix k f = dix k (indexed f k)
{-# INLINE diix #-}
