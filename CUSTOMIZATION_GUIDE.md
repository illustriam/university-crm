# Customization Guide for StartNoo CRM

## Your Control & Freedom

You have **complete control** because:
- ✅ You have your own fork at `github.com/illustriam/university-crm`
- ✅ You can customize anything (SSO, branding, features, etc.)
- ✅ Twenty cannot force updates on you
- ✅ You choose when to merge upstream updates (or not)

## Deployment Workflow

### Current Setup
- **AWS EC2**: Running official Twenty image (no customizations yet)
- **Local**: Your customized "StartNoo" version
- **GitHub**: Your fork with customizations

### Deploying Custom Changes

#### Option 1: Build & Deploy to AWS
```bash
# From your local machine
./build-and-deploy-crm.sh
```

This will:
1. Build your customized version locally
2. Upload to AWS EC2
3. Run it with Docker Compose

#### Option 2: Git-Based Deployment
```bash
# On AWS EC2
cd ~/university-crm
git pull origin main  # Pull your customizations
docker-compose -f docker-compose.prod.yml restart server
```

## Customizing Features

### Example: Adding Google Workspace SSO

The codebase is open - you can add any feature:

1. **Find the SSO code**:
```bash
cd packages/twenty-server/src
grep -r "SSO\|single.*sign.*on" --include="*.ts"
```

2. **Remove the enterprise restriction**:
   - Find where it checks for enterprise plan
   - Remove or modify the check
   - Rebuild and deploy

3. **Customize login flow**:
   - Add your own Google OAuth integration
   - Tailor it to your needs

### Example: Rebranding

You've already done this:
- Changed "Twenty" → "StartNoo" in `packages/twenty-front/src/modules/ui/navigation/navigation-drawer/constants/DefaultWorkspaceName.ts`

More customizations possible:
- Update logos/images in `packages/twenty-front/public/`
- Change colors in theme files
- Modify text/labels

## Updating Strategy

### When Should You Pull Updates?

**Pull updates when:**
- Twenty adds a feature you want
- There's a critical security patch
- A bug affects you

**Don't pull updates when:**
- Twenty removes features you rely on
- Changes break your customizations
- You're happy with current version

### How to Safely Update

```bash
# 1. Add the original Twenty repo as 'upstream'
git remote add upstream https://github.com/twentyhq/twenty.git

# 2. Fetch updates
git fetch upstream

# 3. Review what changed
git log upstream/main..main

# 4. Merge if you like the changes
git merge upstream/main

# 5. Resolve conflicts (your customizations are yours - keep them)
# 6. Test locally
yarn start

# 7. Deploy to AWS
./build-and-deploy-crm.sh
```

## Your Independence

### Can Twenty Block Features?

**No.** They can't:
- Force you to update
- Remove features from your code
- Block your customizations
- Prevent you from using your fork

**What they CAN do:**
- Lock features in their official version
- Change their pricing for new customers
- These changes don't affect your fork

### Staying Independent

1. **Your GitHub repo is yours** - no one can change it but you
2. **Your AWS deployment is yours** - you control what runs
3. **Your code is yours** - fork is independent

## Recommended Approach

### For Development:
Use your local environment (already working):
```bash
cd ~/webdev/university-crm
yarn start
```

### For Production (AWS):
Currently using official image. For custom changes:

1. **Quick test**: Deploy your build
2. **Verify**: Check it works
3. **Iterate**: Refine customizations

## Next Steps

1. **Start Customizing Locally**:
   - Make your SSO changes
   - Add Google Workspace integration
   - Test with `yarn start`

2. **When Ready to Deploy**:
   - Run the deployment script
   - Your team sees your changes

3. **Update Strategically**:
   - Watch upstream for features you want
   - Merge selectively
   - Keep your independence

## Support

- **Twenty's license**: MIT (very permissive)
- **Your fork**: Fully yours
- **Cloud hosting**: Your AWS account
- **Data**: Your PostgreSQL database

You have complete freedom to customize, deploy, and maintain your own CRM!

