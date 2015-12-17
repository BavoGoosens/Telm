import Item exposing (..)
import StartApp.Simple exposing ( start )
-- import Static exposing (Reminder, Email)

test1 = { body = "Take out the trash", created = "2016-09-30" }
test2 = { from = "hello@test.me"
  , to = "goodbye@test.me"
  , title = "Shorter than 200"
  , body = """This is the body of an email with less than 200 characters."""
  , date = "2015-09-30"
  }
test3 = { from = "bossman@corporate.me"
  , to = "manager@corporate.me"
  , title = "Corporate Ipsum"
  , body = """Collaboratively administrate empowered markets via plug-and-play
              networks. Dynamically procrastinate B2C users after installed base
              benefits. Dramatically visualize customer directed convergence without
              revolutionary ROI.

              Efficiently unleash cross-media information without cross-media
              value. Quickly maximize timely deliverables for real-time
              schemas. Dramatically maintain clicks-and-mortar solutions
              without functional solutions.

              Completely synergize resource taxing relationships via premier
              niche markets. Professionally cultivate one-to-one customer
              service with robust ideas. Dynamically innovate
              resource-leveling customer service for state of the art customer
              service."""
  , date = "2015-01-30"
  }

main =
  start
  { model = init False False test3.body (get_other_email_attributes test3)
  , update = update
  , view = view
  }

get_other_reminder_attributes {body, created} = [( "body", body), ("created", created)]

get_other_email_attributes {to, from, body, title, date} = [ ("to", to), ("from", from), ("title", title), ("body", body), ("date", date)]
