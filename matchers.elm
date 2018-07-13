import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket



main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


echoServer : String
echoServer =
  "wss://echo.websocket.org"



-- MODEL


type alias Model =
  { input : String
  , messages : List String
  , matchesCounter : Int
  , gameText : String
  , matchesPull : Int
  , gameConsole : List String
  }


init : (Model, Cmd Msg)
init =
  (Model "", 0, "", 0, "", Cmd.none )



-- UPDATE


type Msg
  = Input String
  | Send
  | NewMessage String



update : Msg -> Model -> (Model, Cmd Msg)
update msg {input, messages} =
  case msg of
    Input newInput ->
      (Model newInput messages, Cmd.none)

    Send ->
      (Model "" messages, WebSocket.send echoServer input)

    NewMessage str ->
      (Model input (str :: messages), Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen echoServer NewMessage



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ input [onInput Input] []
    , button [onClick Send] [text "Send"]
    , div [id "match-div"]
      [ img [ id "match-stack", src ""] []
      , p [ id "match-counter" ] []
      , div [ id "game-div" ]
        [ p [ id "game-text" ] []
        , button [ ][text "X1"]
        , button [ ][text "X2"]
        , button [ ][text "X3"]
      ]
    , div [id "game-console"] (List.map viewMessage model.messages)
     ]
    ]
viewMessage : String -> Html msg
viewMessage msg =
  div [] [ text msg ]
