module Crankypants
  VERSION = "0.1.0"
  GIT_COMMIT = {{ system("git rev-parse HEAD").stringify.strip }}
end
