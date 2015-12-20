-- import Item exposing (..)
import Feed exposing (..)
import Signal exposing (Signal, Address)


main =
  Signal.map (view actions.address) model
