module Main exposing (..)


import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket exposing (..)
import Json.Decode exposing (..)


type alias Model =
    Int


type Msg
    = AddSomething
    | ShortcutInput String
    | Clear


initModel: Model
initModel =
    3


update : Msg -> Model -> Model
update msg model =
    case msg of
        ShortcutInput amt ->
            model + (String.toInt amt |> Result.withDefault 0)
        AddSomething ->
            model + 1
        Clear ->
            initModel


view : Model -> Html Msg
view model =
    div []
        [ h3 []
            [ text (toString model)]
        , input [ onInput ShortcutInput  ] []
        , button
            [ type_ "button"
            , onClick AddSomething ]
            [ text "Add"]
        , button
            [ type_ "button"
            , onClick Clear
            ]
            [ text "Clear"]
        ]

main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initModel
        , update = update
        , view = view
        }
