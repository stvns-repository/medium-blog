import os
import requests
import psycopg2
from flask import Flask, render_template, request
from datetime import datetime
import pytz

app = Flask(__name__)

# CONFIG
API_KEY = os.getenv('API_KEY')
DB_HOST = os.getenv('DB_HOST', 'postgres')
DB_PASSWORD = os.getenv('DB_PASS')
DB_NAME = os.getenv('DB_NAME', 'postgres')
DB_USER = os.getenv('DB_USER', 'postgres')
PST = pytz.timezone('America/Los_Angeles')

# Regional Multipliers
REGIONS = {
    "PH": {"name": "Philippines", "factor": 1.15, "currency": "PHP"},
    "SG": {"name": "Singapore", "factor": 1.05, "currency": "SGD"},
    "TH": {"name": "Thailand", "factor": 1.10, "currency": "THB"},
    "ID": {"name": "Indonesia", "factor": 1.00, "currency": "IDR"},
    "NZ": {"name": "New Zealand", "factor": 1.25, "currency": "NZD"},
    "AU": {"name": "Australia", "factor": 1.20, "currency": "AUD"}
}

def get_fx_rate(currency_code):
    """Fetches live USD to Local Currency rate"""
    if currency_code == "USD":
        return 1.0

    url = f"https://api.api-ninjas.com/v1/convertcurrency?have=USD&want={currency_code}&amount=1"
    try:
        response = requests.get(url, headers={'X-Api-Key': API_KEY}, timeout=5)
        if response.status_code == 200:
            return float(response.json().get('new_amount', 1.0))
    except Exception as e:
        print(f"FX API Error: {e}")

    fallbacks = {"PHP": 59.53, "SGD": 1.27, "THB": 31.98, "IDR": 16991.20, "NZD": 1.72, "AUD": 1.42}
    return fallbacks.get(currency_code, 1.0)

def init_db():
    try:
        conn = psycopg2.connect(host=DB_HOST, database="postgres", user="postgres", password=DB_PASSWORD)
        cur = conn.cursor()
        cur.execute("""
            CREATE TABLE IF NOT EXISTS oil_history (
                id SERIAL PRIMARY KEY,
                country_code VARCHAR(10),
                price_usd NUMERIC(10, 2),
                recorded_at DATE UNIQUE
            );
        """)
        conn.commit()
        cur.close()
        conn.close()
    except Exception as e:
        print(f"Database connection failed: {e}")

@app.route('/seed-data')
def seed_data():
    """Route to populate March 2026 data in Postgres"""
    try:
        conn = psycopg2.connect(host=DB_HOST, database="postgres", user="postgres", password=DB_PASSWORD)
        cur = conn.cursor()

        march_points = [
            ('GLOBAL', 82.15, '2026-03-01'),
            ('GLOBAL', 83.40, '2026-03-10'),
            ('GLOBAL', 84.45, '2026-03-15'),
            ('GLOBAL', 85.10, '2026-03-25'),
            ('GLOBAL', 84.80, '2026-03-31')
        ]

        for entry in march_points:
            cur.execute("""
                INSERT INTO oil_history (country_code, price_usd, recorded_at)
                VALUES (%s, %s, %s)
                ON CONFLICT (recorded_at) DO NOTHING
            """, entry)

        conn.commit()
        cur.close()
        conn.close()
        return "<h1>Success!</h1><p>Database seeded with March data. <a href='/'>Go back to Dashboard</a></p>"
    except Exception as e:
        return f"<h1>Error</h1><p>{str(e)}</p>"

@app.route('/')
def index():
    init_db()
    country_code = request.args.get('country', 'PH').upper()
    region_data = REGIONS.get(country_code, REGIONS['PH'])

    # 1. Fetch Brent Price
    try:
        api_url = 'https://api.api-ninjas.com/v1/commodityprice?name=brent_crude_oil'
        response = requests.get(api_url, headers={'X-Api-Key': API_KEY}, timeout=5)
        brent_usd = float(response.json().get('price', 84.45))
    except:
        brent_usd = 84.45

    # 2. Get Exchange Rate and Local Price
    fx_rate = get_fx_rate(region_data['currency'])
    local_price_final = (brent_usd * region_data['factor']) * fx_rate

    # 3. Pull History and Calculate Local Equiv in Python
    history_list = []
    try:
        conn = psycopg2.connect(host=DB_HOST, database="postgres", user="postgres", password=DB_PASSWORD)
        cur = conn.cursor()
        cur.execute("SELECT recorded_at, price_usd FROM oil_history ORDER BY recorded_at DESC")
        rows = cur.fetchall()

        # We calculate the multiplier once to keep it efficient
        # (Factor * FX Rate)
        multiplier = region_data['factor'] * fx_rate

        for r in rows:
            usd_val = float(r[1])
            history_list.append({
                'full_date': r[0].strftime('%B %d'),
                'usd_price': f"{usd_val:.2f}",
                'local_equiv': f"{usd_val * multiplier:,.2f}"
            })
        cur.close()
        conn.close()
    except Exception as e:
        print(f"History Fetch Error: {e}")

    current_time_pst = datetime.now(PST).strftime('%B %d, %Y | %I:%M %p %Z')

    return render_template('index.html',
                            country_name=region_data['name'],
                            price=f"{local_price_final:,.2f}",
                            brent=f"{brent_usd:.2f}",
                            time=current_time_pst,
                            currency=region_data['currency'],
                            fx_rate=f"{fx_rate:.2f}",
                            history_list=history_list)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
