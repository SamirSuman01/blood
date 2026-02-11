# eRaktKosh API Integration Guide

## 🩸 What is eRaktKosh?

**eRaktKosh** is India's National Blood Transfusion Council's centralized blood bank management system. It provides:
- Real-time blood availability data
- 3000+ blood banks across India
- Government-verified information

**Website:** https://www.eraktkosh.in/

---

## 🔍 Current Status

Your app currently uses **mock data** from `src/utils/mockData.js`. The API integration template is ready in `src/utils/api.js` but needs:
1. Understanding of actual eRaktKosh API endpoints
2. API authentication (if required)
3. Data transformation logic

---

## 📊 eRaktKosh API Endpoints (as of 2024)

### Important Note:
eRaktKosh doesn't have a public API documented officially. However, they have some endpoints used by their website:

### 1. **Nearby Blood Banks**
```
POST https://www.eraktkosh.in/BLDAHIMS/bloodbank/nearbyBB.cnt
```

**Request Payload:**
```json
{
  "stateCode": "JH",          // Jharkhand
  "districtCode": "352",      // District code
  "bloodGroup": "A+",         // Blood type
  "latitude": 22.8046,        // GPS coordinates
  "longitude": 86.2029
}
```

**Response:** JSON with blood bank details

### 2. **Blood Availability**
```
POST https://www.eraktkosh.in/BLDAHIMS/bloodbank/availability.cnt
```

**Request Payload:**
```json
{
  "bloodBankId": "BB001",
  "date": "2024-01-15"
}
```

---

## 🚧 Challenge: No Official Public API

**Problem:** eRaktKosh doesn't provide an official public API for third-party apps.

**Solutions:**

### Option A: Use Their Website Endpoints (Web Scraping API)
- ⚠️ Not officially supported
- May break if they change their website
- Rate limiting might apply
- Need to reverse-engineer their API calls

### Option B: Request Official API Access
- 📧 Contact: support@eraktkosh.in
- 📞 Call: NBTC office
- 📝 Explain your use case
- Wait for approval (may take weeks/months)

### Option C: Use State Government APIs
Some states have their own blood bank APIs:
- Karnataka: https://www.khpt.org/
- Maharashtra: https://mahabloodbankinfo.org/
- Check your state's health department

### Option D: Build Your Own Database
- Partner with local blood banks
- Manually collect and update data
- Use Google Forms for blood banks to submit updates
- Store in your own database

---

## 🛠️ Implementation Plan

### Step 1: Research eRaktKosh API

**Method 1: Browser DevTools**
1. Visit https://www.eraktkosh.in/
2. Open Chrome DevTools (F12)
3. Go to "Network" tab
4. Search for blood banks on their site
5. Look for API calls starting with `/BLDAHIMS/`
6. Copy the request URL, headers, and payload

**Method 2: Contact Them**
```
Email: support@eraktkosh.in
Subject: API Access for Blood Donation Web App

Body:
Dear eRaktKosh Team,

I am developing an open-source blood donation coordination platform
called "Blood Bridge Toolkit" to help people find blood banks in
emergencies.

I would like to integrate real-time blood availability data from
eRaktKosh. Could you please provide:
1. API documentation
2. API access credentials
3. Rate limits and usage guidelines

This is a non-commercial, open-source project aimed at saving lives.

GitHub: [your repo link]

Thank you,
[Your Name]
```

### Step 2: Update `api.js`

Once you have the actual API details, update `src/utils/api.js`:

