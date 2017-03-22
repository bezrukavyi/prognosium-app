
User.find_or_create_by!(email: 'yaroslav555@gmail.com') do |user|
  user.password = 'Password555'
  user.password_confirmation = 'Password555'
end

User.find_each do |user|
  5.times do
    project = Project.create!(
      title: FFaker::Job.title,
      completed_at: rand(5..50).days.from_now,
      user: user
    )

    rand(2..10).times do
      Task.create! do |task|
        task.title = FFaker::Job.title
        task.checked = [true, false].sample
        task.project_id = project.id
      end
    end
  end
end
