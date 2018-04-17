require "./crankypants"
require "./crankypants/web"

# Check settings
#
Habitat.raise_if_missing_settings!

# Fire things up.
#
Crankypants.prepare_database
Crankypants::Web.run
