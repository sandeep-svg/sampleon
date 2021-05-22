class VaccineController < ApplicationController
  def check_availability
    permitted=params.require(:vaccine).permit(:pincode,:date)
    pincode=permitted[:pincode]
    date=permitted[:date]
    @sample = `python lib/assets/python/sample.py "#{pincode},#{date}"`
  end
end
