import Expect
import Test exposing (..)
import Test.Runner.Html

import Ladder exposing (..)

aWinsOverB =
    { winner = "a"
    , loser = "b"
    }

cWinsOverD =
    { winner = "c"
    , loser = "d"
    }

dWinsOverA =
    { winner = "d"
    , loser = "a"
    }

cWinsOverA =
    { winner = "c"
    , loser = "a"
    }

bWinsOverA =
    { winner = "b"
    , loser = "a"
    }

aWinsOverC =
    { winner = "a"
    , loser = "c"
    }

gameTests =
    [ ("Neither on list", aWinsOverB, [], ["a", "b"])
    , ("Winner before loser", aWinsOverB, ["c", "a", "d", "b"], ["c", "a", "d", "b"])
    , ("Loser before winner", aWinsOverB, ["b", "a"], ["a", "b"])
    , ("Only winner on ladder", aWinsOverB, ["c", "a", "d"], ["c", "a", "d", "b"])
    , ("Only loser on ladder", aWinsOverB, ["c", "b"], ["c", "a", "b"])
    ]

testOne (name, game, initial, expected) =
    let
        actual = Ladder.addGame game initial
    in
        test name (\_ -> Expect.equal expected actual)

testLadder1 =
    test "Test creating a ladder from a list of games"
        (\_ -> Expect.equal ["c", "b", "a"] (Ladder.createLadder [aWinsOverB, cWinsOverA, bWinsOverA]))

testLadder2 =
    test "Test creating a ladder from a list of games #2"
        (\_ -> Expect.equal ["d", "a", "b", "c"] (Ladder.createLadder [aWinsOverB, cWinsOverD, dWinsOverA]))

main : Test.Runner.Html.TestProgram
main =
    testLadder1
    :: testLadder2
    :: List.map testOne gameTests
    |> concat
    |> Test.Runner.Html.run
