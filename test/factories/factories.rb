Factory.define :user do |user|
  user.email                 { Factory.next(:email) }
  user.first_name             { "First Name" }
  user.last_name              {"Last Name"}
  user.password = "$2a$10$WFVWNZhA2572N0.NLkTmveUyJfe1NrS3BFJ0fJmsN3FtjtD99F9sG"
  user.confirm = true
  user.confirm_code = nil
  user.salt = "$2a$10$WFVWNZhA2572N0.NLkTmve"
end
