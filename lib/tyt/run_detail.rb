module Tyt
  class RunDetail < Hashie::Dash
    property :datetime
    property :chair
    property :vertical_feet
    property :vertical_meters

    def initialize(hash = {})
      hash[:vertical_feet] = string_to_i(hash[:vertical_feet])
      hash[:vertical_meters] = string_to_i(hash[:vertical_meters])
      super
    end

    def string_to_i(str)
      if str
        str = str.gsub(',','')
        return str.to_i
      else
        return nil
      end
    end

  end
end
