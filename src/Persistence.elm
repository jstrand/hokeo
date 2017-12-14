module Persistence exposing (saveGames)

-- import Json.Encode exposing (..)
import Json.Decode
import Http exposing (post, send, Error)

import Ladder exposing (Game)

--(Result Http.Error String)
saveGames : List Game -> (Result Error String -> msg) -> Cmd msg
saveGames games msg = 
    post "http://localhost:8000/hokeo/games" Http.emptyBody Json.Decode.string
    |> send msg
