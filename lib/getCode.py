import selenium
from selenium import webdriver
# from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

url='https://www.fitbit.com/oauth2/authorize?response_type=code&client_id=22CCJW&redirect_uri=http://127.0.0.1:9000/&scope=activity%20nutrition%20heartrate%20location%20nutrition%20profile%20settings%20sleep%20social%20weight&expires_in=604800'
options = webdriver.ChromeOptions()
options.binary_location = "C:/Program Files/Google/Chrome/Application/chrome.exe"
options.add_argument('--headless')
chrome_driver_binary = "D:/Webdrivers/chromedriver.exe"
driver = webdriver.Chrome(chrome_driver_binary, options=options)
def fitbit_login():
    driver.get (url)
    driver.implicitly_wait(20)
    driver.find_element_by_id('ember672').send_keys('ballan.marius@yahoo.com')
    driver.find_element_by_id ('ember673').send_keys('1707suir@M')
    driver.find_element_by_id('ember713').click()
    # print(driver.current_url)
    WebDriverWait(driver, 10).until(EC.url_contains('code='))
    # print(driver.current_url)
    s=driver.current_url
    code = s[s.find('code=')+len('code='):s.find('#_=_')]
    # print(code)
    return code

code=fitbit_login()
print("code: "+code)

f = open("../assets/res/credentials.txt", "w")
f.write(code)
f.close()