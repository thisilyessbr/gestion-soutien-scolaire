from playwright.sync_api import sync_playwright
import os

BASE_URL = "http://localhost:8080"
OUT_DIR = os.path.dirname(os.path.abspath(__file__))
SCREENSHOTS_DIR = os.path.join(OUT_DIR, "screenshots")
os.makedirs(SCREENSHOTS_DIR, exist_ok=True)

VIEWPORT = {"width": 1400, "height": 900}

def screenshot(page, name):
    path = os.path.join(SCREENSHOTS_DIR, f"{name}.png")
    page.screenshot(path=path, full_page=True)
    print(f"Screenshot saved: {path}")

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    context = browser.new_context(viewport=VIEWPORT)
    page = context.new_page()

    # Login as admin
    page.goto(f"{BASE_URL}/login.jsp")
    page.wait_for_load_state("networkidle")
    screenshot(page, "login")

    page.fill('input[name="txt"]', "admin")
    page.fill('input[name="pwd"]', "admin")
    page.click('button.btn')
    page.wait_for_load_state("networkidle")
    screenshot(page, "admin-dashboard")

    # Students management
    page.goto(f"{BASE_URL}/Students.jsp")
    page.wait_for_load_state("networkidle")
    screenshot(page, "admin-students")

    # Professors management
    page.goto(f"{BASE_URL}/Profs.jsp")
    page.wait_for_load_state("networkidle")
    screenshot(page, "admin-profs")

    # Courses management
    page.goto(f"{BASE_URL}/Cours.jsp")
    page.wait_for_load_state("networkidle")
    screenshot(page, "admin-cours")

    # Rooms
    page.goto(f"{BASE_URL}/salle.jsp")
    page.wait_for_load_state("networkidle")
    screenshot(page, "admin-salles")

    # Logout and login as professor
    page.goto(f"{BASE_URL}/login.jsp")
    page.fill('input[name="txt"]', "said.alami")
    page.fill('input[name="pwd"]', "said")
    page.click('button.btn')
    page.wait_for_load_state("networkidle")
    screenshot(page, "prof-dashboard")

    # Professor seance page
    page.goto(f"{BASE_URL}/SeanceProf.jsp")
    page.wait_for_load_state("networkidle")
    screenshot(page, "prof-seances")

    # Logout and login as student
    page.goto(f"{BASE_URL}/login.jsp")
    page.fill('input[name="txt"]', "ilyes.saber")
    page.fill('input[name="pwd"]', "ilyes")
    page.click('button.btn')
    page.wait_for_load_state("networkidle")
    screenshot(page, "student-dashboard")

    browser.close()
    print("All screenshots captured.")
