require "rspec"
require "capybara/rspec"
require "site_objects"

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new app,
    browser: :remote,
    url: "http://selenium:4444/wd/hub",
    desired_capabilities: :chrome
end

Capybara.default_driver    = :chrome
Capybara.javascript_driver = :chrome
Capybara.app_host          = "http://alice:secret@alice:3000"

def on(who)
  previous_host = Capybara.app_host
  # default_url_options[:host] = host
  Capybara.app_host = "http://#{who}:secret@#{who}:3000"
  yield
  Capybara.app_host = previous_host
end
