require "option_parser"
require "./crankypants"
require "./crankypants/web"

# Process command line options
OptionParser.parse! do |parser|
  parser.banner = <<-EOF
  Crankypants #{Crankypants::VERSION}

  Usage: crankypants [arguments]

  EOF

  parser.on "-p PORT", "--port=PORT", "The port to listen on (default: 3000)" do |port|
    Crankypants.settings.port = port.to_i32
  end

  parser.on "-b IP", "--binding=IP", "The interface to bind to (default: 0.0.0.0)" do |interface|
    Crankypants.settings.interface = interface
  end

  parser.on "--asset-host HOST", "Host to load assets from (default: blank)" do |arg|
    Crankypants.settings.asset_host = arg
  end

  parser.on "-h", "--help", "Show this help" do
    puts parser
    exit
  end
end

# Check settings
#
Habitat.raise_if_missing_settings!

# Fire things up.
#
Crankypants.prepare_database
Crankypants::Web.run
