module Persistence exposing (loadGames, saveGames)

import Json.Decode
import Json.Encode
import Http

import Ladder exposing (Game)

url = "http://localhost:8001/hokeo/games"

encodeGame : Game -> Json.Encode.Value
encodeGame game =
    Json.Encode.object
        [ ("winner", Json.Encode.string game.winner)
        , ("loser", Json.Encode.string game.loser)
        ]

encodeGames : List Game -> Json.Encode.Value
encodeGames =
    List.map encodeGame
    >> Json.Encode.list

gamesAsBody : List Game -> Http.Body
gamesAsBody = Http.jsonBody << encodeGames

decodeGame : Json.Decode.Decoder Game
decodeGame =
    Json.Decode.map2 Game
        (Json.Decode.field "winner" Json.Decode.string)
        (Json.Decode.field "loser" Json.Decode.string)

decodeGames : Json.Decode.Decoder (List Game)
decodeGames = Json.Decode.list decodeGame        

saveGames : List Game -> (Result Http.Error String -> msg) -> Cmd msg
saveGames games callback =
    let body = gamesAsBody games
    in
    Http.send callback
    <| Http.post url body Json.Decode.string

loadGames : (Result Http.Error (List Game) -> msg) -> Cmd msg
loadGames callback =
    Http.send callback
    <| Http.get url decodeGames
