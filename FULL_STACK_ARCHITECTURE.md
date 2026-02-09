# 🏗️ Blood Near Me - Full-Stack Architecture
## Principal Engineer Level Implementation Plan

**Document Version**: 1.0
**Last Updated**: 2026-02-09
**Architecture Level**: Production-Grade, Scalable to 10M+ users

---

## 🎯 Executive Summary

This document outlines the complete full-stack architecture for Blood Near Me - a life-saving blood bank finder platform for India. Built with production-grade patterns used by companies like Airbnb, Uber, and Stripe.

**Technology Stack:**
- **Frontend**: Vanilla JS (ES6+), PWA, Service Workers
- **Backend**: Node.js + Express + TypeScript
- **Database**: PostgreSQL (primary) + Redis (cache)
- **Real-time**: WebSockets (Socket.io)
- **Infrastructure**: Docker + Docker Compose
- **Deployment**: AWS/GCP (containerized)
- **Monitoring**: Winston + Sentry + Prometheus
- **CI/CD**: GitHub Actions

---

## 📊 System Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        CLOUDFLARE CDN                            │
│                     (DDoS Protection, Cache)                     │
└────────────────────────────┬────────────────────────────────────┘
                             │
┌────────────────────────────▼────────────────────────────────────┐
│                       LOAD BALANCER                              │
│                    (NGINX / AWS ALB)                             │
└──────────┬─────────────────────────────────────┬────────────────┘
           │                                     │
┌──────────▼──────────┐              ┌──────────▼──────────┐
│   WEB SERVER 1      │              │   WEB SERVER 2      │
│   (Static Files)    │              │   (Static Files)    │
│   - HTML/CSS/JS     │              │   - HTML/CSS/JS     │
│   - Images/Assets   │              │   - Images/Assets   │
└─────────────────────┘              └─────────────────────┘
           │                                     │
┌──────────▼─────────────────────────────────────▼────────────────┐
│                     API GATEWAY                                  │
│              (Rate Limiting, Authentication)                     │
└────────────────────────────┬─────────────────────────────────────┘
                             │
           ┌─────────────────┼─────────────────┐
           │                 │                 │
┌──────────▼──────┐  ┌──────▼──────┐  ┌──────▼──────┐
│  API Server 1   │  │ API Server 2 │  │ API Server 3│
│  (Node.js)      │  │ (Node.js)    │  │ (Node.js)   │
│  - REST API     │  │ - REST API   │  │ - REST API  │
│  - WebSockets   │  │ - WebSockets │  │ - WebSockets│
│  - Business     │  │ - Business   │  │ - Business  │
│    Logic        │  │   Logic      │  │   Logic     │
└────────┬────────┘  └──────┬───────┘  └──────┬──────┘
         │                  │                  │
         └──────────────────┼──────────────────┘
                            │
         ┌──────────────────┼──────────────────┐
         │                  │                  │
┌────────▼─────┐   ┌────────▼─────┐   ┌───────▼──────┐
│ PostgreSQL   │   │    Redis      │   │  ElasticSearch│
│ (Primary DB) │   │   (Cache)     │   │  (Search)    │
│              │   │   - Sessions  │   │  - Blood Bank│
│ - Users      │   │   - Rate Limit│   │    Search    │
│ - Blood Banks│   │   - Temp Data │   │  - Logs      │
│ - Donations  │   │               │   │              │
│ - SOS Alerts │   │               │   │              │
└──────────────┘   └───────────────┘   └──────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    EXTERNAL SERVICES                             │
├─────────────────────────────────────────────────────────────────┤
│  - Twilio (SMS)        - SendGrid (Email)                       │
│  - Google Maps API     - Firebase (Push Notifications)          │
│  - Sentry (Error)      - AWS S3 (File Storage)                  │
│  - Stripe (Payments)   - Prometheus (Metrics)                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🗄️ Database Schema Design

### PostgreSQL Tables

