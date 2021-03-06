import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import Html.Events exposing (onInput)

type Msg
  = Count (Result Http.Error String) -- this is either an Http.error or string
  | GetCounter

type alias Model
  = { url : String }


-- view shows us Model
view : Model -> Html Msg -- user interaction
view model =
    div []
    [ button [onClick GetCounter ][ text "Get count" ]
    , div [] [ text (toString model.url) ]
    ]

update : Msg -> Model -> (Model, Cmd Msg) -- What is going to happen
update message model =
    case message of
        Count (Ok value) -> (Model value, Cmd.none) -- if the value is ok update model with value
        Count (Err _) -> (model, Cmd.none)
        GetCounter -> (model, getCount "")

decodeGifUrl : Decode.Decoder String
decodeGifUrl = Decode.at ["data", "url"] Decode.string

getCount : String -> Cmd Msg
getCount topic =
    let
      url ="http://localhost:8084/MySimpleServer/api/counter/" ++ topic
    in
      Http.send Count(Http.get url decodeGifUrl)--viewHallo


main =
  Html.program -- smallest subset I can use, (program is also one)
    { init = (Model "", Cmd.none)
    , view = view      -- a function that takes a model (and creates a view)
    , update = update
    , subscriptions = \x -> Sub.none }
