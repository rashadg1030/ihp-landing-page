module Main where

import Test.Hspec
import IHP.Prelude

import Test.Controller.ParagraphCta
import Test.SanitizeHtml

main :: IO ()
main = hspec do
    Test.Controller.ParagraphCta.tests
    Test.SanitizeHtml.tests
