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
    Truncate ->   if (model.truncable && (String.length model.displayedText) <= 200) then
                    {model | displayedText = model.body}
                  else
                    if (model.truncable && (String.length model.displayedText) > 200) then
                        {model | displayedText = (String.left 200 model.body)}
                    else
                        model

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ div [ bodyStyle ] [ text (toString model.displayedText) ]
    , br [] []
    , button [ onClick address Pin ] [ if model.pinned then text "Unpin" else text "Pin" ]
    , button [ onClick address Done ] [ if model.done then text "Undo" else text "Mark Done" ]
    , button [ onClick address Truncate ] [ if (String.length model.displayedText) > 200 then text "less" else text "more" ]
    ]

tupleToString : (String, String) -> String
tupleToString (jos , jef) = jos ++ " " ++ jef

bodyStyle : Attribute
bodyStyle =
  style
    [ ("font-size", "20px")
    , ("font-family", "monospace")
    , ("display", "inline-block")
    , ("width", "400px")
    , ("text-align", "center")
    ]
