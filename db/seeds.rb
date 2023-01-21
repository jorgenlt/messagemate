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

puts 'Creating messages...'
user_id_counter = 1
recipient_id_counter = 10
10.times do
  Message.create(
    user_id: user_id_counter,
    recipient_id: recipient_id_counter,
    message_body: "Hello #{User.find(recipient_id_counter).username}, this is #{User.find(user_id_counter).username}."
    )
  user_id_counter += 1
  recipient_id_counter -= 1
end
puts 'Messages created'
