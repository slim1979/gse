# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(email: 'chinezan@yandex.ru', password: 'qwerty', admin: true)
User.create(email: 'qqq@qqq.ru', password: 'qwerty')

5.times do
  User.create do |user|
    user.email = Faker::Internet.email
    user.password = 'qwerty'
  end
end

15.times do
  Question.create do |question|
    question.title = Faker::Lorem.paragraph
    question.body = Faker::Lorem.paragraph(2)
    question.user = User.all.sample
  end
end

50.times do
  Answer.create do |answer|
    answer.body = Faker::Lorem.paragraph(2)
    answer.user = User.all.sample
    answer.question = Question.all.sample
  end
end
