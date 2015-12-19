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
  if model.truncable then
    div [kaderStyle]
      [ prettyHTMLPrint model
      , if model.pinned && not model.done then
          div [ pinnedBodyStyle ] [ text model.displayedText ]
        else if model.done && model.pinned then
            div [ pinnedDoneBodyStyle ] [ text model.displayedText ]
          else if model.done && not model.pinned then
              div [ doneBodyStyle ] [ text model.displayedText ]
            else
              div [ bodyStyle ] [ text model.displayedText ]
      , p [bodyStyle] [ button [ onClick address Pin ] [ if model.pinned then text "Unpin" else text "Pin" ]
        , button [ onClick address Done ] [ if model.done then text "Undo" else text "Mark Done" ]
        , button [ onClick address Truncate ] [ if (String.length model.displayedText) > 200 then text "less" else text "more" ]
        ]
      ]
  else
    div [kaderStyle]
      [ prettyHTMLPrint model
      , if model.pinned && not model.done then
          div [ pinnedBodyStyle ] [ text model.displayedText ]
        else if model.done && model.pinned then
            div [ pinnedDoneBodyStyle ] [ text model.displayedText ]
          else if model.done && not model.pinned then
              div [ doneBodyStyle ] [ text model.displayedText ]
            else
              div [ bodyStyle ] [ text model.displayedText ]
      , p [bodyStyle] [ button [ onClick address Pin ] [ if model.pinned then text "Unpin" else text "Pin" ]
        , button [ onClick address Done ] [ if model.done then text "Undo" else text "Mark Done" ]
        ]
      ]

prettyHTMLPrint: Model -> Html
prettyHTMLPrint model =
    div [metaStyle] (
      let tupleprint (jos, jef) =
            p [] [text ( jos ++ ": " ++ jef)]
      in
            List.map tupleprint (List.filter (\(jos, _) -> jos /= "body") model.params)
            )

bodyStyle : Attribute
bodyStyle =
  style
    [ ("font-size", "20px")
    , ("font-family", "monospace")
    , ("display", "flex")
    , ("align-items", "center")
    , ("justify-content", "center")
    , ("width", "80%")
    , ("text-align", "center")
    , ("margin-left", "auto")
    , ("margin-right", "auto")
    ]

metaStyle : Attribute
metaStyle =
  style
    [ ("font-size", "14px")
    , ("font-family", "monospace")
    , ("display", "flex")
    , ("align-items", "center")
    , ("justify-content", "space-around")
    , ("width", "80%")
    , ("text-align", "center")
    , ("margin-left", "auto")
    , ("margin-right", "auto")
    ]

pinnedBodyStyle : Attribute
pinnedBodyStyle =
    style
      [ ("font-size", "20px")
      , ("font-family", "monospace")
      , ("display", "flex")
      , ("align-items", "center")
      , ("justify-content", "center")
      , ("width", "80%")
      , ("text-align", "center")
      , ("margin-left", "auto")
      , ("margin-right", "auto")
      , ("border-left",  "2px solid red")
      , ("padding-left",  "2px")
      ]

pinnedDoneBodyStyle : Attribute
pinnedDoneBodyStyle =
    style
      [ ("font-size", "20px")
      , ("font-family", "monospace")
      , ("display", "flex")
      , ("align-items", "center")
      , ("justify-content", "center")
      , ("width", "80%")
      , ("text-align", "center")
      , ("margin-left", "auto")
      , ("margin-right", "auto")
      , ("border-left",  "2px solid red")
      , ("padding-left",  "2px")
      , ("opacity", "0.5")
      ]

doneBodyStyle : Attribute
doneBodyStyle =
  style
    [ ("font-size", "20px")
    , ("font-family", "monospace")
    , ("display", "flex")
    , ("align-items", "center")
    , ("justify-content", "center")
    , ("width", "80%")
    , ("text-align", "center")
    , ("margin-left", "auto")
    , ("margin-right", "auto")
    , ("opacity", "0.5")
    ]

kaderStyle : Attribute
kaderStyle =
  style
    [ ("border-bottom" , "1px solid grey")
    , ("display", "block-inline")
    , ("margin-left", "auto")
    , ("margin-right", "auto")
    , ("width", "60%")
    ]
