import pandas as pd
import numpy as np
import PySimpleGUI as psg
import selenium
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import NoSuchElementException
import openpyxl
import time
import datetime
from datetime import datetime as dt

###### LOGIC FOR MANUAL ENTRY OF STARTING AND ENDING ADDRESS #####
#Add1 = []
#Add2 = []

#print('Enter Your Starting Address')
#Add1.append(input())
#print('Enter Your Destination Address')
#Add2.append(input())

#df = pd.DataFrame([])
#df['Address 1'] = Add1
#df['Address 2'] = Add2

print('Starting At: ' + str(dt.now()))

#### LOGIC FOR USING AN IMPORTED EXCEL LIST/CSV WITH ADDRESSES ######
data = pd.read_excel(r'/Users/########/Desktop/Address Feed.xlsx', sheet_name='Sheet1')
data = pd.DataFrame(data)

df = pd.DataFrame([])
df['Address 1'] = data['Start']
df['Address 2'] = data['End']


#df = pd.DataFrame({'Address 1': ['Klamath Falls, OR'],'Address 2': ['5860 NE Cornell Rd Hillsboro, OR 97124']})
#df2 = pd.DataFrame({'Address 1': ['Prineville, OR 97754'],'Address 2': ['5860 NE Cornell Rd Hillsboro, OR 97124']})
#df = pd.concat([df, df2], ignore_index = True)

options = Options()
#options.headless = True
driver = webdriver.Chrome(options=options)
#options.add_argument('--headless=new')
driver.implicitly_wait(10)
driver.get('http://www.google.com/maps/dir/')

distance = []
r = 0

for i in df.index:
    driver.find_element(By.XPATH,'//*[@id="sb_ifc50"]/input').send_keys(df['Address 1'][i])
    time.sleep(0.50)
    driver.find_element(By.XPATH,'//*[@id="sb_ifc51"]/input').send_keys(df['Address 2'][i])
    time.sleep(0.50)
    driver.find_element(By.XPATH,'//*[@id="sb_ifc51"]/input').send_keys(Keys.ENTER)
    try:
        distance.append(driver.find_element(By.XPATH,'//*[@id="section-directions-trip-0"]/div[1]/div/div[1]/div[2]/div').get_attribute('innerHTML'))
    except Exception:
        distance.append('0 miles')
   # driver.find_element(By.XPATH, '//*[@id="sb_ifc51"]/input').send_keys(Keys.F5) # Preventing Timeout with Refresh
    #time.sleep(0.50)
    try:
        driver.find_element(By.XPATH, '//*[@id="sb_ifc50"]/input').clear()
        time.sleep(0.50)
        driver.find_element(By.XPATH, '//*[@id="sb_ifc51"]/input').clear()
    except NoSuchElementException:
        driver.manage().delete_all_cookies()
        time.sleep(1)
        driver.get('http://www.google.com/maps/dir/')
    #time.sleep(1)
    r+=1
    print(r)

df['Distance'] = distance
print(df)
df.to_csv(r'/Users/#########/Desktop/AddressAndDistance.csv') #Output Final Outcome to CSV
driver.quit()

print('Ending At: ' + str(dt.now()))
