- posts_by_day = posts.group_by { |p| p.created_at.not_nil!.to_s("%B %-d") }
- posts_by_day.each do |day, posts|
  h2.day-header = day
  section.posts
    - posts.each do |post|
      == PostView._post(post)
