import Html exposing (Html, input, div, text, button, ul, li, h2)
import Html.Events exposing (onInput, onClick)
import Html.Attributes exposing (disabled, value)

import Ladder exposing (..)

import Persistence exposing (saveGames)
import Http

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

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

type Msg =
      TypeWinner String
    | TypeLoser String
    | Add
    | Save (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    TypeWinner player ->
        ({ model | winner = player}, Cmd.none)
    TypeLoser player ->
        ({ model | loser = player }, Cmd.none)
    Add ->
        ({ model
        | winner = ""
        , loser = ""
        , games = model.games ++ [{winner = model.winner, loser = model.loser}]
        }
        , saveGames [] Save)
    Save _ -> (model, Cmd.none)

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
    , h2 [] [text "Stege"]
    , viewLadder <| createLadder model.games
    ]


main : Program Never Model Msg
main =
  Html.program { init = (init, Cmd.none), view = view, update = update, subscriptions = subscriptions }
