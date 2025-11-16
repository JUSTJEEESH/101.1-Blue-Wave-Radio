# Setting Up the Repository on GitHub

If the repository doesn't exist on GitHub yet, follow these steps to create it and push the code.

## Step 1: Create GitHub Repository

### Option A: Via GitHub Website

1. Go to **https://github.com**
2. Log in with your account (**JUSTJEEESH**)
3. Click the **"+"** icon in the top-right → **"New repository"**
4. Configure:
   - **Repository name**: `101.1-Blue-Wave-Radio`
   - **Description**: `iOS app for 101.1 Blue Wave Radio Roatan - Live streaming, music events, and restaurant discovery`
   - **Visibility**:
     - ✅ **Public** (if you want anyone to clone)
     - ⚪ **Private** (if you want to control access)
   - **DO NOT** initialize with README, .gitignore, or license (we already have these)
5. Click **"Create repository"**

### Option B: Via GitHub CLI (if installed)

```bash
gh repo create JUSTJEEESH/101.1-Blue-Wave-Radio --public --source=. --remote=origin --push
```

## Step 2: Push Existing Code to GitHub

After creating the repository on GitHub, you'll see instructions. Here's what to do:

### If You're in the Repository Directory Already

```bash
cd /path/to/101.1-Blue-Wave-Radio

# Verify current remote (should be the local proxy)
git remote -v

# Remove old remote
git remote remove origin

# Add GitHub remote
git remote add origin https://github.com/JUSTJEEESH/101.1-Blue-Wave-Radio.git

# Verify new remote
git remote -v

# Push all branches and commits
git push -u origin --all

# Push all tags (if any)
git push -u origin --tags
```

### Using SSH Instead of HTTPS

If you prefer SSH (requires SSH keys set up on GitHub):

```bash
git remote remove origin
git remote add origin git@github.com:JUSTJEEESH/101.1-Blue-Wave-Radio.git
git push -u origin --all
```

## Step 3: Set Default Branch (Optional)

If you want the app branch to be the default:

1. Go to **https://github.com/JUSTJEEESH/101.1-Blue-Wave-Radio**
2. Click **"Settings"** tab
3. Click **"Branches"** in left sidebar
4. Under "Default branch", click the switch icon
5. Select: `claude/blue-wave-radio-app-01TP6D9mtSdPUt9a3fhj7Ddz`
6. Click **"Update"**
7. Confirm

## Step 4: Verify Upload

1. Go to **https://github.com/JUSTJEEESH/101.1-Blue-Wave-Radio**
2. Switch to branch: `claude/blue-wave-radio-app-01TP6D9mtSdPUt9a3fhj7Ddz`
3. You should see:
   - `BlueWaveRadio/` folder
   - `README.md`
   - `QUICKSTART.md`
   - `.gitignore`
   - All other files

## Step 5: Share the Repository

Now you can share the clone URL with others:

**HTTPS (public/private):**
```
https://github.com/JUSTJEEESH/101.1-Blue-Wave-Radio.git
```

**SSH (if they have keys):**
```
git@github.com:JUSTJEEESH/101.1-Blue-Wave-Radio.git
```

**Clone command:**
```bash
git clone https://github.com/JUSTJEEESH/101.1-Blue-Wave-Radio.git
cd 101.1-Blue-Wave-Radio
git checkout claude/blue-wave-radio-app-01TP6D9mtSdPUt9a3fhj7Ddz
```

## Step 6: Add Repository Description & Topics (Optional)

Make your repository more discoverable:

1. Go to repository page
2. Click **"⚙️ Settings"** icon (top right, near About)
3. Add:
   - **Description**: `iOS app for 101.1 Blue Wave Radio Roatan - Live streaming, music events, restaurant discovery`
   - **Website**: `https://www.bluewaveradio.live`
   - **Topics**: `ios`, `swift`, `swiftui`, `radio`, `streaming`, `roatan`, `honduras`, `music`, `restaurants`
4. Click **"Save changes"**

## Step 7: Add README to Repository Root (Optional)

Your README.md is already in the repository and will display automatically on GitHub.

## Troubleshooting

### Authentication Failed (HTTPS)

GitHub no longer accepts passwords for git operations. You need a **Personal Access Token**:

1. Go to **https://github.com/settings/tokens**
2. Click **"Generate new token"** → **"Classic"**
3. Select scopes:
   - ✅ `repo` (full control of private repositories)
4. Click **"Generate token"**
5. **Copy the token** (you won't see it again!)
6. When pushing, use the token as your password

**Or use SSH instead** (easier for repeated operations):
1. Generate SSH key: `ssh-keygen -t ed25519 -C "your@email.com"`
2. Add to GitHub: https://github.com/settings/keys
3. Use SSH URL instead of HTTPS

### Permission Denied (SSH)

Make sure your SSH key is added to GitHub:
```bash
# Test SSH connection
ssh -T git@github.com

# Should see: "Hi JUSTJEEESH! You've successfully authenticated..."
```

### Repository Already Exists

If you get "repository already exists":
```bash
# Just add it as remote and push
git remote add origin https://github.com/JUSTJEEESH/101.1-Blue-Wave-Radio.git
git push -u origin --all
```

### Push Rejected

If remote has changes you don't have:
```bash
# Pull first, then push
git pull origin claude/blue-wave-radio-app-01TP6D9mtSdPUt9a3fhj7Ddz --rebase
git push -u origin claude/blue-wave-radio-app-01TP6D9mtSdPUt9a3fhj7Ddz
```

## Quick Commands Summary

```bash
# Create repo on GitHub first, then:

# Navigate to project
cd /path/to/101.1-Blue-Wave-Radio

# Set new remote
git remote remove origin
git remote add origin https://github.com/JUSTJEEESH/101.1-Blue-Wave-Radio.git

# Push everything
git push -u origin --all

# Verify online
open https://github.com/JUSTJEEESH/101.1-Blue-Wave-Radio
```

## After Pushing

Once the repository is on GitHub:
1. Others can clone it using the URL
2. See **XCODE_CLONE_GUIDE.md** for cloning in Xcode
3. Share the repository link with your team

## Making Repository Private Later

If you made it public but want to make it private:
1. Go to repository **Settings**
2. Scroll to **"Danger Zone"**
3. Click **"Change repository visibility"**
4. Select **"Make private"**
5. Confirm

---

**Next**: Once pushed to GitHub, follow **XCODE_CLONE_GUIDE.md** to clone and open in Xcode.
