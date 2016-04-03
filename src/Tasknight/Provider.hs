module Tasknight.Provider (Item(..), ItemList(..), Provider(..)) where

import Control.Error (Script)
import Data.Text (Text)

data Item = Item Text

data ItemList = ItemList { name :: String, items :: [Item] }

data Provider = Provider { getLists :: Script [ItemList] }
