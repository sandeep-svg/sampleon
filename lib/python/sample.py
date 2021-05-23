import requests
import sys
#from fake_useragent import UserAgent
#temp_user_agent = UserAgent()
#browser_header = {'User-Agent': temp_user_agent.random}

data=sys.argv[1].split(',')
pincode=data[0]
date=data[1]
url = "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode={}&date={}".format(pincode, date)
header = {"User-Agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.182 Safari/537.36"}
result = requests.request("GET",url, headers=header)
print(result.text)
