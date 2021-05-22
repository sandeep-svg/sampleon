from cowin_api import CoWinAPI
import sys
c=CoWinAPI()
data=sys.argv[1].split(',')
pincode=data[0]
date=data[1]
age=int(data[2])
result=c.get_availability_by_pincode(pincode,date,age)
print(result['centers'])
