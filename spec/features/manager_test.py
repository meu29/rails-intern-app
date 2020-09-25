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
    driver.find_element_by_name("user_id").send_keys("H184100001")
    time.sleep(1)
    driver.find_element_by_name("password").send_keys("password")
    time.sleep(1)
    driver.find_element_by_xpath("//input[@name='login']").click()
    time.sleep(1)
    print("ログイン成功")
except:
    print("ログイン済み")

print("期間選択")
driver.find_element_by_xpath("//input[@name='commit']").click()
time.sleep(1)
print("ユーザー取得")
driver.find_elements_by_xpath("//input[@name='commit']")[1].click()
time.sleep(1)
print("報告取得")
checkboxes = driver.find_elements_by_xpath("//input[@type='checkbox']")
time.sleep(1)

print("報告承認")

for checkbox in checkboxes:
    checkbox.click()
    time.sleep(1)

try:
    driver.find_element_by_xpath("//input[@name='check_lack']").click()
    time.sleep(1)
    driver.find_element_by_xpath("//input[@name='approval']").click()
    time.sleep(1)
except Exception as e:
    print(e)

driver.quit()
