-- import Item exposing (..)
import Feed exposing (..)
import StartApp.Simple exposing ( start )


main =
  start
  { model = Feed.init
  , update = update
  , view = view
  }
