module Feed where

import Static exposing (reminders, emails, get_other_reminder_attributes, get_other_email_attributes)
import Item exposing (..)
import Date exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

-- MODEL

type alias Model =
  { focus: Int
  , len: Int
  , todo: List ( ID, Item.Model )
  , done: List ( ID, Item.Model )
  , todoID: ID
  , doneID: ID
  }

type alias ID = Int

init : Model
init =
  let wut =
        initialize
  in
        Model 0 (List.length wut) wut [] (List.length wut) 0

initialize: List ( ID, Item.Model)
initialize =
  List.map2 (,) [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]
    (List.append (List.map bulk_init_reminder reminders) (List.map bulk_init_email emails))

bulk_init_reminder record =
      Item.init False False record.body (get_other_reminder_attributes record)
bulk_init_email record =
      Item.init False False record.body (get_other_email_attributes record)


customComparison: (ID, Item.Model) -> (ID, Item.Model) -> Order
customComparison (a, b) (c, d) =
  if b.pinned && not d.pinned then
    LT
  else
    if not b.pinned && d.pinned then
      GT
    else
      dateComparison b.order d.order

dateComparison: Date -> Date -> Order
dateComparison a b =
  if Date.year a == Date.year b then
    if monthToInt(Date.month a) == monthToInt(Date.month b) then
      if Date.day a == Date.day b then
        EQ
      else
        if Date.day a > Date.day b then
          GT
        else
          LT
    else
      if monthToInt(Date.month a) > monthToInt(Date.month b) then
        GT
      else
        LT
  else
    if Date.year a > Date.year b then
      GT
    else
      LT
-- UPDATE

type Action
    = Previous
    | Next
    | Add Bool Bool String (List (String, String))
    | Remove ID
    | Modify ID Item.Model Item.Action
    | AlterSort

update : Action -> Model -> Model
update action model =
  case action of
    Add done pinned body params ->
      { model |
        todo = (model.todoID, Item.init done pinned body params) :: model.todo,
        todoID = model.todoID + 1
      }
    Remove id ->
      { model |
        todo = List.filter (\(itemID, _) -> itemID /= id) model.todo,
        done = List.filter (\(itemID, _) -> itemID /= id) model.done
      }
    Next -> if model.focus < model.len then
              {model | focus = model.focus + 1}
            else
              {model | focus = 0}
    Previous -> if model.focus > 0 then
                  {model | focus = model.focus - 1}
                else
                  {model | focus = model.len}
    Modify id item itemAction ->
      if itemAction == Done then
            if item.done then
                  -- copy back to todo
                  {model |
                    todo = model.todo ++ [(id, Item.update itemAction item)],
                    done = List.filter (\(itemID, _) -> itemID /= id) model.done
                  }
            else
                  {model |
                    done = model.done ++ [(id, Item.update itemAction item)],
                    todo = List.filter (\(itemID, _) -> itemID /= id) model.todo
                  }
      else
        let updateItem (itemID, itemModel) =
              if itemID == id
                  then (itemID, Item.update itemAction itemModel)
                  else (itemID, itemModel)
        in
            { model | todo = List.map updateItem model.todo, done = List.map updateItem model.done }
    AlterSort -> model

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div [] [
    h1 [headerStyle] [text "Todo "]
    , div [] (List.map (viewItem address) (List.sortWith customComparison model.todo))
    , h1 [headerStyle] [text "Done "]
    , div [] (List.map (viewItem address) (List.sortWith customComparison model.done))
    ]

viewItem : Signal.Address Action -> (ID, Item.Model) -> Html
viewItem address (id, model) =
  Item.view (Signal.forwardTo address (Modify id model)) model

headerStyle : Attribute
headerStyle =
  style
    [ ("font-size", "40px")
    , ("font-family", "monospace")
    , ("display", "flex")
    -- , ("align-items", "center")
    -- , ("justify-content", "center")
    , ("width", "60%")
    , ("text-align", "left")
    , ("margin-left", "auto")
    , ("margin-right", "auto")
    ]

-- Helper
monthToInt: Month -> Int
monthToInt month =
  case month of
    Jan -> 1
    Feb -> 2
    Mar -> 3
    Apr -> 4
    May -> 5
    Jun -> 6
    Jul -> 7
    Aug -> 8
    Sep -> 9
    Oct -> 10
    Nov -> 11
    Dec -> 12
