import unittest
from selenium import webdriver
from selenium.webdriver.common.by import By
import time

class LiatrioBootcampLinkTest(unittest.TestCase):
    def setUp(self):
        # choose which webdriver to use
        self.driver = webdriver.Chrome()
        self.driver.implicitly_wait(10)

    def test_bootcamp_link(self):
        driver = self.driver
        driver.get("https://devops-bootcamp.liatr.io")
        time.sleep(2) 
        # check we get expected page title
        self.assertEqual(driver.title, "Welcome", "Title is incorrect, got: " + driver.title)
        print("Title is correct: " + driver.title)
        # find the link to Introduction to DevOps section at the bottom of the page
        driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
        link = driver.find_element(By.LINK_TEXT, '1.0 - Introduction to DevOps')
        self.assertIsNotNone(link, "Link not found")
        print("Found link: " + link.text)
        link.click()
        time.sleep(2)
        # check that we get the expected url
        self.assertEqual(driver.current_url, "https://devops-bootcamp.liatr.io/#/1-introduction/1.0-overview", "URL is incorrect, got: " + driver.current_url)
        print("URL is correct: " + driver.current_url)

class LiatrioBootcampSidebarTest(unittest.TestCase):
    def setUp(self):
        # choose which webdriver to use
        self.driver = webdriver.Chrome()
        self.driver.implicitly_wait(10)

    def test_bootcamp_sidebar(self):
        driver = self.driver
        driver.get("https://devops-bootcamp.liatr.io")
        time.sleep(2)
        # check that the sidebar is shown (HINT: check html body attributes)
        body = driver.find_element(By.TAG_NAME, 'body')
        self.assertIsNotNone(body, "Body not found")
        self.assertNotIn("close", body.get_attribute("class"))

        # check that there is no CLOSE attribute on the body
        self.assertNotIn("close", body.get_attribute("class"))

        # find the sidebar toggle and toggle it
        driver.find_element(By.CLASS_NAME, 'sidebar-toggle').click()
        time.sleep(2)

        # after toggling sidebar, check that it is closed
        self.assertIn("close", body.get_attribute("class"))




    def tearDown(self):
        self.driver.quit()


if __name__ == "__main__":
    unittest.main()