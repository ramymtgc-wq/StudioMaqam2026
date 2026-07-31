CREATE TABLE IF NOT EXISTS bookings (
  id TEXT PRIMARY KEY,
  event_id TEXT NOT NULL,
  reference TEXT NOT NULL UNIQUE,
  full_name TEXT NOT NULL,
  phone TEXT NOT NULL,
  email TEXT,
  notes TEXT,
  payment_reference TEXT,
  payment_proof_key TEXT,
  seat_snapshot TEXT,
  amount_total INTEGER NOT NULL,
  currency TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'pending',
  created_at TEXT NOT NULL,
  approved_at TEXT,
  rejected_at TEXT,
  qr_issued_at TEXT
);

CREATE INDEX IF NOT EXISTS idx_bookings_event_status ON bookings(event_id, status);
CREATE INDEX IF NOT EXISTS idx_bookings_reference ON bookings(reference);
CREATE INDEX IF NOT EXISTS idx_bookings_phone ON bookings(phone);
CREATE INDEX IF NOT EXISTS idx_bookings_email ON bookings(email);

CREATE TABLE IF NOT EXISTS booking_seats (
  id TEXT PRIMARY KEY,
  booking_id TEXT NOT NULL,
  event_id TEXT NOT NULL,
  seat_code TEXT NOT NULL,
  zone TEXT NOT NULL,
  price INTEGER NOT NULL,
  created_at TEXT NOT NULL,
  UNIQUE(event_id, seat_code)
);

CREATE INDEX IF NOT EXISTS idx_booking_seats_booking ON booking_seats(booking_id);
CREATE INDEX IF NOT EXISTS idx_booking_seats_event ON booking_seats(event_id);

CREATE TABLE IF NOT EXISTS tickets (
  id TEXT PRIMARY KEY,
  booking_id TEXT NOT NULL,
  event_id TEXT NOT NULL,
  seat_code TEXT NOT NULL,
  ticket_no TEXT NOT NULL UNIQUE,
  token TEXT NOT NULL UNIQUE,
  status TEXT NOT NULL DEFAULT 'active',
  created_at TEXT NOT NULL,
  redeemed_at TEXT
);

CREATE INDEX IF NOT EXISTS idx_tickets_booking ON tickets(booking_id);
CREATE INDEX IF NOT EXISTS idx_tickets_token ON tickets(token);
