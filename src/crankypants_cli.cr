require "./crankypants"
require "./crankypants/web"

require "option_parser"
require "colorize"

module Crankypants
  module CLI
    def self.run!
      parse_cli_options!

      # Log Crecto queries to STDOUT
      {% unless flag?(:release) %}
        Crecto::DbLogger.set_handler(STDOUT)
      {% end %}

      Habitat.raise_if_missing_settings!
      Crankypants.prepare_database
      print_banner!
      Crankypants::Web.run
    end

    private def self.parse_cli_options!
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
    end

    private def self.print_banner!
      base_url = "http://#{Crankypants.settings.interface}:#{Crankypants.settings.port}/"
      puts ["Welcome to ", "CrankyPants".colorize(:white), "! ", ":D ".colorize(:yellow), "(#{Crankypants::VERSION})".colorize(:dark_gray)].join
      puts ["-> ".colorize(:green), "Your blog: ", base_url.colorize(:cyan)].join

      # We only want to mount /app and /api if the required environment
      # variables are available.
      #
      if ENV["CRANKY_LOGIN"]? && ENV["CRANKY_PASSWORD"]?
        puts ["-> ".colorize(:green), "Your app:  ", "#{base_url}app/".colorize(:cyan)].join
      else
        puts ["-> ".colorize(:yellow), "/app".colorize(:white), " and ", "/api".colorize(:white), " are disabled. Please provide CRANKY_LOGIN and CRANKY_PASSWORD!"].join
      end

      puts ["Enjoy! ", "<3<3<3".colorize(:red)].join
      puts
    end
  end
end

Crankypants::CLI.run!
