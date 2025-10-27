# Quick Start: Google SSO Setup

## 🎯 Goal
Enable Google Workspace SSO so your team can login with their work email.

## ⚡ Quick Steps

### 1. In Google Admin Console

Go to: https://admin.google.com → Security → SSO with third party IdP

**Create SAML App**:
- Name: `StartNoo CRM`
- ACS URL: `http://localhost:3000/auth/saml/login/TEMP`
  - Note: Replace TEMP with actual ID after step 2
- Entity ID: `twenty`
- Download the SSO URL and Certificate

### 2. In Your App (StartNoo)

1. Go to: http://localhost:3004
2. Log in
3. Settings → Security → SSO
4. Click "Add SSO Identity Provider"
5. Fill in:
   - Name: `Google Workspace`
   - Issuer: (from Google)
   - SSO URL: (from Google)
   - Certificate: (from Google - full cert)
6. **Copy the Provider ID** that's created
7. Update Google Admin Console with the real Provider ID in ACS URL

### 3. Test

1. Log out
2. Go to sign-in page
3. Click SSO provider
4. Log in with Google
5. Done! ✅

## 📋 What You Need from Google

1. **SSO URL** - SAML endpoint
2. **Certificate** - x.509 cert
3. **Entity ID** - Google's identifier

## 🚀 For Production Later

When deploying to AWS:
- Change ACS URL to: `http://52.10.46.91:3000/auth/saml/login/[ID]`
- Deploy your customized version (has SSO unlocked)

## 💡 Pro Tips

- Test locally first
- Use a dedicated test user initially
- Certificate must include BEGIN and END markers
- ACS URL must match exactly (including protocol, port, path)

