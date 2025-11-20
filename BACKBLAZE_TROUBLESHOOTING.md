# Backblaze B2 Connection Troubleshooting

## Test Results

### Configuration Tested
```bash
S3_BUCKET=bits-backup
S3_ENDPOINT=https://s3.us-west-004.backblazeb2.com
S3_REGION=us-west-004
S3_ACCESS_KEY=0054f413fc50d980000000002
S3_SECRET_KEY=K005clOQr83kINWjCg9fWQ7GxaVsLY0
```

### Error Encountered
```
An error occurred (InvalidAccessKeyId) when calling the ListObjectsV2 operation: 
The key '0054f413fc50d980000000002' is not valid
```

## Root Cause Analysis

The error "The key is not valid" indicates that the keyID provided (`0054f413fc50d980000000002`) is **not recognized** by Backblaze B2's S3-compatible API.

### Backblaze B2 Key Types

Backblaze B2 has different types of keys:

1. **Master Application Key**
   - Used for account management via B2 Native API
   - Format: Usually starts with `005...`
   - NOT compatible with S3 API

2. **S3-Compatible Application Keys**
   - Required for S3 API access
   - Created specifically with S3 capabilities
   - Format: KeyID format varies, but must be S3-enabled

### Common Issues

1. **Wrong Key Type**: Using a B2 Native API key instead of an S3-compatible key
2. **Incorrect Capabilities**: Key doesn't have S3 capabilities enabled
3. **Wrong Bucket**: Key is restricted to a different bucket
4. **Typo**: KeyID or applicationKey has a typo

## Solution Steps

### Step 1: Verify You Have an S3-Compatible Application Key

1. Log into Backblaze B2: https://secure.backblaze.com/b2_buckets.htm
2. Go to **App Keys** (left sidebar)
3. Look for keys with **"Allow access to Bucket(s) using the S3 API"** checked

### Step 2: Create a New S3-Compatible Application Key (if needed)

1. Click **"Add a New Application Key"**
2. Configure:
   ```
   Name of Key: supabase-storage
   Allow access to Bucket(s): bits-backup
   Type of Access: Read and Write
   ✅ Allow List All Bucket Names
   ✅ Allow access to Bucket(s) using the S3 API ← CRITICAL!
   ```
3. Click **"Create New Key"**
4. **IMPORTANT**: Copy both values immediately:
   - **keyID**: This is your `S3_ACCESS_KEY`
   - **applicationKey**: This is your `S3_SECRET_KEY`

### Step 3: Update Configuration

Update `.env` with the new S3-compatible key:

```bash
S3_BUCKET=bits-backup
S3_ENDPOINT=https://s3.us-west-004.backblazeb2.com
S3_REGION=us-west-004
S3_ACCESS_KEY=<new_s3_keyID_from_step_2>
S3_SECRET_KEY=<new_applicationKey_from_step_2>
S3_FORCE_PATH_STYLE=false
S3_PROTOCOL=https
```

### Step 4: Verify Endpoint Region

Make sure your endpoint matches your bucket's region. Check in Backblaze:

1. Go to **"Browse Files"** for your bucket
2. Look at **"Endpoint"** shown at top
3. Common endpoints:
   - `s3.us-west-000.backblazeb2.com`
   - `s3.us-west-001.backblazeb2.com`
   - `s3.us-west-002.backblazeb2.com`
   - `s3.us-west-004.backblazeb2.com`
   - `s3.us-east-005.backblazeb2.com`

Update `S3_ENDPOINT` and `S3_REGION` to match.

### Step 5: Test Connection

```bash
./scripts/test-s3-connection
```

Expected output:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ S3 CONNECTION TEST PASSED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

All tests passed! S3 storage is ready for deployment.
```

## Quick Checklist

- [ ] Using an **S3-compatible** Application Key (not B2 Native API key)
- [ ] Key has **"Allow access to Bucket(s) using the S3 API"** enabled
- [ ] Key has **Read and Write** permissions
- [ ] Key has access to the correct bucket (`bits-backup`)
- [ ] Endpoint matches bucket region (check in Backblaze dashboard)
- [ ] No typos in keyID or applicationKey

## Current Status

🔴 **Connection Test Failed** - The keyID `0054f413fc50d980000000002` is not recognized by Backblaze's S3 API.

**Next Action Required**: Create a new S3-compatible Application Key following Step 2 above, or verify the existing key has S3 API access enabled.

## Testing Without Deployment

You can test the S3 connection without deploying Supabase:

```bash
# Edit .env with your credentials
vim .env

# Run the test
./scripts/test-s3-connection
```

This validates credentials before spending time on deployment.
