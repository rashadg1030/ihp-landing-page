module Test.SanitizeHtml where

import Test.Hspec
import Web.Controller.ParagraphCtas

tests :: Spec
tests = describe "sanitizeHtml" do
    it "Removes inline scripts" do
        sanitizeHtml "<script>some1337Script(); doMoreHackerStuff();</script>" `shouldBe` ""
        sanitizeHtml "<div><h1>GoodStuff</h1></div><script type=\"text/javascript\">var adr = '../evil.php?cakemonster=' + escape(document.cookie);</script>" `shouldBe` "<div><h1>GoodStuff</h1></div>"
    it "Sanitizes XSS Using Script Via Encoded URI Schemes" do
        sanitizeHtml "<html><body><img src=j&#X41vascript:alert('test2')></body></html>" `shouldBe` "<img>"
    it "Sanitizes XSS Using Code Encoding" do
        sanitizeHtml "<html><head><meta http-equiv=\"refresh\" content=\"0;url=data:text/html;base64,PHNjcmlwdD5hbGVydCgndGVzdDMnKTwvc2NyaXB0Pg\"></head><body>Hello</body></html>" `shouldBe` "Hello"