#### 1. Users Table
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phone VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE,
    full_name VARCHAR(255) NOT NULL,
    blood_type VARCHAR(5) NOT NULL CHECK (blood_type IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
    date_of_birth DATE,
    gender VARCHAR(10) CHECK (gender IN ('male', 'female', 'other')),
    location GEOGRAPHY(POINT),
    city VARCHAR(100),
    state VARCHAR(100),
    is_donor BOOLEAN DEFAULT false,
    is_verified BOOLEAN DEFAULT false,
    profile_photo_url TEXT,
    fcm_token TEXT, -- For push notifications
    role VARCHAR(20) DEFAULT 'user' CHECK (role IN ('user', 'admin', 'blood_bank_admin')),
    last_login_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_users_phone ON users(phone);
CREATE INDEX idx_users_blood_type ON users(blood_type);
CREATE INDEX idx_users_location ON users USING GIST(location);
CREATE INDEX idx_users_city ON users(city);
```

#### 2. Blood Banks Table
```sql
CREATE TABLE blood_banks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    registration_number VARCHAR(100) UNIQUE,
    hospital_affiliated BOOLEAN DEFAULT false,

    -- Contact
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(255),
    website TEXT,

    -- Location
    address TEXT NOT NULL,
    location GEOGRAPHY(POINT) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    pincode VARCHAR(10),

    -- Operational
    operating_hours JSONB, -- {mon: "9-17", tue: "9-17", ...}
    has_component_separation BOOLEAN DEFAULT false,
    has_apheresis BOOLEAN DEFAULT false,

    -- Verification
    is_verified BOOLEAN DEFAULT false,
    verified_by UUID REFERENCES users(id),
    verified_at TIMESTAMP WITH TIME ZONE,
    verification_source VARCHAR(50), -- 'admin', 'community', 'government'

    -- Trust Score (calculated)
    trust_score DECIMAL(3,2) DEFAULT 0.00 CHECK (trust_score BETWEEN 0 AND 1),
    total_verifications INT DEFAULT 0,

    -- Meta
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_blood_banks_location ON blood_banks USING GIST(location);
CREATE INDEX idx_blood_banks_city ON blood_banks(city);
CREATE INDEX idx_blood_banks_verified ON blood_banks(is_verified);
CREATE INDEX idx_blood_banks_trust_score ON blood_banks(trust_score DESC);
```

#### 3. Blood Inventory Table
```sql
CREATE TABLE blood_inventory (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    blood_bank_id UUID NOT NULL REFERENCES blood_banks(id) ON DELETE CASCADE,
    blood_type VARCHAR(5) NOT NULL CHECK (blood_type IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
    component_type VARCHAR(20) NOT NULL DEFAULT 'whole_blood'
        CHECK (component_type IN ('whole_blood', 'packed_rbc', 'plasma', 'platelets', 'cryoprecipitate')),

    units_available INT NOT NULL DEFAULT 0 CHECK (units_available >= 0),
    units_reserved INT DEFAULT 0 CHECK (units_reserved >= 0),

    last_updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_by UUID REFERENCES users(id),

    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    UNIQUE(blood_bank_id, blood_type, component_type)
);

CREATE INDEX idx_inventory_blood_bank ON blood_inventory(blood_bank_id);
CREATE INDEX idx_inventory_blood_type ON blood_inventory(blood_type);
CREATE INDEX idx_inventory_availability ON blood_inventory(units_available) WHERE units_available > 0;
```

#### 4. Donors Table
```sql
CREATE TABLE donors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,

    -- Medical Info
    weight_kg DECIMAL(5,2),
    hemoglobin_level DECIMAL(4,2),
    has_chronic_illness BOOLEAN DEFAULT false,
    chronic_illness_details TEXT,
    is_on_medication BOOLEAN DEFAULT false,
    medication_details TEXT,

    -- Donation History
    total_donations INT DEFAULT 0,
    last_donation_date DATE,
    next_eligible_date DATE,

    -- Preferences
    willing_to_travel_km INT DEFAULT 10,
    preferred_donation_type VARCHAR(20) DEFAULT 'whole_blood'
        CHECK (preferred_donation_type IN ('whole_blood', 'platelets', 'plasma')),
    notify_emergency BOOLEAN DEFAULT true,
    notify_nearby_requests BOOLEAN DEFAULT true,

    -- Gamification
    points INT DEFAULT 0,
    badge_level VARCHAR(20) DEFAULT 'bronze' CHECK (badge_level IN ('bronze', 'silver', 'gold', 'platinum')),

    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_donors_user ON donors(user_id);
CREATE INDEX idx_donors_next_eligible ON donors(next_eligible_date);
CREATE INDEX idx_donors_points ON donors(points DESC);
```

#### 5. Donation Records Table
```sql
CREATE TABLE donation_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    donor_id UUID NOT NULL REFERENCES donors(id),
    blood_bank_id UUID REFERENCES blood_banks(id),

    donation_date DATE NOT NULL,
    blood_type VARCHAR(5) NOT NULL,
    component_type VARCHAR(20) NOT NULL DEFAULT 'whole_blood',
    volume_ml INT,

    -- Verification
    is_verified BOOLEAN DEFAULT false,
    verification_photo_url TEXT,
    certificate_url TEXT,

    -- Rewards
    points_earned INT DEFAULT 10,

    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_donations_donor ON donation_records(donor_id);
CREATE INDEX idx_donations_blood_bank ON donation_records(blood_bank_id);
CREATE INDEX idx_donations_date ON donation_records(donation_date DESC);
```

#### 6. SOS Alerts Table
```sql
CREATE TABLE sos_alerts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_by UUID NOT NULL REFERENCES users(id),

    -- Request Details
    blood_type VARCHAR(5) NOT NULL,
    component_type VARCHAR(20) DEFAULT 'whole_blood',
    units_needed INT NOT NULL,
    urgency VARCHAR(20) DEFAULT 'urgent' CHECK (urgency IN ('critical', 'urgent', 'moderate')),

    -- Patient Info
    patient_name VARCHAR(255),
    patient_age INT,
    patient_gender VARCHAR(10),
    hospital_name VARCHAR(255) NOT NULL,

    -- Location
    location GEOGRAPHY(POINT) NOT NULL,
    city VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,

    -- Contact
    contact_phone VARCHAR(15) NOT NULL,
    contact_name VARCHAR(255) NOT NULL,

    -- Status
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'fulfilled', 'cancelled', 'expired')),
    expires_at TIMESTAMP WITH TIME ZONE,
    fulfilled_at TIMESTAMP WITH TIME ZONE,

    -- Tracking
    view_count INT DEFAULT 0,
    response_count INT DEFAULT 0,
    share_count INT DEFAULT 0,

    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_sos_status ON sos_alerts(status) WHERE status = 'active';