```javascript
/**
 * Fetch blood banks from eRaktKosh (Real API)
 */
export async function fetchBloodBanksFromEraktKosh(bloodGroup, state, district, lat, lng) {
  try {
    const response = await fetch('https://www.eraktkosh.in/BLDAHIMS/bloodbank/nearbyBB.cnt', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        // Add any required auth headers
        // 'Authorization': 'Bearer YOUR_API_KEY',
      },
      body: JSON.stringify({
        stateCode: stateCodeMap[state] || 'JH',  // Map state name to code
        districtCode: districtCodeMap[district] || '',
        bloodGroup: bloodGroup,
        latitude: lat,
        longitude: lng,
      }),
    });

    if (!response.ok) {
      throw new Error(`eRaktKosh API error: ${response.status}`);
    }

    const data = await response.json();

    // Transform to your app's format
    return transformEraktKoshData(data);
  } catch (error) {
    console.error('Error fetching from eRaktKosh:', error);
    // Fallback to mock data
    const { getMockBloodBanks } = await import('./mockData');
    return getMockBloodBanks(bloodGroup, district, 50);
  }
}

// State code mapping (you'll need to build this)
const stateCodeMap = {
  'Jharkhand': 'JH',
  'West Bengal': 'WB',
  'Maharashtra': 'MH',
  // ... add all states
};

// District code mapping (you'll need to build this)
const districtCodeMap = {
  'Jamshedpur': '352',
  'Ranchi': '353',
  // ... add all districts
};
```

### Step 3: Handle API Errors Gracefully

```javascript
export async function searchBloodBanks(bloodType, location, radius) {
  try {
    // Try real API
    const realData = await fetchBloodBanksFromEraktKosh(bloodType, 'Jharkhand', location);

    if (realData && realData.length > 0) {
      return realData;
    } else {
      // If API returns empty, use mock data
      console.warn('eRaktKosh returned no results, using mock data');
      const { getMockBloodBanks } = await import('./mockData');
      return getMockBloodBanks(bloodType, location, radius);
    }
  } catch (error) {
    console.error('API error, falling back to mock data:', error);
    const { getMockBloodBanks } = await import('./mockData');
    return getMockBloodBanks(bloodType, location, radius);
  }
}
```

---

## 🔐 Authentication & Rate Limiting

### If API Requires Auth:

```javascript
// In your .env
VITE_ERAKTKOSH_API_KEY="your_api_key_here"

// In api.js
const apiKey = import.meta.env.VITE_ERAKTKOSH_API_KEY;

const response = await fetch(url, {
  headers: {
    'Authorization': `Bearer ${apiKey}`,
    'Content-Type': 'application/json',
  },
  // ...
});
```

### Rate Limiting Protection:

```javascript
// Simple rate limiter
const apiCache = new Map();
const CACHE_DURATION = 5 * 60 * 1000; // 5 minutes

export async function fetchBloodBanksWithCache(bloodGroup, state, district) {
  const cacheKey = `${bloodGroup}-${state}-${district}`;
  const cached = apiCache.get(cacheKey);

  if (cached && Date.now() - cached.timestamp < CACHE_DURATION) {
    console.log('Returning cached data');
    return cached.data;
  }

  const data = await fetchBloodBanksFromEraktKosh(bloodGroup, state, district);
  apiCache.set(cacheKey, { data, timestamp: Date.now() });

  return data;
}
```

---

## 📝 Data Transformation

eRaktKosh data format might look like:

```json
{
  "bloodBanks": [
    {
      "bbId": "JH001",
      "bbName": "MGM Medical College Blood Bank",
      "address": "Dimna Road, Sakchi",
      "city": "Jamshedpur",
      "state": "Jharkhand",
      "pincode": "831001",
      "mobile": "0657-2371042",
      "latitude": "22.7867",
      "longitude": "86.1872",
      "bloodInventory": {
        "aPositive": 12,
        "aNegative": 2,
        "bPositive": 8,
        "bNegative": 1,
        "abPositive": 5,
        "abNegative": 0,
        "oPositive": 15,
        "oNegative": 3
      },
      "lastUpdated": "2024-01-15T10:30:00Z"
    }
  ]
}
```

Transform it to your app's format:

