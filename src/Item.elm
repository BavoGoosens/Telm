module Item where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import String


-- MODEL

type alias Model =
   { done: Bool
   , pinned: Bool
   , truncable: Bool
   , displayedText: String
   , body: String
   , params: List (String, String)
   }

-- check if truncable
init: Bool -> Bool -> String -> List (String, String)-> Model
init done pinned body params = Model done pinned ((String.length body) > 200) (String.left 200 body) body params

-- UPDATE

type Action = Pin | Truncate | Done

update : Action -> Model -> Model
update action model =
  case action of
    Pin -> {model | pinned = not model.pinned}
    Done -> {model | done = not model.done}
    Truncate -> {model | displayedText = "model.item.body" }

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ div [ bodyStyle ] [ text (toString model.displayedText) ]
    , button [ onClick address Pin ] [ text "Pin" ]
    , button [ onClick address Done ] [ text "Mark Done" ]
    , button [ onClick address Truncate ] [ text "more" ]
    ]

bodyStyle : Attribute
bodyStyle =
  style
    [ ("font-size", "20px")
    , ("font-family", "monospace")
    , ("display", "inline-block")
    , ("width", "400px")
    , ("text-align", "center")
    ]
