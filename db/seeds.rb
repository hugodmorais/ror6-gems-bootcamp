# Create User
User.create!(email: 'admin@admin.com', password: '123456', password_confirmation: '123456')

# Create Courses
30.times do
  Course.create!([{
    title: Faker::Educator.course_name,
    description: Faker::TvShows::GameOfThrones.quote,
    user_id: User.first.id,
    short_description: Faker::TvShows::GameOfThrones.quote,
    language: Faker::ProgrammingLanguage.name,
    level: 'Beginner',
    price: Faker::Number.between(from: 1000, to: 2000)
  }])
end