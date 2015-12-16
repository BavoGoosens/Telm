import Static exposing (reminders, emails)
import Item exposing (..)
import Html exposing (..)
import Html.Attributes exposing (style)
import Date exposing ( Date )

-- MODEL

type alias Model =
  { focus: Int
  , todo: List ( ID, Item )
  , done: List ( ID, Item )
  , todoID: ID
  , doneID: ID
  }

type alias ID: Int

-- UPDATE

type Action = Previous | Next | Add | AlterSort

update : Action -> Model -> Model

-- VIEW

view : Model -> Html
