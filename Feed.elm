import Html exposing (..)
import Html.Attributes exposing (style)
import Date exposing ( Date )


type todo: List Item

type done: List Item

-- MODEL

type alias Model = { ... }

-- UPDATE

type Action = Pin | Previous | Next | Add | Truncate | Done | Sort

-- VIEW

view : Model -> Html