CREATE INDEX idx_sos_blood_type ON sos_alerts(blood_type);
CREATE INDEX idx_sos_location ON sos_alerts USING GIST(location);
CREATE INDEX idx_sos_created_at ON sos_alerts(created_at DESC);
```

#### 7. SOS Responses Table
```sql
CREATE TABLE sos_responses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sos_alert_id UUID NOT NULL REFERENCES sos_alerts(id) ON DELETE CASCADE,
    donor_id UUID NOT NULL REFERENCES donors(id),

    response_type VARCHAR(20) DEFAULT 'willing' CHECK (response_type IN ('willing', 'donated', 'shared')),
    message TEXT,

    -- If donated
    donation_record_id UUID REFERENCES donation_records(id),

    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_sos_responses_alert ON sos_responses(sos_alert_id);
CREATE INDEX idx_sos_responses_donor ON sos_responses(donor_id);
```

#### 8. Verifications Table (Crowdsourced Trust)
```sql
CREATE TABLE verifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    blood_bank_id UUID NOT NULL REFERENCES blood_banks(id) ON DELETE CASCADE,
    verified_by UUID NOT NULL REFERENCES users(id),

    verification_type VARCHAR(30) NOT NULL CHECK (verification_type IN
        ('phone_working', 'location_correct', 'availability_accurate', 'staff_helpful', 'timely_service')),

    is_positive BOOLEAN NOT NULL,
    comment TEXT,
    proof_photo_url TEXT,

    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    UNIQUE(blood_bank_id, verified_by, verification_type, created_at::date)
);

CREATE INDEX idx_verifications_blood_bank ON verifications(blood_bank_id);
CREATE INDEX idx_verifications_user ON verifications(verified_by);
```

#### 9. Reviews Table
```sql
CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    blood_bank_id UUID NOT NULL REFERENCES blood_banks(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id),

    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    tags JSONB, -- ["helpful_staff", "quick_service", "clean_facility"]

    helpful_count INT DEFAULT 0,
    report_count INT DEFAULT 0,
    is_hidden BOOLEAN DEFAULT false,

    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    UNIQUE(blood_bank_id, user_id)
);

CREATE INDEX idx_reviews_blood_bank ON reviews(blood_bank_id);
CREATE INDEX idx_reviews_rating ON reviews(rating DESC);
```

#### 10. Sessions Table (for Auth)
```sql
CREATE TABLE sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    refresh_token TEXT NOT NULL UNIQUE,
    device_info JSONB, -- {type: 'mobile', os: 'android', ...}
    ip_address INET,
    user_agent TEXT,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_sessions_user ON sessions(user_id);
CREATE INDEX idx_sessions_refresh_token ON sessions(refresh_token);
CREATE INDEX idx_sessions_expires ON sessions(expires_at);
```

#### 11. Notifications Table
```sql
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,

    type VARCHAR(30) NOT NULL CHECK (type IN
        ('sos_nearby', 'blood_available', 'donation_reminder', 'badge_earned', 'verification_approved')),

    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    data JSONB, -- Additional context

    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMP WITH TIME ZONE,

    sent_via JSONB DEFAULT '["in_app"]', -- ["in_app", "push", "sms", "email"]

    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_unread ON notifications(user_id, is_read) WHERE is_read = false;
