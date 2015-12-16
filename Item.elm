
type Item = Reminder | Email

type Reminder =
 { done: Boolean
 , pinned: Boolean
 , body: String
 , created: Date
 }

type Email =
 { done: Boolean
 , pinned: Boolean
 , to: String
 , from: String
 , body: String
 , date: Date
 }
