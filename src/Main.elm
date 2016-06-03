port module Main exposing (..)

import Dict exposing (Dict)
import Html exposing (Html, button, div, input, li, span, text, ul)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick, onInput)
import Html.App as App
import Lessons exposing (Lesson, lessons)
import List.Extra exposing (greedyGroupsOf)
import Markdown
import Regex exposing (HowMany(AtMost))
import String


main : Program Never
main =
    App.program
        { init = ( Model "" Valid 0 lessons, Cmd.none )
        , update = update
        , view = view
        , subscriptions = (\_ -> validatedRegex ValidatedRegex)
        }


type ValidState
    = Valid
    | Invalid String


type alias Model =
    { regex : String
    , isValid : ValidState
    , currentLesson : Int
    , lessons : Dict Int Lesson
    }


type Msg
    = ValidateRegex String
    | ValidatedRegex ( String, Bool, String )
    | GoToLesson Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ValidateRegex regex ->
            model ! [ validateRegex regex ]

        ValidatedRegex ( regex, isValid, message ) ->
            let
                validState =
                    if isValid then
                        Valid
                    else
                        Invalid message
            in
                { model | regex = regex, isValid = validState } ! []

        GoToLesson lessonNumber ->
            { model | currentLesson = lessonNumber } ! []


port validateRegex : String -> Cmd msg


port validatedRegex : (( String, Bool, String ) -> msg) -> Sub msg


view : Model -> Html Msg
view model =
    let
        currentLesson =
            Dict.get model.currentLesson model.lessons
    in
        case currentLesson of
            Nothing ->
                div [ class "container" ]
                    [ div [ class "row" ]
                        [ div [ class "three columns" ] [ input [ class "u-full-width", onInput ValidateRegex ] [] ]
                        , div [ class "nine columns" ] [ text "Invalid lesson number!!" ]
                        ]
                    ]

            Just lesson ->
                div [ class "container" ]
                    ([ div [ class "row" ] <| List.map lessonButtonView (Dict.toList model.lessons)
                     , div [ class "row" ]
                        [ div [ class "three columns" ] [ input [ class "u-full-width", onInput ValidateRegex ] [] ]
                        , div [ class "nine columns" ] [ ul [] <| List.map (\message -> li [] [ Markdown.toHtml [] message ]) lesson.reminders ]
                        ]
                     , errorMessageView model.isValid
                     ]
                        ++ testStringsView model lesson.testStrings
                    )


lessonButtonView : ( Int, { a | title : String } ) -> Html Msg
lessonButtonView ( num, { title } ) =
    button [ onClick <| GoToLesson num ]
        [ text title ]


errorMessageView : ValidState -> Html msg
errorMessageView validState =
    case validState of
        Valid ->
            text ""

        Invalid message ->
            div [ class "row" ]
                [ div
                    [ class "twelve columns"
                    , style [ ( "color", "red" ) ]
                    ]
                    [ text message ]
                ]


testStringsView : Model -> List String -> List (Html msg)
testStringsView model testStrings =
    greedyGroupsOf 4 testStrings
        |> List.map (testStringsRowView model)


testStringsRowView : Model -> List String -> Html msg
testStringsRowView model testStrings =
    div [ class "row" ]
        <| List.map (testStringView model) testStrings


testStringView : Model -> String -> Html msg
testStringView model testString =
    let
        testStringHtml =
            if model.regex /= "" && model.isValid == Valid then
                let
                    match =
                        Regex.find (AtMost 1) (Regex.regex model.regex) testString
                            |> List.head
                in
                    case match of
                        Nothing ->
                            [ span [ style [ ( "color", "tomato" ) ] ] [ text testString ] ]

                        Just { index, match } ->
                            [ text <| String.left index testString
                            , span [ style [ ( "color", "green" ), ( "text-decoration", "underline" ) ] ] [ text match ]
                            , text <| String.dropLeft (index + String.length match) testString
                            ]
            else
                [ text testString ]
    in
        div [ class "three columns" ] testStringHtml