```

#### 12. Audit Logs Table
```sql
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    action VARCHAR(50) NOT NULL, -- 'user_login', 'inventory_update', 'sos_created'
    entity_type VARCHAR(50), -- 'user', 'blood_bank', 'sos_alert'
    entity_id UUID,
    changes JSONB, -- {before: {...}, after: {...}}
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_audit_user ON audit_logs(user_id);
CREATE INDEX idx_audit_entity ON audit_logs(entity_type, entity_id);
CREATE INDEX idx_audit_created ON audit_logs(created_at DESC);
```

---

## 🔌 API Endpoints Design

### Base URL Structure
```
Production:  https://api.bloodnearme.in/v1
Staging:     https://api-staging.bloodnearme.in/v1
Development: http://localhost:3000/v1
```

### Authentication Endpoints

#### POST /auth/send-otp
```json
Request:
{
  "phone": "+919876543210"
}

Response: 200 OK
{
  "success": true,
  "message": "OTP sent successfully",
  "expires_in": 300
}
```

#### POST /auth/verify-otp
```json
Request:
{
  "phone": "+919876543210",
  "otp": "123456"
}

Response: 200 OK
{
  "success": true,
  "user": {
    "id": "uuid",
    "phone": "+919876543210",
    "full_name": "John Doe",
    "blood_type": "A+",
    "is_donor": true
  },
  "tokens": {
    "access_token": "jwt_token",
    "refresh_token": "refresh_token",
    "expires_in": 3600
  }
}
```

#### POST /auth/refresh
```json
Request:
{
  "refresh_token": "refresh_token_here"
}

Response: 200 OK
{
  "access_token": "new_jwt_token",
  "expires_in": 3600
}
```

#### POST /auth/logout
```json
Request:
{
  "refresh_token": "refresh_token_here"
}

Response: 200 OK
{
  "success": true
}
```

### User Endpoints

#### GET /users/me
```json
Response: 200 OK
{
  "id": "uuid",
  "phone": "+919876543210",
  "email": "user@example.com",
  "full_name": "John Doe",
  "blood_type": "A+",
  "is_donor": true,
  "is_verified": true,
  "location": {
    "lat": 12.9716,
    "lng": 77.5946
  },
  "city": "Bangalore",
  "donor_profile": {
    "total_donations": 5,
    "last_donation_date": "2025-12-15",
    "next_eligible_date": "2026-03-15",
    "points": 150,
    "badge_level": "silver"
  }
}
```

#### PUT /users/me
```json
Request:
{
  "full_name": "John Doe Updated",
  "email": "newemail@example.com",
  "blood_type": "A+",
  "date_of_birth": "1990-01-15",
  "gender": "male"
}

Response: 200 OK
{
  "success": true,
  "user": { /* updated user object */ }
}
```

#### POST /users/location
```json
Request:
{
  "lat": 12.9716,
  "lng": 77.5946,
  "city": "Bangalore",
  "state": "Karnataka"
}

Response: 200 OK
{
  "success": true
}
```

### Blood Bank Endpoints

#### GET /blood-banks
```
Query Parameters:
- lat (required): 12.9716
- lng (required): 77.5946
- blood_type (required): A+
- radius_km (optional, default: 25): 50
- component_type (optional): whole_blood
- min_units (optional): 1
- verified_only (optional): true
- limit (optional, default: 20): 50
- offset (optional, default: 0): 0

Response: 200 OK
{
  "total": 45,
  "limit": 20,
  "offset": 0,
  "blood_banks": [
    {
      "id": "uuid",
      "name": "Bangalore Medical College Blood Bank",
      "phone": "080-26702355",
      "address": "K.R. Road, Fort, Bangalore - 560002",
      "location": {
        "lat": 12.9716,
        "lng": 77.5946
      },
      "distance_km": 2.3,
      "is_verified": true,
      "trust_score": 0.92,
      "operating_hours": {
        "monday": "09:00-17:00",
        "tuesday": "09:00-17:00"
      },
      "inventory": {
        "blood_type": "A+",
        "component_type": "whole_blood",
        "units_available": 15,
        "last_updated_at": "2026-02-09T10:30:00Z"
      },
      "rating": 4.5,
      "review_count": 234
    }
  ]
}
```

#### GET /blood-banks/:id
```json
Response: 200 OK
{
  "id": "uuid",
  "name": "Bangalore Medical College Blood Bank",
  "registration_number": "KA/BLR/BB/001",
  "phone": "080-26702355",
  "email": "bloodbank@bmch.ac.in",
  "website": "https://bmch.ac.in/bloodbank",
  "address": "K.R. Road, Fort, Bangalore - 560002",
  "location": {
    "lat": 12.9716,
    "lng": 77.5946
  },
  "city": "Bangalore",
  "is_verified": true,
  "trust_score": 0.92,
  "total_verifications": 1500,
  "operating_hours": { /* hours */ },
  "has_component_separation": true,
  "has_apheresis": true,
  "inventory": [
    {
      "blood_type": "A+",
      "component_type": "whole_blood",
      "units_available": 15,
      "last_updated_at": "2026-02-09T10:30:00Z"
    }
  ],
  "reviews": {
    "average_rating": 4.5,
    "total_reviews": 234,
    "recent_reviews": [ /* review objects */ ]
  }
}
```

#### POST /blood-banks/:id/verify
```json
Request:
{
  "verification_type": "phone_working",
  "is_positive": true,
  "comment": "Called and confirmed they have blood available",
  "proof_photo": "base64_or_url"
}

