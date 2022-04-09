class NotifyVaccineJob < ApplicationJob
  queue_as :default

  def perform(user=User.find_by_email('sandeeparey987@gmail.com') ,pincode='500001',date=Date.today.strftime("%d-%m-%Y"))
    return if Time.now.hour != 14
    url = URI("https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=#{pincode}&date=#{date}")
    sample = JSON.parse(Net::HTTP.get_response(url).body)
    @data = sample["centers"]
    UserMailer.send_vaccine_slots_details(user, @data).deliver!
  end
end
