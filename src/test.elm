import Item exposing (..)
import StartApp.Simple exposing ( start )
-- import Static exposing (Reminder, Email)

main =
  start
  { model = init False False "test" { body = "Take out the trash", created = "2016-09-30" }
  , update = update
  , view = view
  }
