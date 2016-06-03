module Lessons exposing (..)

import Dict


type alias Lesson =
    { title : String
    , reminders : List String
    , testStrings : List String
    }


commonTestStrings =
    [ "a"
    , "aa"
    , "aaa"
    , "aaaa"
    , "b"
    , "bb"
    , "bbb"
    , "bbbb"
    , "c"
    , "cc"
    , "ccc"
    , "cccc"
    , "aab"
    , "abb"
    , "abc"
    , "cab"
    , "A"
    , "AAA"
    , "aAa"
    , "aAAa"
    , "aAaA"
    , "abcabc"
    , "aBc"
    , "0123456789"
    , "These are some words"
    , "snake_case_1"
    , "dash-case-1"
    , "\\^$*+?.()[]{}"
    , "function()"
    , "function(arg)"
    , "arr[]"
    , "arr[i]"
    ]


lessons =
    [ { title = "Simple"
      , reminders =
            [ "Simple characters just match that character"
            , "Some characters (`\\^$*+?.()[]{}`) can have a special meaning and must be escaped"
            ]
      , testStrings = commonTestStrings
      }
    , { title = "Dot"
      , reminders =
            [ "The `.` character matches any single character (besides `\\n`)"
            ]
      , testStrings = commonTestStrings
      }
    , { title = "Anchors"
      , reminders =
            [ "`^` matches the beginning of the string"
            , "`$` matches the end of the string"
            ]
      , testStrings = commonTestStrings
      }
    , { title = "Character Sets"
      , reminders =
            [ "Characters enclosed in `[]` will match any one of those characters"
            , "A range of characters can be specified with a hyphen `[a-z]`"
            , "There are pre-defined character sets (and their inverses) for: numbers (`\\d`/`\\D`), whitespace (`\\s`/`\\S`), and word characters (`\\w`/`\\W`)"
            ]
      , testStrings = commonTestStrings
      }
    , { title = "Grouping/Options"
      , reminders =
            [ "Characters enclosed in `()` will match as a group"
            , "Inside `()`, `|` will match one group OR another"
            ]
      , testStrings = commonTestStrings
      }
    , { title = "Collectors"
      , reminders =
            [ "`*` matches 0 or more"
            , "`+` matches 1 or more"
            , "`?` matches 0 or 1"
            , "`{n}` matches n in a row"
            , "`{n,m}` matches n to m in a row"
            , "All collectors are \"greedy\""
            , "`?` after a collector makes it \"non-greedy\""
            ]
      , testStrings = commonTestStrings
      }
    , { title = "Backreferences"
      , reminders =
            [ "Characters enclosed in `()` will match as a group"
            , "`\\#` (where # is an int) matches the nth group in the regex"
            ]
      , testStrings = commonTestStrings
      }
    , { title = "Gotchas"
      , reminders =
            [ "Be careful not to match \"nothing\""
            , "Be careful when using character ranges"
            ]
      , testStrings = commonTestStrings
      }
    , { title = "Ex) Phone Numbers"
      , reminders =
            []
      , testStrings =
            [ "3124567890"
            , "31245678901"
            , "312-456-7890"
            , "312 456-7890"
            , "312456-7890"
            , "312 456 7890"
            , "(312)-456-7890"
            , "(312) 456-7890"
            , "(312)456-7890"
            , "(312 456-7890"
            , "(312) 456 - 7890"
            , ")312( 456-7890"
            , "phone3124567890number"
            ]
      }
    , { title = "Ex) Dates"
      , reminders =
            []
      , testStrings =
            [ "7/4/2016"
            , "07/04/2016"
            , "7/04/2016"
            , "07/4/2016"
            , "7/4/16"
            , "7-4-2016"
            , "07-04-2016"
            , "7-04-2016"
            , "07-4-2016"
            , "7-4-16"
            , "7\\4\\2016"
            , "07\\04\\2016"
            , "7\\04\\2016"
            , "07\\4\\2016"
            , "7\\4\\16"
            , "39/42/2016"
            , "2/30/2016"
            ]
      }
    ]
        |> List.indexedMap (,)
        |> Dict.fromList
