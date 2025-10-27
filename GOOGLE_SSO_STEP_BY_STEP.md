# Google Workspace SSO - Step by Step

## Setup Process

### Part 1: Configure in Google Workspace Admin Console

1. **Go to Google Admin Console**:
   - URL: https://admin.google.com
   - Sign in as admin

2. **Navigate to Security Settings**:
   - Go to: Security → Authentication → SSO with third party IdP
   - Or: Apps → Web and mobile apps → Add a custom SAML app

3. **Set Up SAML Application**:
   
   **Step 1: Basic SAML Configuration**
   - Application name: `StartNoo CRM` or `University CRM`
   - Description: `University CRM Single Sign-On`
   
   **Step 2: Configure SAML URLs** (for local testing):
   - **ACS URL** (Consumer URL): `http://localhost:3000/auth/saml/login/[UUID]`
     - Note: You'll get the [UUID] after creating the SSO provider in Twenty
   - **Entity ID**: `http://localhost:3000`
   - **Name ID format**: Email
   - **Name ID**: Basic Information → Primary email
   
   **Step 3: Configure Attribute Mapping**:
   - Add attribute: `email` → `http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress`
   - Add attribute: `firstName` → `http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname`
   - Add attribute: `lastName` → `http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname`

4. **Download Metadata**:
   - Google will provide:
     - **SSO URL**: SAML endpoint
     - **Certificate**: x.509 certificate
     - **Entity ID**: Your Google workspace entity ID

### Part 2: Configure in Twenty (Your App)

1. **Start Your App Locally**:
   ```bash
   cd ~/webdev/university-crm
   yarn start
   ```

2. **Log In to Your Workspace**:
   - Go to: http://localhost:3004
   - Log in with your credentials

3. **Navigate to SSO Settings**:
   - Go to: Settings → Security → SSO
   - You should see: "Add SSO Identity Provider" (now enabled!)

4. **Click "Add SSO Identity Provider"**

5. **Configure SAML Provider**:
   
   Fill in the form with Google's information:
   
   - **Name**: `Google Workspace`
   - **Issuer**: The Entity ID from Google (e.g., `https://accounts.google.com/o/saml2?idpid=XXXXXXXX`)
   - **SSO URL**: The SAML endpoint URL from Google
   - **Certificate**: The x.509 certificate from Google (paste the full certificate including BEGIN/END markers)

6. **Copy Your Provider ID**:
   - After creating, you'll see a provider with an ID
   - Copy this ID

7. **Update Google Admin Console**:
   - Go back to Google Admin Console
   - Update the ACS URL to: `http://localhost:3000/auth/saml/login/[YOUR-PROVIDER-ID]`
   - Save

### Part 3: Test SSO Login

1. **Log Out of Your Current Session**

2. **Try SSO Login**:
   - Go to http://localhost:3004/sign-in-up
   - You should see your SSO provider
   - Click to login via Google

3. **Authenticate with Google**:
   - Redirects to Google
   - Sign in with Google Workspace account
   - Redirects back to StartNoo CRM
   - You're logged in!

## For Production (AWS - Later)

When ready to deploy to AWS:

1. **Update Google Admin Console**:
   - Change ACS URL to: `http://52.10.46.91:3000/auth/saml/login/[PROVIDER-ID]`
   - Or better: `https://crm.yourdomain.com/auth/saml/login/[PROVIDER-ID]`

2. **Deploy Your Customized Version**:
   - Currently AWS runs official Twenty image
   - Need to deploy your fork with SSO changes

## What Each Field Means

- **ACS URL (Assertion Consumer Service URL)**: Where Google sends the SAML response after authentication
- **Entity ID**: Unique identifier for the SAML application
- **SSO URL**: Where to redirect users for authentication
- **Certificate**: Used to verify SAML responses from Google
- **Issuer**: Google's identifier for your SAML setup

## Common Issues

### "Invalid SAML response"
- Check certificate is correct (copy full certificate including BEGIN/END)
- Verify ACS URL matches exactly
- Check Entity ID is correct

### "Email not found"
- Make sure attribute mapping includes email
- Check Google sends email in response

### SSO provider not appearing
- Hard refresh browser (Cmd+Shift+R)
- Clear browser cache
- Restart the app locally

## Quick Reference URLs

**Local Development**:
- App: http://localhost:3004
- SSO endpoint: http://localhost:3000/auth/saml/login/[ID]

**Production (Future)**:
- App: http://52.10.46.91:3000
- SSO endpoint: http://52.10.46.91:3000/auth/saml/login/[ID]

## Testing Checklist

- [ ] Google Workspace SSO configured
- [ ] Provider created in Twenty
- [ ] ACS URL updated in Google
- [ ] Can log in via SSO locally
- [ ] Email address from Google works
- [ ] User is created in workspace
- [ ] Can access all features after SSO login

