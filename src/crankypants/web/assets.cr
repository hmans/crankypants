{% if flag?(:release) %}
require "baked_file_system"

module Crankypants::Web
  class Assets
    extend BakedFileSystem

    bake_folder "../../../public"
  end
end
{% end %}
