require "sentry"

# Monkeypatch for 0.25 compatibility
class Sentry::ProcessRunner
  private def get_timestamp(file : String)
    File.info(file).modification_time.to_s("%Y%m%d%H%M%S")
  end
end

sentry = Sentry::ProcessRunner.new(
  process_name: "Crankypants DEV",
  build_command: "crystal build ./src/crankypants_cli.cr -o bin/crankypants",
  run_command: "./bin/crankypants",
  run_args: ["--asset-host", "localhost:8080"],
  files: ["./src/**/*", "./crappy/src/**/*"]
)

sentry.run
