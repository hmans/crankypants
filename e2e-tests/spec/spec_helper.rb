require "rspec"
require "capybara/rspec"

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new app,
    browser: :remote,
    url: "http://selenium:4444/wd/hub",
    desired_capabilities: :chrome
end

Capybara.default_driver    = :chrome
Capybara.javascript_driver = :chrome
Capybara.app_host          = "http://crankypants:3000"
