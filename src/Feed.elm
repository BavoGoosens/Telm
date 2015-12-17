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
    | Modify ID Item.Action
    | AlterSort

update : Action -> Model -> Model
update action model =
  case action of
    Add -> model
    Remove id -> model
    Next -> if model.focus < model.len then
              {model | focus = model.focus + 1}
            else
              {model | focus = 0}
    Previous -> if model.focus > 0 then
                  {model | focus = model.focus -1}
                else
                  {model | focus = model.len}
    Modify id itemAction ->
      let updateItem (itemID, itemModel) =
            if itemID == id
                then (itemID, Item.update itemAction itemModel)
                else (itemID, itemModel)
      in
          { model | todo = List.map updateItem model.todo, done = List.map updateItem updateItem model.done }
    AlterSort -> model

-- VIEW

view : Model -> Html
