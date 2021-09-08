class VaccineController < ApplicationController
  require 'json'
  def check_availability
    require 'json'
    permitted=params.require(:vaccine).permit(:pincode,:date,:age)
    pincode=permitted[:pincode]
    date=permitted[:date]
    #sample1 = `python lib/python/sample.py "#{pincode},#{date}"`
    #@sample = sample1.gsub('\n','')
    url = URI("https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=#{pincode}&date=#{date}")
    sample = JSON.parse(Net::HTTP.get_response(url).body)
    @data = sample["centers"]
    sample["centers"].each do |location|
      Location.create(center_id: location["center_id"], name: location["name"], address: location["address:"])
    end
  end
end