Response: 201 Created
{
  "success": true,
  "verification": {
    "id": "uuid",
    "blood_bank_id": "uuid",
    "verification_type": "phone_working",
    "is_positive": true,
    "created_at": "2026-02-09T12:00:00Z"
  }
}
```

#### POST /blood-banks/:id/review
```json
Request:
{
  "rating": 5,
  "review_text": "Great service, helpful staff",
  "tags": ["helpful_staff", "quick_service"]
}

Response: 201 Created
{
  "success": true,
  "review": { /* review object */ }
}
```

### SOS Alert Endpoints

#### POST /sos-alerts
```json
Request:
{
  "blood_type": "A+",
  "component_type": "whole_blood",
  "units_needed": 2,
  "urgency": "critical",
  "patient_name": "Jane Doe",
  "patient_age": 45,
  "patient_gender": "female",
  "hospital_name": "Apollo Hospital",
  "location": {
    "lat": 12.9716,
    "lng": 77.5946
  },
  "city": "Bangalore",
  "address": "154 Bannerghatta Road",
  "contact_phone": "+919876543210",
  "contact_name": "John Doe"
}

Response: 201 Created
{
  "success": true,
  "sos_alert": {
    "id": "uuid",
    "blood_type": "A+",
    "urgency": "critical",
    "status": "active",
    "expires_at": "2026-02-10T12:00:00Z",
    "created_at": "2026-02-09T12:00:00Z"
  },
  "broadcast": {
    "donors_notified": 450,
    "radius_km": 25
  }
}
```

#### GET /sos-alerts
```
Query Parameters:
- status (optional): active
- blood_type (optional): A+
- lat (optional): 12.9716
- lng (optional): 77.5946
- radius_km (optional): 50
- limit: 20
- offset: 0

Response: 200 OK
{
  "total": 12,
  "sos_alerts": [ /* array of SOS alerts */ ]
}
```

#### POST /sos-alerts/:id/respond
```json
Request:
{
  "response_type": "willing",
  "message": "I can donate, please share hospital details"
}

Response: 201 Created
{
  "success": true,
  "response": {
    "id": "uuid",
    "sos_alert_id": "uuid",
    "response_type": "willing",
    "created_at": "2026-02-09T12:30:00Z"
  }
}
```

### Donor Endpoints

#### POST /donors/register
```json
Request:
{
  "weight_kg": 65,
  "hemoglobin_level": 13.5,
  "has_chronic_illness": false,
  "willing_to_travel_km": 15,
  "preferred_donation_type": "whole_blood",
  "notify_emergency": true
}

Response: 201 Created
{
  "success": true,
  "donor": { /* donor profile */ }
}
```

#### POST /donors/record-donation
```json
Request:
{
  "blood_bank_id": "uuid",
  "donation_date": "2026-02-09",
  "blood_type": "A+",
  "component_type": "whole_blood",
  "volume_ml": 450,
  "certificate_photo": "base64_or_url"
}

Response: 201 Created
{
  "success": true,
  "donation": { /* donation record */ },
  "points_earned": 10,
  "badge_update": {
    "previous": "bronze",
    "current": "silver",
    "progress": 50
  }
}
```

#### GET /donors/leaderboard
```
Response: 200 OK
{
  "leaderboard": [
    {
      "rank": 1,
      "user": {
        "id": "uuid",
        "full_name": "Anonymous Donor",
        "blood_type": "A+"
      },
      "total_donations": 25,
      "points": 500,
      "badge_level": "platinum"
    }
  ]
}
```

---

## 🔐 Security Architecture

### 1. Authentication Flow
```
1. User enters phone number
2. Backend generates 6-digit OTP
3. OTP sent via Twilio SMS
4. OTP stored in Redis with 5-minute expiry
5. User submits OTP
6. Backend verifies OTP
7. Generate JWT access token (15 min expiry)
8. Generate refresh token (30 days expiry)
9. Store refresh token in PostgreSQL sessions table
10. Return both tokens to client
11. Client stores access token in memory
12. Client stores refresh token in httpOnly cookie
```

### 2. Authorization
```javascript
// Middleware stack
app.use(rateLimiter);      // 100 requests/minute per IP
app.use(authenticate);     // Verify JWT
app.use(authorize);        // Check permissions
app.use(validateRequest);  // Validate request body
```

### 3. Security Headers
```javascript
helmet({
  contentSecurityPolicy: true,
  crossOriginEmbedderPolicy: true,
  crossOriginOpenerPolicy: true,
  crossOriginResourcePolicy: true,
  dnsPrefetchControl: true,
  frameguard: true,
  hidePoweredBy: true,
  hsts: true,
  ieNoOpen: true,
  noSniff: true,
  originAgentCluster: true,
  permittedCrossDomainPolicies: true,
  referrerPolicy: true,
  xssFilter: true
})
```

### 4. Rate Limiting Strategy
```
Global: 1000 requests / hour / IP
Auth:   10 OTP requests / hour / phone
        5 failed login attempts / hour / phone
