module Main where

import Html exposing ( Html )
import Feed exposing (..)
import Signal exposing (Signal, Address)
-- Name: Bavo Goosens
-- Student ID: r0297884


-- * Add a hotkey to toggle the visibility of 'done' items.
-- Status: Completed
-- Summary: Can be toggled by pressing option(alt) + D


-- * Hide the 'add reminder' functionality and add a hotkey to toggle its
-- * visibility.
-- Status: Completed
-- Summary: Completed can be toggled by pressing option(alt) + H


-- * Put the current date as the default in the date picker when adding
-- * reminders.
-- Status: Attempted
-- Summary: This feature was not finished since I had already spent too much
-- time on the assignment


-- * Add a deadline property to reminders and mark all reminders that are past
-- * their deadline.
-- Status: Unattempted
-- Summary: Due to time expenditure


-- * Add a 'snooze' feature to items, to 'snooze' an item you must provide a
-- * date on which the item has to 'un-snooze'. 'snoozed' items are not visible.
-- Status: Unattempted
-- Summary: Due to time expenditure


-- * On startup, read e-mails from a Json document at this url:
-- * http://people.cs.kuleuven.be/~bob.reynders/2015-2016/emails.json
-- Status: Unattempted
-- Summary: Due to time expenditure


-- * Periodically check for e-mails from Json (same url).
-- Status: Unattempted
-- Summary: Due to time expenditure


-- * Add persistence to your application by using Html local storage so that
-- * newly added reminders are still there after a reload.
-- Status: Unattempted
-- Summary:Due to time expenditure


-- * Come up with your own extension!
-- Status: Unattempted
-- Summary: I have altered the next focus action so it will not re-enter the 
-- list of finished items when it is set to invisible.


-- Start of program

main =
  Signal.map (view actions.address) model
