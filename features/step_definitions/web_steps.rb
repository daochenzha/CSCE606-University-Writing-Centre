#
#  This file conatins the web steps to pass senarios for user stories
#
#
Given("a user") do
    user = User.new
    user.first_name = "Amith"
    user.last_name = "Murakonda"
    user.email = "amithmurakonda@gamil.com"
    user.password = "$2a$10$WFVWNZhA2572N0.NLkTmveUyJfe1NrS3BFJ0fJmsN3FtjtD99F9sG"
    user.confirm = true
    user.confirm_code = nil
    user.salt = "$2a$10$WFVWNZhA2572N0.NLkTmve"
  end

Given("a task for the user:") do |task_table|
  user = User.first
  puts user
  task_table.hashes.each do |task|
    user.tasks.create!(task)
  end
end

When("I am on {string} users page") do |string|
  visit path_to(string)
end

And("I fill in {string} with {string}") do |string,string2|
  fill_in(string, :with => string2)
end

And("I press {string}") do |string|
  click_on(string)
end

Then("I should see {string} message") do |string|
  if page.respond_to? :should
    page.should have_no_content(text)
  else
    assert page.has_no_content?(text)
  end
end

Then("I should be on {string} page") do |string|
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == path_to(string)
  else
    assert_equal path_to(page_name), current_path
  end
end

Given("I am logged in as {string}") do |string|
    user = User.find("email=",string)
end

Then("I should be redirected to {string} page") do |string|
  expect(page).to have_current_path(path_to(string))
end

When("I am on the dashboard") do
  visit '/users'
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == path_to("users")
  else
    assert_equal path_to(page_name), current_path
  end
end

Then("I should see all my tasks") do
  user = User.first
    if page.respond_to? :should
      page.should have_no_content(user.tasks.first.title)
    else
      assert page.has_no_content?(user.tasks.first.title)
    end
end