API:    100 requests / minute / user
SOS:    5 SOS alerts / day / user
```

---

## 📡 Real-Time Architecture (WebSockets)

### Socket.io Events

#### Client → Server Events
```javascript
// Connect
socket.emit('authenticate', { token: 'jwt_token' });

// Subscribe to nearby SOS alerts
socket.emit('subscribe:sos', {
  location: { lat: 12.9716, lng: 77.5946 },
  radius_km: 25,
  blood_type: 'A+'
});

// Subscribe to blood bank updates
socket.emit('subscribe:blood-bank', {
  blood_bank_id: 'uuid'
});
```

#### Server → Client Events
```javascript
// New SOS alert nearby
socket.on('sos:new', (data) => {
  // { sos_alert: {...}, distance_km: 5.2 }
});

// Blood availability updated
socket.on('blood-bank:inventory-updated', (data) => {
  // { blood_bank_id: 'uuid', inventory: {...} }
});

// Donor response to your SOS
socket.on('sos:response', (data) => {
  // { donor: {...}, message: '...' }
});
```

---

## 🏗️ IMPLEMENTATION PHASES

---

## **PHASE 1: Backend Foundation** (Week 1-2)

### Goals
- Set up production-grade Node.js/TypeScript backend
- PostgreSQL database with migrations
- Basic authentication system
- Core API structure

### Deliverables
1. **Project Setup**
   - Node.js + Express + TypeScript
   - ESLint + Prettier configuration
   - Environment configuration (.env)
   - Package.json with all dependencies

2. **Database Setup**
   - PostgreSQL installation and configuration
   - Database migration system (node-pg-migrate)
   - All 12 tables created with indexes
   - Seed data for development

3. **Authentication System**
   - OTP generation and verification
   - JWT token generation
   - Refresh token rotation
   - Session management

4. **Core API Structure**
   - Express app with middleware stack
   - Error handling middleware
   - Request validation (Joi/Zod)
   - Response formatting
   - Logging setup (Winston)

5. **Testing Setup**
   - Jest configuration
   - Supertest for API testing
   - Test database setup

### Technical Stack
```json
{
  "dependencies": {
    "express": "^4.18.2",
    "typescript": "^5.3.3",
    "@types/express": "^4.17.21",
    "pg": "^8.11.3",
    "node-pg-migrate": "^6.2.2",
    "jsonwebtoken": "^9.0.2",
    "bcrypt": "^5.1.1",
    "joi": "^17.11.0",
    "winston": "^3.11.0",
    "helmet": "^7.1.0",
    "cors": "^2.8.5",
    "express-rate-limit": "^7.1.5",
    "dotenv": "^16.3.1"
  },
  "devDependencies": {
    "jest": "^29.7.0",
    "supertest": "^6.3.3",
    "ts-jest": "^29.1.1",
    "nodemon": "^3.0.2",
    "eslint": "^8.56.0",
    "prettier": "^3.1.1"
  }
}
```

### File Structure
```
backend/
├── src/
│   ├── config/
│   │   ├── database.ts
│   │   ├── auth.ts
│   │   └── env.ts
│   ├── middleware/
│   │   ├── authenticate.ts
│   │   ├── authorize.ts
│   │   ├── errorHandler.ts
│   │   ├── rateLimiter.ts
│   │   └── validator.ts
│   ├── routes/
│   │   ├── auth.routes.ts
│   │   ├── users.routes.ts
│   │   ├── bloodBanks.routes.ts
│   │   └── index.ts
│   ├── controllers/
│   │   ├── auth.controller.ts
│   │   ├── users.controller.ts
│   │   └── bloodBanks.controller.ts
│   ├── services/
│   │   ├── auth.service.ts
│   │   ├── otp.service.ts
│   │   ├── token.service.ts
│   │   └── user.service.ts
│   ├── models/
│   │   ├── User.ts
│   │   ├── BloodBank.ts
│   │   └── Session.ts
│   ├── utils/
│   │   ├── logger.ts
│   │   ├── errors.ts
│   │   └── validators.ts
│   ├── types/
│   │   ├── express.d.ts
│   │   └── models.ts
│   └── app.ts
├── migrations/
│   ├── 001_create_users_table.sql
│   ├── 002_create_blood_banks_table.sql
│   └── ...
├── tests/
│   ├── integration/
│   └── unit/
├── package.json
├── tsconfig.json
└── .env.example
```

---

## **PHASE 2: Core API Endpoints** (Week 3-4)

### Goals
- Implement all user endpoints
- Implement blood bank search and details
- Add geospatial queries
- Redis caching layer

### Deliverables
1. **User Management**
   - GET /users/me
   - PUT /users/me
   - POST /users/location
   - Profile photo upload to S3

2. **Blood Bank API**
   - GET /blood-banks (with geospatial search)
   - GET /blood-banks/:id
   - POST /blood-banks/:id/verify
   - POST /blood-banks/:id/review
   - Inventory management endpoints

3. **Redis Integration**
   - Cache blood bank search results
   - Cache user sessions
   - Rate limiting with Redis
   - OTP storage

4. **Search Optimization**
   - PostgreSQL GIST indexes
   - Haversine distance calculation
   - Elasticsearch integration for full-text search

### Redis Schema
```
Key Pattern: bloodnearme:cache:bloodbanks:{lat}:{lng}:{radius}:{bloodtype}
TTL: 300 seconds (5 minutes)

