module Tyt
  class Bachelor
    require 'open-uri'
    require 'nokogiri'
    DEFAULT_SEASON = '13-14'
    MTB_ENDPOINT = "http://track.mtbachelor.com/mobile/tyt.asp"

    attr_accessor :pass, :season, :currentday, :mtb_endpoint, :doc
    def initialize(options={})
      raise(ArgumentError, "pass is required!") if !options[:pass] || !options[:pass].instance_of?(String)
      raise(ArgumentError, "Invalid Season Format!") if options[:season] && !(options[:season] =~ /\d{2}\-\d{2}/)
      @pass = options[:pass]
      @season = options[:season] ? options[:season] : DEFAULT_SEASON
      @currentday = nil
      @mtb_endpoint = MTB_ENDPOINT
    end

    def get_doc
      @doc = Nokogiri::HTML(open(data_endpoint))
    end

    def season_data
      @currentday = nil
      get_doc
      date_rows = doc.css('a[href]').select{|e| e['href'] =~ /currentday\=\d{2}\/\d{2}\/\d{4}/ }.collect{|a| a.parent().parent() }
      season = Tyt::Season.new
      date_rows.each do |row|
        cells = row.children.css('td')
        date = cells[0] ? Date.strptime(cells[0].text, '%m/%d/%Y') : nil
        runs = cells[1] ? cells[1].text : nil
        vertical_feet = cells[2] ? cells[2].text : nil
        vertical_meters = cells[3] ? cells[3].text : nil
        ski_day = Tyt::SkiDay.new(date: date, runs: runs, vertical_feet: vertical_feet, vertical_meters: vertical_meters)
        season.days << ski_day
      end
      return season
    end

    def date_data(date)
      begin
        @currentday = date.strftime('%m/%d/%Y')
        get_doc
        ride_rows = doc.css('td').select{|n| n.text =~ /\d{1,2}\/\d{2}\/\d{4}\s{1}\d{1,2}\:\d{2}\:\d{2}/ }.collect{|a| a.parent() }
        ride_data = []
        ride_rows.each do |row|
          cells = row.children.css('td')
          date = cells[0] ? DateTime.strptime(cells[0].text,'%m/%d/%Y %l:%M:%S %p') : nil
          chair = cells[1] ? cells[1].text : nil
          vertical_feet = cells[2] ? cells[2].text : nil
          vertical_meters = cells[3] ? cells[3].text : nil
          run_detail = Tyt::RunDetail.new(datetime: date, chair: chair, vertical_feet: vertical_feet, vertical_meters: vertical_meters)
          ride_data << run_detail
        end
        return ride_data
      rescue OpenURI::HTTPError
        return nil
      end
    end

    def data_endpoint
      args = [
        "passmediacode=#{@pass}",
        "season=#{@season}"
      ]
      if @currentday
        args << "currentday=#{@currentday}"
      else
        args << "currentday=null"
      end
      return [@mtb_endpoint,args.join('&')].join('?')
    end
  end
end
