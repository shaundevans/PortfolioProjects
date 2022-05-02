import bs4
import requests
import re
import pandas as pd


helloRegex = re.compile(r'Hello', re.IGNORECASE)

#Adele - Hello
adele = requests.get('https://www.songlyrics.com/adele/hello-lyrics/')
adele.raise_for_status()
adele_soup = bs4.BeautifulSoup(adele.text, 'html.parser')
adele_h = adele_soup.select("#songLyricsDiv-outer")
adele_info = helloRegex.findall(str(adele_h))
a_low = str(adele_info).lower()
adele_tc = a_low.count('hello')
adele_upper = adele_info.count('Hello')
adele_lower = adele_info.count('hello')


# Beatles - Hello, Goodbye
beat = requests.get('https://www.lyrics.com/lyric/2762363/The+Beatles/Hello%2C+Goodbye')
beat.raise_for_status()
beat_soup = bs4.BeautifulSoup(beat.text, 'html.parser')
beatles = beat_soup.select("#lyric-body-text")
beatles_info = helloRegex.findall(str(beatles))
b_low = str(beatles_info).lower()
beatles_tc = b_low.count('hello')
beatles_upper = beatles_info.count('Hello')
beatles_lower = beatles_info.count('hello')


# Hello - Lionel Ritchie
lr = requests.get('https://www.azlyrics.com/lyrics/lionelrichie/hello.html')
lr.raise_for_status()
lr_soup = bs4.BeautifulSoup(lr.text, 'html.parser')
lr_h = lr_soup.select('body > div.container.main-page > div > div.col-xs-12.col-lg-8.text-center > div:nth-child(8)')
lionel_info = helloRegex.findall(str(lr_h))
lr_low = str(lionel_info).lower()
lionel_tc = lr_low.count('hello')
lionel_upper = lionel_info.count('Hello')
lionel_lower = lionel_info.count('hello')
#print(lionel_tc)




# Hello, I Love You - The Doors
dr = requests.get('https://www.azlyrics.com/lyrics/doors/helloiloveyou.html')
dr.raise_for_status()
dr_soup = bs4.BeautifulSoup(dr.text, 'html.parser')
doors = dr_soup.select('body > div.container.main-page > div > div.col-xs-12.col-lg-8.text-center > div:nth-child(8)')
doors_info = helloRegex.findall(str(doors))
dr_low = str(doors_info).lower()
doors_tc = dr_low.count('hello')
doors_upper = doors_info.count('Hello')
doors_lower = doors_info.count('hello')



# Hello, It's Me - Todd Rundgren
tr = requests.get('https://www.azlyrics.com/lyrics/toddrundgren/helloitsme.html')
tr.raise_for_status()
tr_soup = bs4.BeautifulSoup(tr.text, 'html.parser')
toddr = tr_soup.select('body > div.container.main-page > div > div.col-xs-12.col-lg-8.text-center > div:nth-child(8)')
tr_info = helloRegex.findall(str(toddr))
tr_low = str(tr_info).lower()
toddr_tc = tr_low.count('hello')
toddr_upper = tr_info.count('Hello')
toddr_lower = tr_info.count('hello')



# Hello Again - The Cars
cr = requests.get('https://www.azlyrics.com/lyrics/cars/helloagain.html')
cr.raise_for_status()
cr_soup = bs4.BeautifulSoup(cr.text, 'html.parser')
cars = cr_soup.select('body > div.container.main-page > div > div.col-xs-12.col-lg-8.text-center > div:nth-child(8)')
cars_info = helloRegex.findall(str(cars))
cr_low = str(cars_info).lower()
cars_tc = cr_low.count('hello')
cars_upper = cars_info.count('Hello')
cars_lower = cars_info.count('hello')


# Create a DataFrame from scraped data
All_Data = (['Adele', 'Hello', adele_tc, adele_upper,adele_lower],
            ['The Beatles', 'Hello, Goodbye', beatles_tc, beatles_upper, beatles_lower],
            ['Lionel Ritchie', 'Hello', lionel_tc, lionel_upper, lionel_lower],
            ['Todd Rundgren', "Hello, It's Me", toddr_tc, toddr_upper, toddr_lower],
            ['The Cars', 'Hello Again', cars_tc, cars_upper, cars_lower])

hello_df = pd.DataFrame(All_Data, columns = ['Artist', 'Song Title', 'Total', 'Uppercase','Lowercase'])