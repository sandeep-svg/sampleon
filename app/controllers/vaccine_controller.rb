class VaccineController < ApplicationController
  def check_availability
    permitted=params.require(:vaccine).permit(:pincode,:date,:age)
    pincode=permitted[:pincode]
    date=permitted[:date]
    age=permitted[:age]
    @sample = `python lib/python/sample.py "#{pincode},#{date},#{age}"`
  end
end