Key Pattern: bloodnearme:session:{user_id}
TTL: 86400 seconds (24 hours)

Key Pattern: bloodnearme:otp:{phone}
TTL: 300 seconds (5 minutes)

Key Pattern: bloodnearme:ratelimit:{ip}:{endpoint}
TTL: 60 seconds
```

---

## **PHASE 3: SOS System & Real-Time** (Week 5-6)

### Goals
- Implement SOS alert system
- WebSocket real-time updates
- Push notification infrastructure
- SMS/Email notifications

### Deliverables
1. **SOS Alert System**
   - POST /sos-alerts (create)
   - GET /sos-alerts (search nearby)
   - POST /sos-alerts/:id/respond
   - PUT /sos-alerts/:id/status

2. **WebSocket Server**
   - Socket.io integration
   - Room-based subscriptions
   - Real-time SOS broadcasts
   - Real-time inventory updates

3. **Notification System**
   - Firebase Cloud Messaging (push)
   - Twilio SMS integration
   - SendGrid email integration
   - Notification preferences

4. **Background Jobs**
   - Bull queue system
   - SOS expiry checker
   - Notification dispatcher
   - Database cleanup jobs

### WebSocket Architecture
```javascript
// Server-side rooms
`sos:city:bangalore`
`sos:bloodtype:A+`
`sos:location:12.97:77.59:25km`
`bloodbank:${bloodBankId}`

