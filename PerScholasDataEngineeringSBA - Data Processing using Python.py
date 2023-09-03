#The question gave us an API containing medical records. The API link is https://jsonmock.hackerrank.com/api/medical_records and it is a paginated API. We have to define a function that gives the minimum and maximum temperature on the basis of two arguments : the doctor name and the diagnosis ID. The function must return an integer format. The topics covered in this are web scraping and JSON requests.

import requests
import json

base_url = "https://jsonmock.hackerrank.com/api/medical_records/" #this is done in order to get the total number of pages in the API
base_response = requests.get(base_url)
base_data = base_response.json() 

def bodyTemperature(doctorName, diagnoseID):
    temperature_list = []
    min_temp = 0
    max_temp = 0
    for pagenumber in range(1,base_data['total_pages']+1): #+1 since we have to go through the entire API including the last page
        all_pages_urls = "https://jsonmock.hackerrank.com/api/medical_records?page={}".format(pagenumber)
        all_pages_response = requests.get(all_pages_urls)
        all_data = all_pages_response.json()

        for medicalrecord in all_data['data']:
            doctor = medicalrecord['doctor']
            diagnosis = medicalrecord['diagnosis']
            body_temperature = medicalrecord['vitals']['bodyTemperature']
            if doctorName == doctor['name'] and diagnoseID == diagnosis['id']:
                temperature_list.append(body_temperature)
                min_temp = min(temperature_list)
                max_temp = max(temperature_list)

    return (int(min_temp),int(max_temp)) #since we require output in integer format