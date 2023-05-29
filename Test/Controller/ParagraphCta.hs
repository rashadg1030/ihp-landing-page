module Test.Controller.ParagraphCta where

import Network.HTTP.Types.Status

import IHP.Prelude
import IHP.QueryBuilder (query)
import IHP.Test.Mocking
import IHP.Fetch

import IHP.FrameworkConfig
import IHP.HaskellSupport
import IHP.ModelSupport
import Test.Hspec
import Config

import Generated.Types
import Web.Routes
import Web.Types
import Web.FrontController
import Web.Controller.ParagraphCtas
import Network.Wai
import IHP.ControllerPrelude

import Text.HTML.TagSoup
import Text.HTML.TagSoup.Match

tests :: Spec
tests = aroundAll (withIHPApp WebApplication config) do
        describe "ParagraphCta View (via LandingPages)" do
            it "Create 2 landing pages (1 for CTA and 1 for reference) and 1 CTA.\nThen check that only saniitzed HTML is shown." $ withContext do
                testLandingPage <- newRecord @LandingPage |> createRecord
                testRefLandingPage <- newRecord @LandingPage |> createRecord

                count <- query @LandingPage |> fetchCount
                count `shouldBe` 2

                _ <- callActionWithParams
                        CreateParagraphCtaAction
                        [ ("landingPageId", idToParam testLandingPage.id)
                        , ("weight", "0") -- Irrelevant so setting to 0
                        , ("title", "Malicious CTA")
                        , ("body", "<script>doBadStuff()</script>")
                        , ("refLandingPageId", idToParam testRefLandingPage.id)
                        ]
                
                count <- query @ParagraphCta |> fetchCount
                count `shouldBe` 1

                response <- mockAction (ShowLandingPageAction testLandingPage.id)

                response `responseStatusShouldBe` status200

                -- -- For debugging purposes you could do the following, to
                -- -- see the HTML printed out on the terminal.
                body <- responseBody response

                let ctaBody = parseTags body
                        |> getTagContent "div" ([("class", "prose md:prose-lg lg:prose-xl prose-headings:text-gray-700 max-w-3xl")] ==)
                        |> innerText 

                ctaBody `shouldBe` ""
