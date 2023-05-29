module Web.Controller.StyleGuide where

import IHP.ControllerPrelude
import Web.View.StyleGuide.Show
import Data.Attoparsec

data StyleGuideController = ShowStyleGuideAction deriving (Eq, Show, Data)

instance CanRoute StyleGuideController where
    parseRoute' = string "/StyleGuide" <* endOfInput >> pure ShowStyleGuideAction

instance HasPath StyleGuideController where
    pathTo ShowStyleGuideAction = "/StyleGuide"

instance Controller StyleGuideController where
    action ShowStyleGuideAction = render ShowView
