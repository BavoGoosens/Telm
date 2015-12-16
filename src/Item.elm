module Item where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Static exposing ( Reminder, Email )
import Date exposing ( Date )
import String exposing ( Length, left)
type Item = Reminder | Email

-- MODEL

type alias Model =
   { done: Boolean
   , pinned: Boolean
   , diplayedText:String
   , item: Item
   }

init: Boolean -> Boolean -> String -> Item -> Model
init done pinned displayedText item =
  Model done pinned displayedText item 
-- UPDATE

type Action = Pin | Truncate | Done

update : Action -> Model -> Model
update action model =
  case action of
    Pin -> {model | not pinned}
    Truncate -> \
      if (String.Length displayedText) > 200) then \
        {model | displayedText = (String.left 197 item.body) ++ "..."} \
      else \
        {model | displayedText =  item.body}
    Done -> {model | not done}

-- VIEW

view : Model -> Html
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
    , ("width", "50px")
    , ("text-align", "center")
    ]
