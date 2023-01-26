# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'faker'

puts 'Creating users...'
10.times do
  User.create(email: Faker::Internet.email, password: "123456", username: Faker::Internet.username(specifier: 5..8))
end
puts 'Users created.'

# user_id_counter = 1
# recipient_id_counter = 10
# puts 'Creating chatrooms...'
# 10.times do
#   Chatroom.create(
#     recipient_id: recipient_id_counter,
#     username: User.find(user_id_counter).username,
#     user_id: user_id_counter
#   )
#   user_id_counter += 1
#   recipient_id_counter -= 1
# end
# puts 'Chatrooms created.'

puts 'Creating chatroom...'
Chatroom.create(
  recipient_id: 2,
  username: User.find(2).username,
  user_id: 1
)
puts 'Chatroom created.'

puts 'Creating messages...'
5.times do
  Message.create(
    user_id: 1,
    recipient_id: 2,
    chatroom_id: 1,
    message_body: Faker::Fantasy::Tolkien.poem
  )

  Message.create(
    user_id: 2,
    recipient_id: 1,
    chatroom_id: 1,
    message_body: Faker::Fantasy::Tolkien.poem
  )
end
puts 'Messages created.'

puts 'Creating chatroom...'
Chatroom.create(
  recipient_id: 3,
  username: User.find(3).username,
  user_id: 1
)
puts 'Chatroom created.'

puts 'Creating messages...'
8.times do
  Message.create(
    user_id: 1,
    recipient_id: 3,
    chatroom_id: 2,
    message_body: Faker::Fantasy::Tolkien.poem
  )

  Message.create(
    user_id: 3,
    recipient_id: 1,
    chatroom_id: 2,
    message_body: Faker::Fantasy::Tolkien.poem
  )
end
puts 'Messages created.'

puts 'Creating chatroom...'
Chatroom.create(
  recipient_id: 4,
  username: User.find(4).username,
  user_id: 1
)
puts 'Chatroom created.'

puts 'Creating messages...'
11.times do
  Message.create(
    user_id: 1,
    recipient_id: 4,
    chatroom_id: 3,
    message_body: Faker::Fantasy::Tolkien.poem
  )

  Message.create(
    user_id: 4,
    recipient_id: 1,
    chatroom_id: 3,
    message_body: Faker::Fantasy::Tolkien.poem
  )
end
puts 'Messages created.'

# puts 'Creating messages...'
# user_id_counter = 1
# recipient_id_counter = 10
# chatroom_id_counter = 1
# 10.times do
  # Message.create(
  #   user_id: user_id_counter,
  #   recipient_id: recipient_id_counter,
  #   chatroom_id: chatroom_id_counter,
  #   message_body: "Hello #{User.find(recipient_id_counter).username}, this is #{User.find(user_id_counter).username}."
  # )
#   user_id_counter += 1
#   recipient_id_counter -= 1
#   chatroom_id_counter += 1
# end
# puts 'Messages created.'
