# Studio Maqam Booking on Cloudflare Pages

A free-tier friendly booking system for live events with:

- interactive seat map
- live cart total
- payment screenshot upload
- admin approval workflow
- QR ticket release only after payment confirmation
- single-use door scanning
- GitHub + Cloudflare Pages + D1 + R2 deployment

## Stack

- **Frontend:** static HTML/CSS/Vanilla JS on Cloudflare Pages
- **API:** Cloudflare Pages Functions
- **Database:** Cloudflare D1
- **File storage:** Cloudflare R2 for payment proof images
- **Bot protection:** optional Cloudflare Turnstile
- **Source control / CI trigger:** GitHub

## Project structure

```text
public/                 Static site
  index.html            Booking page + ticket lookup
  admin.html            Admin review page
  scan.html             Door scanner page
  assets/
functions/              Cloudflare Pages Functions API
schema.sql              D1 schema
wrangler.jsonc          Cloudflare config template
```

## What this release does

1. Customers choose seats from a live seat map.
2. The UI calculates the cart total instantly.
3. Customers submit name, phone, email, seats, payment reference, and payment screenshot.
4. Pending bookings lock those seats.
5. Admin reviews the booking in `/admin.html`.
6. Only when the admin clicks **Approve** are QR tickets generated.
7. Staff scan tickets in `/scan.html`.
8. Each QR token is redeemable **once** only.

## Before you deploy

### 1) Create a GitHub repo

Create an empty GitHub repository, then copy this project into it.

### 2) Install Wrangler locally

```bash
npm install
```

or, if you want Wrangler globally:

```bash
npm install -g wrangler
```

### 3) Create a D1 database

```bash
npx wrangler d1 create studio-maqam-booking
```

Copy the returned `database_id` into `wrangler.jsonc`.

### 4) Create an R2 bucket for payment screenshots

```bash
npx wrangler r2 bucket create studio-maqam-payments
```

If you use a different bucket name, update `wrangler.jsonc`.

### 5) Apply the schema

```bash
npx wrangler d1 execute studio-maqam-booking --remote --file=schema.sql
```

### 6) Add secrets

```bash
npx wrangler secret put ADMIN_PASSWORD
npx wrangler secret put TURNSTILE_SECRET
```

If you do not want Turnstile yet, skip `TURNSTILE_SECRET`.

### 7) Set optional public vars in `wrangler.jsonc`

Edit the `vars` block for:

- `EVENT_TITLE`
- `EVENT_DATE`
- `EVENT_VENUE`
- `EVENT_LOCATION_URL`
- `PAYMENT_LABEL`
- `PAYMENT_URL`
- `TURNSTILE_SITE_KEY`

### 8) Run locally

```bash
npm run dev
```

Open the local Pages preview URL shown by Wrangler.

### 9) Push to GitHub

```bash
git init
git add .
git commit -m "Initial release"
git branch -M main
git remote add origin YOUR_GITHUB_REPO_URL
git push -u origin main
```

### 10) Deploy on Cloudflare Pages

In Cloudflare Dashboard:

1. Go to **Workers & Pages**.
2. Create a **Pages** project.
3. Choose **Connect to Git**.
4. Select your GitHub repo.
5. Build command: leave blank.
6. Build output directory: `public`
7. Save and deploy.

Then add the same D1, R2, and secret bindings to the Pages project if not inherited automatically.

## Admin login

- Open `/admin.html`
- Enter the same value you stored in `ADMIN_PASSWORD`
- Review pending bookings
- Approve or reject bookings

## Door scanner

- Open `/scan.html`
- Enter the admin password
- Scan customer QR codes
- First scan succeeds, repeated scans are rejected

## Important notes

- The uploaded preview provided the visual direction. This release keeps the dark/gold theatre style, but does **not** hotlink any private uploaded image URLs.
- Replace placeholder branding in `public/assets/app.js` and `public/assets/styles.css` with your own logo/photos hosted publicly or stored in the repo.
- This version uses a **shared admin password** for simplicity on the free tier. For a harder lock, add Cloudflare Access in front of `/admin.html` and `/scan.html` later.
- Payment screenshots are stored in R2. Ticket QR codes are generated on demand in the browser.

## Recommended next upgrades

- add SMS / WhatsApp notifications
- add seat holds with expiry timers
- add public event list for multiple events
- add email delivery after approval
- add Cloudflare Access for admin routes
