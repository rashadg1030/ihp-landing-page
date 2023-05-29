module Web.View.StyleGuide.Show where

import Web.View.Prelude
import Web.Element.Types
import Web.Element.ElementWrap
import Web.Element.InnerElementLayout
import Data.Text qualified as Text
import IHP.ViewSupport
import Control.Monad.Free (MonadFree(wrap))

data ShowView = ShowView

instance View ShowView where
    html ShowView = [hsx|
        <div class="mx-8 my-8">
            <h1 class="text-2xl font-bold underline">Style Guide</h1>

            <div class="my-8">
                <h2 class="text-lg font-semibold">Single Profile Card</h2>
                <ul class="flex">
                    {renderCard False janeCooper}
                </ul>
                <hr class="my-8">
                <h2 class="text-lg font-semibold">Profile Card Grid</h2>
                {repeat janeCooper |> take 10 |> renderCardGrid}
            </div>
        </div>
    |]

data Card = Card
    { image :: Text
    , name :: Text
    , title :: Text
    , role :: Text
    , email :: Text
    , phone :: Text
    }

makeCard :: Text -> Text -> Text -> Text -> Text -> Card
makeCard image name title role phone =
    let
        email =
            name
            |> Text.toLower
            |> Text.words
            |> Text.concat
            |> (\t -> t <> "@example.com")
    in Card {..}

janeCooper :: Card
janeCooper = makeCard
    "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=4&w=256&h=256&q=60"
    "Jane Cooper"
    "Paradigm Representative"
    "Admin"
    "+1-202-555-0170"

renderCard :: Bool -> Card -> Html
renderCard grow Card {..} = [hsx|
    <li class="col-span-1 flex flex-col divide-y divide-gray-200 rounded-lg bg-white text-center shadow">
        <div class="flex flex-1 flex-col p-8">
            <img class="mx-auto h-32 w-32 flex-shrink-0 rounded-full" src={image} alt="">
            <h3 class="mt-6 text-sm font-medium text-gray-900">{name}</h3>
            <dl class="mt-1 flex flex-grow flex-col justify-between">
                <dt class="sr-only">Title</dt>
                <dd class="text-sm text-gray-500">{title}</dd>
                <dt class="sr-only">Role</dt>
                <dd class="mt-3">
                    <span class="inline-flex items-center rounded-full bg-green-50 px-2 py-1 text-xs font-medium text-green-700 ring-1 ring-inset ring-green-600/20">
                        {role}
                    </span>
                </dd>
            </dl>
        </div>
        <div>
            <div class="-mt-px flex divide-x divide-gray-200">
                <div class="flex w-0 flex-1">
                <a href="mailto:{email}" class="relative -mr-px inline-flex w-0 flex-1 items-center justify-center gap-x-3 rounded-bl-lg border border-transparent py-4 text-sm font-semibold text-gray-900">
                    <svg class="h-5 w-5 text-gray-400" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                    <path d="M3 4a2 2 0 00-2 2v1.161l8.441 4.221a1.25 1.25 0 001.118 0L19 7.162V6a2 2 0 00-2-2H3z" />
                    <path d="M19 8.839l-7.77 3.885a2.75 2.75 0 01-2.46 0L1 8.839V14a2 2 0 002 2h14a2 2 0 002-2V8.839z" />
                    </svg>
                    Email
                </a>
                </div>
                <div class="-ml-px flex w-0 flex-1">
                <a href="tel:{phone}" class="relative inline-flex w-0 flex-1 items-center justify-center gap-x-3 rounded-br-lg border border-transparent py-4 text-sm font-semibold text-gray-900">
                    <svg class="h-5 w-5 text-gray-400" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                    <path fill-rule="evenodd" d="M2 3.5A1.5 1.5 0 013.5 2h1.148a1.5 1.5 0 011.465 1.175l.716 3.223a1.5 1.5 0 01-1.052 1.767l-.933.267c-.41.117-.643.555-.48.95a11.542 11.542 0 006.254 6.254c.395.163.833-.07.95-.48l.267-.933a1.5 1.5 0 011.767-1.052l3.223.716A1.5 1.5 0 0118 15.352V16.5a1.5 1.5 0 01-1.5 1.5H15c-1.149 0-2.263-.15-3.326-.43A13.022 13.022 0 012.43 8.326 13.019 13.019 0 012 5V3.5z" clip-rule="evenodd" />
                    </svg>
                    Call
                </a>
                </div>
            </div>
        </div>
    </li>
|]

renderCardGrid :: [Card] -> Html
renderCardGrid cards = [hsx|
        <ul role="list" class="grid grid-cols-1 gap-6 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5">
            {forEach cards (renderCard True)}
        </ul>
    |]