// Client subscribes to multiple rooms based on preferences
socket.join('sos:city:bangalore');
socket.join('sos:bloodtype:A+');
socket.join('bloodbank:uuid-123');
```

---

## **PHASE 4: Donor Management & Gamification** (Week 7-8)

### Goals
- Donor registration and profiles
- Donation tracking
- Gamification system
- Leaderboards

### Deliverables
1. **Donor System**
   - POST /donors/register
   - GET /donors/me
   - PUT /donors/preferences
   - POST /donors/record-donation

2. **Gamification**
   - Points calculation engine
   - Badge system (bronze → platinum)
   - Donation milestones
   - GET /donors/leaderboard

3. **Donation Verification**
   - Certificate upload
   - Photo verification
   - Admin approval workflow

4. **Analytics**
   - Donation statistics
   - Impact metrics
   - Personal donation history

---

## **PHASE 5: Admin Panel Backend** (Week 9-10)

### Goals
- Admin authentication
- Blood bank management
- User moderation
- Analytics dashboard data

### Deliverables
1. **Admin Auth**
   - Admin role system
   - Permission-based access
   - Audit logging

2. **Blood Bank Admin**
   - POST /admin/blood-banks (create)
   - PUT /admin/blood-banks/:id (update)
   - PUT /admin/blood-banks/:id/inventory (bulk update)
   - DELETE /admin/blood-banks/:id (soft delete)

3. **User Moderation**
   - GET /admin/users (search, filter)
   - PUT /admin/users/:id/verify
   - PUT /admin/users/:id/ban

4. **Analytics API**
   - GET /admin/analytics/overview
   - GET /admin/analytics/donations
   - GET /admin/analytics/sos-alerts
   - GET /admin/analytics/users

---

## **PHASE 6: Frontend Integration** (Week 11-12)

### Goals
- Connect frontend to real backend
- Replace Google Sheets with API calls
- Implement authentication flow
- Real-time updates

### Deliverables
1. **API Client**
   - Replace js/api/google-sheets.js with backend API client
   - HTTP client with interceptors
   - Token refresh logic
   - Error handling

2. **Authentication UI**
   - OTP login flow
   - Token management
   - Auto-logout on expiry

3. **Real-Time Integration**
   - Socket.io client
   - Live SOS updates
   - Live inventory updates

4. **Search View**
   - Connect to GET /blood-banks
   - Real-time filtering
   - Google Maps integration

---

## **PHASE 7: DevOps & Deployment** (Week 13-14)

### Goals
- Docker containerization
- CI/CD pipeline
- Production deployment
- Monitoring setup

### Deliverables
1. **Docker**
   - Dockerfile for backend
   - Dockerfile for frontend
   - docker-compose.yml
   - Multi-stage builds

2. **CI/CD**
   - GitHub Actions workflow
   - Automated testing
   - Automated deployment
   - Environment variables management

3. **Deployment**
   - AWS/GCP setup
   - Load balancer configuration
   - SSL certificates
   - Domain setup

4. **Monitoring**
   - Sentry error tracking
   - Prometheus metrics
   - Grafana dashboards
   - CloudWatch logs

### Docker Compose
```yaml
version: '3.8'
services:
  postgres:
    image: postgis/postgis:15-3.3
    environment:
      POSTGRES_DB: bloodnearme
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

  backend:
    build: ./backend
    environment:
      DATABASE_URL: ${DATABASE_URL}
      REDIS_URL: ${REDIS_URL}
      JWT_SECRET: ${JWT_SECRET}
    ports:
      - "3000:3000"
    depends_on:
      - postgres
      - redis

  frontend:
    build: ./frontend
    ports:
      - "80:80"
    depends_on:
      - backend

  nginx:
    image: nginx:alpine
    ports:
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
```

---

## **PHASE 8: Advanced Features** (Week 15-16)

### Goals
- Advanced search (Elasticsearch)
- SMS notifications
- Payment integration (donations)
- Multi-language support

### Deliverables
1. **Elasticsearch**
   - Full-text search
   - Autocomplete
   - Fuzzy matching

2. **Twilio Integration**
   - SMS OTP
   - SOS SMS alerts
   - Donation reminders

3. **Payment Gateway**
   - Razorpay/Stripe integration
   - Donation to blood banks
   - Transaction history

4. **Internationalization**
   - Multi-language API responses
   - Hindi, Tamil, Telugu support

---

## 📊 Performance Targets

### Response Times
- API endpoints: < 200ms (p95)
- Database queries: < 50ms (p95)
- Search queries: < 100ms (p95)
- WebSocket latency: < 50ms

### Scalability
- 100,000 concurrent users
- 10,000 requests/second
- 1 million blood banks
- 10 million users

### Availability
- 99.9% uptime (43.2 minutes downtime/month)
- Multi-region deployment
- Auto-scaling
- Circuit breakers

---

## 🔍 Monitoring & Observability

### Metrics to Track
```
Application Metrics:
- API request rate
- API error rate
- API latency (p50, p95, p99)
- Active WebSocket connections
- Background job queue length

Business Metrics:
- SOS alerts created/day
- SOS response rate
- Donations recorded/day
- New user signups/day
- Blood bank verifications/day

Infrastructure Metrics:
- CPU usage
- Memory usage
- Database connections
- Redis memory
- Disk I/O
```

### Alerting Rules
```
Critical:
- API error rate > 5%
- Database connection pool exhausted
- Redis unavailable
- Disk usage > 90%

Warning:
- API latency p95 > 500ms
- Active connections > 80% of limit
- Memory usage > 80%
```

---

## 🧪 Testing Strategy

### Unit Tests
- All service functions
- All utility functions
- 80%+ code coverage

### Integration Tests
- All API endpoints
- Database operations
- External service mocks

### Load Tests
- 10,000 concurrent users
- Peak traffic simulation
- Stress testing

### Security Tests
- SQL injection
- XSS attacks
- CSRF protection
- Rate limiting bypass

---

## 📝 Documentation Requirements

1. **API Documentation** (OpenAPI/Swagger)
2. **Database Schema Documentation**
3. **Deployment Guide**
4. **Developer Onboarding Guide**
5. **Architecture Decision Records (ADRs)**

---

## 🎯 Success Criteria

### Technical
- ✅ All API endpoints functional
- ✅ Sub-200ms API response time
- ✅ 99.9% uptime
- ✅ Zero critical security vulnerabilities
- ✅ 80%+ test coverage

### Business
- ✅ 10,000+ registered users in 3 months
- ✅ 100+ blood banks verified
- ✅ 1,000+ SOS alerts created
- ✅ 500+ donations recorded

---

**This architecture is designed by a Principal Engineer for production at scale.**
**Every decision is intentional. Every component is necessary. Zero bloat.**
