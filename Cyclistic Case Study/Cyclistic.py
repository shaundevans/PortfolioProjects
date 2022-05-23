import pandas as pd #imports, data frame manipulation
import seaborn as sns #plots and charts
from matplotlib import pyplot as plt #plots and charts
from matplotlib import axes as ax
import numpy as np


# Importing data
data = pd.read_csv(r'/Users/shaunevans/Desktop/dataframeclean.csv')
df2 = pd.read_csv(r'/Users/shaunevans/Desktop/df2.csv')
df_line = pd.read_csv(r'/Users/shaunevans/Desktop/linereport.csv')
hours = pd.read_csv(r'/Users/shaunevans/Desktop/hourlyreport.csv')
print(hours)

# Determining data types for imported data frame
print(data.dtypes)

# Counting any Null Values in data
print(data.isnull().sum())

#Membership Status and Rideable Type
sns.histplot(data=data, x='rideable_type', hue='member_casual', palette='muted', multiple='stack')
plt.title('Ridership by Member Status and Rideable Type')
plt.legend(title="Membership Status", labels=['Casual','Member'])
plt.xlabel('Rideable Type')
plt.ylabel('Total Rides')
plt.xticks(['docked_bike','electric_bike','classic_bike'],['Docked Bike','Electric Bike','Classic Bike'])
plt.show()

df_cor = data.corr()
sns.heatmap(df_cor, annot=True, cmap='coolwarm')
plt.show()





#Ridership by months
sns.histplot(data=df2, x='monthnum', hue='member_casual', multiple='stack', palette='muted', kde=True, bins=12)
plt.xticks([1,2,3,4,5,6,7,8,9,10,11,12],['January','February','March','April',
                                         'May','June','July','August','September',
                                         'October','November','December'])
plt.title("Monthly Usage Volume by Membership Status")
plt.ylabel("Total Rides")
plt.xlabel("Month")
plt.legend(title="Membership Status", labels=['Member','Casual Rider'])
plt.show()

print(df2.columns)


# Line Chart for Ridership by Day of the week and membership status
line1 = df_line[df_line.member_casual != 'member']
print(line1)

line2 = df_line[df_line.member_casual != 'casual']
print(line2)


x = line2['day_num']
y1 = line1['day_average']
y2 = line2['day_average']

plt.plot(x, y1, label = "Casual Riders",linestyle='-.')
plt.plot(x, y2, label = "Members", linestyle=':')
plt.xticks([1,2,3,4,5,6,7],['Sunday','Monday','Tuesday','Wednesday','Thursday',
                           'Friday','Saturday'])
plt.legend(df_line['member_casual'])
plt.ylabel('Average Hours Ridden')
plt.title('Ride Length by Membership Type and Day')
plt.show()

print(hours)

cas_hours = hours[hours.member_casual != 'member']
mem_hours = hours[hours.member_casual != 'casual']


plt.bar(cas_hours['start_hour'],cas_hours['count'],color='#4878d0')
plt.bar(mem_hours['start_hour'],mem_hours['count'],color='#ee854a')
plt.xticks([0.0,1.0,2.0,3.0,4.0,5.0,6.0,7.0,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0,16.0,17.0,18.0,19.0,20.0,21.0,22.0,23.0],['12:00 AM','1:00 AM','2:00 AM','3:00 AM','4:00 AM','5:00 AM','6:00 AM',
                                                                        '7:00 AM','8:00 AM','9:00 AM','10:00 AM','11:00 AM', '12:00 PM',
                                                                        '1:00 PM','2:00 PM','3:00 PM','4:00 PM','5:00 PM','6:00 PM','7:00 PM','8:00 PM',
                                                                        '9:00 PM','10:00 PM','11:00 PM'],rotation=90)
plt.legend(hours['member_casual'])
plt.ylabel('Count of Riders')
plt.xlabel('Ride Start Time')
plt.title('Usage by Hour and Membership Status')
plt.show()



pal = sns.color_palette("muted")
print(pal.as_hex())
