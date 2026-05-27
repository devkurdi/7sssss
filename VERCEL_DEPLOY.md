# 7S PSYAR KURD - Vercel Deployment Guide

## Step 1: Create Neon Database (Free)

1. Go to https://neon.tech
2. Click "Sign Up" and create a free account
3. Click "Create Project"
4. Name it "7s-psyar-kurd"
5. Select a region close to you
6. Click "Create Project"
7. Copy the connection string (looks like):
   ```
   postgresql://neondb_owner:AbCdEfGh@ep-cool-name-12345.us-east-2.aws.neon.tech/neondb?sslmode=require
   ```

## Step 2: Set Up the Project

1. Extract the project files
2. Open a terminal in the project directory
3. Run:
   ```bash
   npm install
   ```

## Step 3: Configure for PostgreSQL

1. Copy the PostgreSQL schema:
   ```bash
   cp prisma/schema.postgresql.prisma prisma/schema.prisma
   ```

2. Update .env with your Neon connection string:
   ```bash
   echo 'DATABASE_URL=postgresql://neondb_owner:YOUR_PASSWORD@ep-YOUR-ENDPOINT.us-east-2.aws.neon.tech/neondb?sslmode=require' > .env
   ```

3. Generate Prisma Client and create tables:
   ```bash
   npx prisma generate
   npx prisma db push
   ```

4. Seed the 6 categories:
   ```bash
   curl -X POST http://localhost:3000/api/seed
   ```

## Step 4: Deploy to Vercel

1. Push your code to GitHub
2. Go to https://vercel.com
3. Import your GitHub repository
4. Add Environment Variable:
   - Name: `DATABASE_URL`
   - Value: Your Neon connection string
5. Click "Deploy"

## Step 5: Seed Categories on Vercel

After deployment, visit:
```
https://your-app.vercel.app/api/seed
```
Send a POST request (or use the app - it auto-seeds on first visit).

## Admin Panel

- Password: `00998877`
- You can add categories and questions from the admin panel
- Click the ADMIN button in the top-right corner

## Features

- 6 default categories (empty - add questions via admin panel)
- 60 seconds per question
- Professional leaderboard (TOP 100)
- Bilingual: Badini Kurdish + Sorani Kurdish
- Dark theme with animations
