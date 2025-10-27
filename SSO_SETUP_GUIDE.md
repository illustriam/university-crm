# Google Workspace SSO Setup Guide

## What You've Already Done

✅ **Removed enterprise restriction** - SSO is now available to all users in your fork

## What You Need from Google Workspace

### 1. SAML Configuration Details

From Google Workspace Admin Console, you need:

1. **SSO URL** - The SAML endpoint URL (format: `https://accounts.google.com/o/saml2?idpid=...`)
2. **Certificate** - The x.509 certificate for SAML
3. **Issuer** - The SAML issuer identifier
4. **Entity ID** - Your application's entity ID (you'll configure this in Twenty)

### 2. How to Get These from Google Workspace

1. **Go to Google Admin Console**: https://admin.google.com
2. **Navigate to**: Security → SSO with third party IdP
3. **Set up SSO**:
   - Click "Set up SSO with third party IdP"
   - Note down these values:
     - SSO URL
     - Entity ID
     - x.509 Certificate
   - Add your application:
     - ACS URL: `http://localhost:3000/auth/saml/login/{identity-provider-id}`
     - Entity ID: `twenty` (or custom)
     - Start URL: `http://localhost:3000/sign-in-up`
     - Signed Response: Check
     - Name ID format: Email
     - Name ID: Basic Information → Primary email

### 3. For Production (AWS)

When deploying to AWS:
- **ACS URL**: `http://52.10.46.91:3000/auth/saml/login/{identity-provider-id}`
- Or use a domain: `https://crm.yourdomain.com/auth/saml/login/{identity-provider-id}`

## Testing Locally

### Step 1: Start the Application

```bash
cd ~/webdev/university-crm
yarn start
```

### Step 2: Log in to Your Workspace

- Go to http://localhost:3000
- Log in with your credentials

### Step 3: Add SSO Identity Provider

1. Navigate to **Settings** → **Security** → **SSO**
2. You'll now see SSO options (previously locked to enterprise)
3. Click "Add SSO Identity Provider"
4. Choose **SAML** or **OIDC**

### Step 4: Configure SAML for Google Workspace

Fill in:
- **Name**: `Google Workspace`
- **Issuer**: `https://accounts.google.com/o/saml2?idpid=YOUR_IDP_ID`
- **SSO URL**: The SAML endpoint URL from Google
- **Certificate**: The x.509 certificate from Google
- **ID**: Auto-generated UUID

### Step 5: Test SSO Login

1. Go to sign-in page
2. You should see your SSO provider
3. Click to test login

## Implementation Requirements

### Frontend Requirements
- ✅ SSO UI already built in
- Need to test the flow

### Backend Requirements
- ✅ SSO service modified (enterprise check removed)
- Need to verify endpoints work

### Google Workspace Requirements
- Admin console access
- SSO setup in Google Workspace
- Certificate and URLs

## Next Steps

### 1. Test Locally First
```bash
yarn start
```

### 2. Get Google Workspace SSO Details
- Access Google Admin Console
- Set up SAML application
- Copy SSO URL, certificate, etc.

### 3. Configure in Twenty
- Go to Settings → Security → SSO
- Add your Google Workspace configuration
- Test the login flow

### 4. Deploy to AWS (When Ready)
```bash
# This will deploy your customized version with SSO enabled
# (we'll create this script next)
```

## Troubleshooting

### SSO Not Appearing in Settings
- Make sure you're logged in to a workspace
- Check Settings → Security → SSO
- Refresh the page

### SAML Login Not Working
- Verify ACS URL matches in Google Admin Console
- Check certificate is valid
- Look at server logs for errors

### Testing on AWS
Currently AWS is running the official Twenty image (not your customized one).

To get your customizations on AWS, you'll need to:
1. Build a custom Docker image, OR
2. Deploy directly to the server and run `yarn start`

## Quick Test Checklist

- [ ] Application starts locally: `yarn start`
- [ ] Can access Settings → Security → SSO
- [ ] SSO provider configuration form appears
- [ ] Can add SAML provider with test data
- [ ] Google Workspace SAML configured
- [ ] Can login via SSO

## Resources

- [Google Workspace SSO Setup](https://support.google.com/a/answer/6087519)
- [SAML Specification](http://saml.xml.org/saml-specifications)
- [Twenty SSO Docs](https://twenty.com/developers)

