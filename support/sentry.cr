require "sentry"

sentry = Sentry::ProcessRunner.new(
  display_name: "Crankypants DEV",
  build_command: "crystal build ./src/crankypants_cli.cr -o bin/crankypants",
  run_command: "./bin/crankypants",
  run_args: ["--asset-host", "localhost:8080"],
  files: ["./src/**/*", "./crappy/src/**/*"]
)

sentry.run
