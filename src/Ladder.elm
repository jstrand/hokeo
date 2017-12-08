module Ladder exposing (Player, Game, addGame, createLadder)

import List.Extra exposing (elemIndex, splitAt, remove)

type alias Player = String

type alias Game =
    { winner : Player
    , loser : Player
    }

type alias Ladder = List Player

moveUp : Player -> Int -> Ladder -> Ladder
moveUp winner moveTo ladder =
    let
        (before, after) = splitAt moveTo ladder
    in
        before ++ [winner] ++ remove winner after

addGame : Game -> Ladder -> Ladder
addGame {winner, loser} ladder =
    let
        maybeWinner = elemIndex winner ladder
        maybeLoser = elemIndex loser ladder
    in
        case (maybeWinner, maybeLoser) of
            (Nothing, Nothing ) ->
                ladder ++ [winner, loser]

            (Just _, Nothing) ->
                ladder ++ [loser]

            (Nothing, Just loserIndex) ->
                moveUp winner loserIndex ladder
            
            (Just winnerIndex, Just loserIndex) ->
                if loserIndex < winnerIndex then
                    moveUp winner loserIndex ladder
                else
                    ladder

createLadder : List Game -> Ladder
createLadder = List.foldl addGame []
