require "baked_file_system"

module Crankypants
  class Assets
    extend BakedFileSystem

    bake_folder "../../public"
  end
end
