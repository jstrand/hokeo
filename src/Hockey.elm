import Html exposing (Html, input, div, text, button, ul, li, h2)
import Html.Events exposing (onInput, onClick)
import Html.Attributes exposing (disabled, value)

import Ladder exposing (..)

type alias Model =
  { games : List Game
  , winner : String
  , loser : String
  }

init : Model
init =
  { games = []
  , winner = ""
  , loser = ""
  }

main =
  Html.beginnerProgram { model = init, view = view, update = update }

type Msg =
      TypeWinner String
    | TypeLoser String
    | Add

update msg model =
  case msg of
    TypeWinner player ->
        { model | winner = player}
    TypeLoser player ->
        { model | loser = player }
    Add ->
        { model
        | winner = ""
        , loser = ""
        , games = model.games ++ [{winner = model.winner, loser = model.loser}]
        }

viewGame game = li [] [text <| toString game]

viewGames = ul [] << List.map viewGame

viewPlayer player = li [] [text player]
viewLadder ladder = ul [] <| List.map viewPlayer ladder

view model =
  div []
    [ div [] [ text "Winner" ]
    , input [onInput TypeWinner, value model.winner] [ ]
    , div [] [ text "Loser" ]
    , input [onInput TypeLoser, value model.loser] [ ]
    , button [onClick Add] [text "Add"]
    --, viewGames model.games
    , h2 [] [text "Bordshockeystege"]
    , viewLadder <| createLadder model.games
    ]