```javascript
function transformEraktKoshData(rawData) {
  if (!rawData || !rawData.bloodBanks) {
    return [];
  }

  return rawData.bloodBanks.map(bank => ({
    id: bank.bbId,
    name: bank.bbName,
    address: bank.address,
    city: bank.city,
    state: bank.state,
    pincode: bank.pincode,
    lat: parseFloat(bank.latitude) || 0,
    lng: parseFloat(bank.longitude) || 0,
    phone: bank.mobile,
    availability: {
      'A+': bank.bloodInventory?.aPositive || 0,
      'A-': bank.bloodInventory?.aNegative || 0,
      'B+': bank.bloodInventory?.bPositive || 0,
      'B-': bank.bloodInventory?.bNegative || 0,
      'AB+': bank.bloodInventory?.abPositive || 0,
      'AB-': bank.bloodInventory?.abNegative || 0,
      'O+': bank.bloodInventory?.oPositive || 0,
      'O-': bank.bloodInventory?.oNegative || 0,
    },
    verified: true, // eRaktKosh data is govt-verified
    lastUpdated: bank.lastUpdated,
    source: 'eRaktKosh',
  }));
}
```

---

## 🧪 Testing the Integration

### Test with Mock Data First:
```bash
# Keep using mock data
npm run dev
```

### Test with Real API:
1. Update `VITE_API_URL` in `.env`
2. Add API key if needed
3. Test with different blood types
4. Test error scenarios (network failure, empty results)
5. Check console for API errors

### Test Checklist:
- [ ] Search works with real API
- [ ] Fallback to mock data works
- [ ] Loading states show correctly
- [ ] Error messages are user-friendly
- [ ] Data is cached to reduce API calls
- [ ] Map shows correct locations
- [ ] Blood availability is accurate

---

## 🚀 Deployment Considerations

### Environment Variables:
```env
# Development (.env.local)
VITE_ERAKTKOSH_API="https://www.eraktkosh.in/BLDAHIMS/bloodbank/nearbyBB.cnt"
VITE_ERAKTKOSH_API_KEY=""  # If required

# Production
# Same, but with real API key
```

### CORS Issues:
If you get CORS errors, you have two options:

**Option A: Backend Proxy**
Create a simple backend that proxies requests:

```javascript
// server.js (Node.js + Express)
app.post('/api/blood-banks', async (req, res) => {
  const response = await fetch('https://www.eraktkosh.in/...', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(req.body),
  });

  const data = await response.json();
  res.json(data);
});
```

**Option B: Ask for CORS Access**
Request eRaktKosh to add your domain to their CORS whitelist.

---

## 📞 Contact Information

**eRaktKosh Support:**
- Website: https://www.eraktkosh.in/
- Email: support@eraktkosh.in
- Phone: Check NBTC website for helpline

**Alternative Data Sources:**
- State Health Departments
- Local Blood Banks (direct partnerships)
- Red Cross India
- Blood bank aggregators

---

## 🎯 Quick Start (When You Have API Access)

1. **Get API credentials** from eRaktKosh
2. **Add to .env:**
   ```env
   VITE_ERAKTKOSH_API_KEY="your_key_here"
   ```
3. **Update `src/utils/api.js`** with real endpoint and auth
4. **Test thoroughly** with different queries
5. **Deploy** with proper error handling

---

## ⚠️ Important Notes

1. **Legal Compliance:** Ensure you comply with eRaktKosh's terms of service
2. **Data Usage:** Only use data for informational purposes
3. **Attribution:** Credit eRaktKosh as data source
4. **Updates:** eRaktKosh data should be real-time, but verify freshness
5. **Disclaimer:** Still need disclaimers even with real data

---

## 🆘 If You Can't Get API Access

**Alternative Approach:**
1. Build relationships with local blood banks
2. Create a simple admin interface for them to update availability
3. Store in your own database (Firebase, MongoDB, etc.)
4. Start small (one city) and expand
5. Eventually approach eRaktKosh with proven track record

This is actually how many successful apps started!

---

**Current Code Status:** ✅ Template ready, just needs real endpoint & auth
**Next Step:** Contact eRaktKosh or use browser DevTools to find actual API
