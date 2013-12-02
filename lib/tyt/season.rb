module Tyt
  class Season < Hashie::Dash
    property :name
    property :days, :default => []

    def total_runs
      days.inject(0){|all_year,ski_day| all_year += ski_day.runs}
    end

    def total_days
      days.count
    end

    def total_vertical_feet
      days.inject(0){|all_year,ski_day| all_year += ski_day.vertical_feet}
    end

    def total_vertical_meters
      days.inject(0){|all_year,ski_day| all_year += ski_day.vertical_meters}
    end
  end
end
