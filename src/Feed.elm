module Feed where

import Static exposing (reminders, emails, get_other_reminder_attributes, get_other_email_attributes)
import Item exposing (..)
import Date exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Keyboard exposing (..)
import Set
import Char


-- MODEL

type alias Model =
  { focus: Int
  , len: Int
  , todo: List ( ID, Item.Model )
  , done: List ( ID, Item.Model )
  , todoID: ID
  , input: Bool
  , showDone: Bool
  , currentReminder: String
  , currentDate: String
  , sortFunction: (ID, Item.Model) -> (ID, Item.Model) -> Order
  }

type alias ID = Int

-- Init stuff
init : Model
init =
  let wut =
        initialize
  in
        Model 0 (List.length wut) wut [] (List.length wut) True True "" "" customComparison

initialize: List ( ID, Item.Model)
initialize =
  List.map2 (,) [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]
    (List.append (List.map bulk_init_reminder reminders) (List.map bulk_init_email emails))

bulk_init_reminder record =
      Item.init False False record.body (get_other_reminder_attributes record)
bulk_init_email record =
      Item.init False False record.body (get_other_email_attributes record)

-- Sort functionality + helpers for the sort functionality
customComparison: (ID, Item.Model) -> (ID, Item.Model) -> Order
customComparison (a, b) (c, d) =
  if b.pinned && not d.pinned then
    LT
  else
    if not b.pinned && d.pinned then
      GT
    else
      dateComparison b.order d.order

reversedComparison: (ID, Item.Model) -> (ID, Item.Model) -> Order
reversedComparison (a, b) (c, d) =
  if dateComparison b.order d.order == LT then
    GT
  else
    if dateComparison b.order d.order == GT then
      LT
    else
      EQ

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


-- UPDATE

type Action
    = NoOp
    | Previous
    | Next
    | Remove ID
    | Modify ID Item.Model Item.Action
    | AlterSort
    | HideInput
    | HideDone
    | ReadInput
    | TruncateFocussed
    | PinFocussed
    | FinishFocussed
    | ReminderBody String
    | ReminderDate String

update : Action -> Model -> Model
update action model =
  case action of
    NoOp -> {model | sortFunction = customComparison}
    Remove id ->
      { model |
        todo = List.filter (\(itemID, _) -> itemID /= id) model.todo,
        done = List.filter (\(itemID, _) -> itemID /= id) model.done,
        len = model.len - 1
      }
    Next -> if model.showDone then
              if model.focus < model.len then
                {model | focus = model.focus + 1}
              else
                {model | focus = 0}
            else
              if model.focus < List.length model.todo then
                {model | focus = model.focus + 1}
              else
                {model | focus = 0}
    Previous -> if model.focus > 0 then
                  {model | focus = model.focus - 1}
                else
                  if model.showDone then
                    {model | focus = model.len}
                  else
                    {model | focus = List.length model.todo}
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
    AlterSort -> {model | sortFunction = reversedComparison}
    HideInput -> {model | input = not model.input}
    HideDone -> {model | showDone = not model.showDone }
    ReadInput -> {model |
                    todo = model.todo ++ [(model.todoID + 1,  Item.init False False model.currentReminder
                      [("body", model.currentReminder), ("created", model.currentDate)] )],
                    todoID = model.todoID + 1
                  }
    ReminderBody reminder -> {model | currentReminder = reminder}
    ReminderDate date -> {model | currentDate = date}
    TruncateFocussed -> model
    PinFocussed -> model
    FinishFocussed -> model


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div [] [
    if model.input then
      div [footerStyle] [
        input [
          type' "text"
        , wrap "hard"
        , name "want"
        , on "input" targetValue (Signal.message address << ReminderBody)
        , placeholder "What needs to get done ?"
        , inputStyle
        ][]
        ,input [
          type' "date"
        , name "when"
        , on "input" targetValue (Signal.message address << ReminderDate)
        , inputStyle
        ][]
        , button [inputStyle, onClick address ReadInput] [text "add"]
        , button [inputStyle, onClick address HideInput] [text "hide"]
      ]
    else
      div [footerStyle] [button [inputStyle, onClick address HideInput] [text "show"]]
    , h1 [headerStyle] [text "Todo "]
    , div [] (List.map (viewItem address) (List.sortWith model.sortFunction model.todo))
    , h1 [headerStyle] [text "Done "]
    , if model.showDone then
        div [] (List.map (viewItem address) (List.sortWith model.sortFunction model.done))
      else
        p [Item.bodyStyle] [text "Hidden alt+d to show"]
    ]

display : Set.Set Int -> Html
display keyCodes =
    text ("You are holding down the following keys: " ++ toString (Set.toList keyCodes))

viewItem : Signal.Address Action -> (ID, Item.Model) -> Html
viewItem address (id, model) =
  Item.view (Signal.forwardTo address (Modify id model)) model

actions : Signal.Mailbox Action
actions =
  Signal.mailbox NoOp

model : Signal Model
model =
  Signal.foldp update initialModel (Signal.merge (Signal.map parseKeyCode Keyboard.keysDown) actions.signal)

initialModel : Model
initialModel =
  init

parseKeyCode : Set.Set (Char.KeyCode) -> Action
parseKeyCode set =
  let lijst = Set.toList set
  in
    if List.length lijst /= 2 then
      NoOp
    else
      if List.member 18 lijst then
        if List.member 74 lijst then
          Next
        else
          if List.member 75 lijst then
            Previous
          else
            if List.member 79 lijst then
              TruncateFocussed
            else
              if List.member 80 lijst then
                PinFocussed
              else
                if List.member 88 lijst then
                  FinishFocussed
                else
                  if List.member 83 lijst then
                    AlterSort
                  else
                    if List.member 72 lijst then
                      HideInput
                    else
                      if List.member 68 lijst then
                        HideDone
                      else
                        NoOp
      else
        NoOp


-- Style details

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

inputStyle : Attribute
inputStyle =
    style
        [ ("width", "30%")
        , ("height", "40px")
        , ("padding", "10px 0")
        , ("font-size", "2em")
        , ("font-family", "monospace")
        , ("text-align", "center")
        , ("margin-left", "auto")
        , ("margin-right", "auto")
        , ("display", "flex")
        , ("align-items", "baseline")
        , ("justify-content", "center")
        ]

footerStyle : Attribute
footerStyle =
    style
        [ ("width", "100%")
        , ("position", "fixed")
        , ("bottom", "0")
        ]
