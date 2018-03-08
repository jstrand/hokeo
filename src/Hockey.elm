module Main exposing (..)

import Html exposing (Html, button, div, h2, input, li, text, ul)
import Html.Attributes exposing (disabled, value)
import Html.Events exposing (onClick, onInput)
import Http
import Ladder
import Persistence exposing (loadGames, saveGames)


type alias Model =
    { games : List Ladder.Game
    , winner : String
    , loser : String
    , serverError : Maybe String
    }


setError : Http.Error -> Model -> Model
setError error model =
    { model | serverError = Just (toString error) }


init : ( Model, Cmd Msg )
init =
    ( { games = []
      , winner = ""
      , loser = ""
      , serverError = Nothing
      }
    , loadGames Load
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


type Msg
    = TypeWinner String
    | TypeLoser String
    | Add
    | Load (Result Http.Error (List Ladder.Game))
    | Save (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TypeWinner player ->
            ( { model | winner = player }, Cmd.none )

        TypeLoser player ->
            ( { model | loser = player }, Cmd.none )

        Load (Ok games) ->
            ( { model | games = games }, Cmd.none )

        Load (Result.Err error) ->
            ( setError error model, Cmd.none )

        Add ->
            let
                newGames =
                    model.games ++ [ { winner = model.winner, loser = model.loser } ]
            in
            ( { model
                | winner = ""
                , loser = ""
                , games = newGames
              }
            , saveGames newGames Save
            )

        Save (Ok _) ->
            ( { model | serverError = Nothing }, Cmd.none )

        Save (Result.Err error) ->
            ( setError error model, Cmd.none )


viewGame : a -> Html msg
viewGame game =
    li [] [ text <| toString game ]


viewGames : List a -> Html msg
viewGames =
    ul [] << List.map viewGame


viewPlayer : String -> Html msg
viewPlayer player =
    li [] [ text player ]


viewLadder : List String -> Html msg
viewLadder ladder =
    ul [] <| List.map viewPlayer ladder


viewError : Maybe String -> Html Msg
viewError message =
    Maybe.withDefault "" message
        |> Html.text


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text "Winner" ]
        , input [ onInput TypeWinner, value model.winner ] []
        , div [] [ text "Loser" ]
        , input [ onInput TypeLoser, value model.loser ] []
        , button [ onClick Add ] [ text "Add" ]

        --, viewGames model.games
        , h2 [] [ text "Stege" ]
        , viewLadder <| Ladder.createLadder model.games
        , viewError model.serverError
        ]


main : Program Never Model Msg
main =
    Html.program { init = init, view = view, update = update, subscriptions = subscriptions }
