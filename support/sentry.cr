require "sentry"

sentry = Sentry::ProcessRunner.new(
  process_name: "Crankypants DEV",
  build_command: "crystal build ./src/crankypants_cli.cr -o bin/crankypants",
  run_command: "./bin/crankypants",
  run_args: ["--asset-host", "localhost:8080"],
  files: ["./src/**/*.cr", "./src/**/*.ecr", "./src/**/*.slang"]
)

sentry.run
