import Html exposing (Html, input, div, text, button, ul, li, h2)
import Html.Events exposing (onInput, onClick)
import Html.Attributes exposing (disabled, value)

import Ladder exposing (..)

import Persistence exposing (loadGames, saveGames)
import Http

type alias Model =
  { games : List Game
  , winner : String
  , loser : String
  , serverError : Maybe String
  }

setError : Http.Error -> Model -> Model
setError error model = { model | serverError = (Just (toString error)) }

init : (Model, Cmd Msg)
init =
  (
  { games = []
  , winner = ""
  , loser = ""
  , serverError = Nothing
  }
  , loadGames Load
  )

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

type Msg =
      TypeWinner String
    | TypeLoser String
    | Add
    | Load (Result Http.Error (List Game))
    | Save (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    TypeWinner player ->
        ({ model | winner = player}, Cmd.none)
    TypeLoser player ->
        ({ model | loser = player }, Cmd.none)
    Load (Ok games) -> ({ model | games = games}, Cmd.none)
    Load (Result.Err error) -> (setError error model, Cmd.none)
    Add ->
        let newGames = model.games ++ [{winner = model.winner, loser = model.loser}]
        in
        ({ model
        | winner = ""
        , loser = ""
        , games = newGames
        }
        , saveGames newGames Save)
    Save (Ok _) -> ({ model | serverError = Nothing }, Cmd.none)
    Save (Result.Err error) -> (setError error model, Cmd.none)

viewGame game = li [] [text <| toString game]

viewGames = ul [] << List.map viewGame

viewPlayer player = li [] [text player]
viewLadder ladder = ul [] <| List.map viewPlayer ladder

viewError : Maybe String -> Html Msg
viewError message =
  Maybe.withDefault "" message
  |> Html.text

view : Model -> Html Msg
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
    , viewError model.serverError
    ]


main : Program Never Model Msg
main =
  Html.program { init = init, view = view, update = update, subscriptions = subscriptions }
