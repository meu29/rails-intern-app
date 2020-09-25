from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import time

options = webdriver.ChromeOptions()
options.binary_location = "/usr/bin/google-chrome"
options.add_argument("--headless") #headlessじゃないとエラー
options.add_argument("--no-sandbox")

driver = webdriver.Chrome("/home/meu/RailsInternApp/spec/features/chromedriver", options=options)

driver.get("http:localhost:3000")
time.sleep(1)

try:
    driver.find_element_by_name("user_id").send_keys("H184100002")
    time.sleep(1)
    driver.find_element_by_name("password").send_keys("password")
    time.sleep(1)
    driver.find_element_by_xpath("//input[@name='login']").click()
    time.sleep(1)
    print("ログイン成功")
except:
    print("ログイン済み")
'''
print("期間選択")
driver.find_element_by_xpath("//input[@name='commit']").click()
time.sleep(5)

print("報告取得")
driver.find_element_by_xpath("//input[@type='submit']").click()
time.sleep(5)
'''
print("報告承認依頼")
driver.get("http://localhost:3000/report?period=2020-9&state=%E5%85%A8%E3%81%A6&user_id=H184100002&commit=%E6%B1%BA%E5%AE%9A")
time.sleep(3)

start_time_text_fields = driver.find_elements_by_xpath("//input[@name='start_time[]']")
finish_time_text_fields = driver.find_elements_by_xpath("//input[@name='finish_time[]']")
break_time_text_fields = driver.find_elements_by_xpath("//input[@name='break_time[]']") 

for s_field, f_field, b_field in zip(start_time_text_fields, finish_time_text_fields, break_time_text_fields):
    
    s_field.clear()
    time.sleep(1)
    s_field.send_keys("09:00")
    time.sleep(1)
    f_field.clear()
    time.sleep(1)
    f_field.send_keys("17:00")
    time.sleep(1)
    b_field.clear()
    time.sleep(1)
    b_field.send_keys(60)
    time.sleep(1)

try:
    driver.find_element_by_xpath("//button").click()
    time.sleep(1)
    driver.find_element_by_xpath("//input[@name='approval_request']").click()
    time.sleep(1)
    print("報告承認依頼完了")
except Exception as e:
    print(e)

driver.quit()