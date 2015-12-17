import Static exposing (reminders, emails)
import Item exposing (..)
import Html exposing (..)
import Html.Attributes exposing (style)

-- MODEL

type alias Model =
  { focus: Int
  , len: Int
  , todo: List ( ID, Item )
  , done: List ( ID, Item )
  , todoID: ID
  , doneID: ID
  }

type alias ID: Int

-- UPDATE

type Action
    = Previous
    | Next
    | Add
    | Remove ID
    | Modify ID Counter.Action
    | AlterSort

update : Action -> Model -> Model
update action model =
  case action of
    Add -> model
    Remove id -> model
    Next -> model
    Previous -> model
    Modify id counterAction -> model
    AlterSort -> model

-- VIEW

view : Model -> Html
