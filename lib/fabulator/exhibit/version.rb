module Fabulator
  module Exhibit
    module VERSION
      unless defined? MAJOR
        MAJOR = 0
        MINOR = 0
        TINY  = 1
        PRE   = nil

        STRING = [MAJOR,MINOR,TINY].compact.join('.') + (PRE.nil? ? '' : PRE)

        SUMMARY = "fabulator-exhibit #{STRING}"
      end
    end
  end
end
