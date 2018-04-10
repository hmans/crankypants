require "sentry"

sentry = Sentry::ProcessRunner.new(
  process_name: "Crankypants DEV",
  build_command: "crystal build ./src/crankypants.cr -o ./crankypants",
  run_command: "./crankypants",
  files: ["./src/**/*.cr", "./src/**/*.ecr", "./src/**/*.slang"]
)

sentry.run
