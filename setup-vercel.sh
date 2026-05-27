#!/bin/bash
# ============================================
# 7S PSYAR KURD - Vercel Deployment Setup
# ============================================
#
# This script helps you set up the project for
# Vercel deployment with Neon PostgreSQL.
#
# Steps:
# 1. Go to https://neon.tech and create a free account
# 2. Create a new project
# 3. Copy the connection string
# 4. Run this script with your connection string:
#
#    bash setup-vercel.sh "postgresql://user:pass@ep-xxx.neon.tech/db?sslmode=require"
#
# ============================================

set -e

NEON_URL="${1:-}"

if [ -z "$NEON_URL" ]; then
  echo ""
  echo "❌ Please provide your Neon PostgreSQL connection string!"
  echo ""
  echo "Usage: bash setup-vercel.sh \"postgresql://user:pass@ep-xxx.neon.tech/db?sslmode=require\""
  echo ""
  echo "To get your connection string:"
  echo "  1. Go to https://neon.tech"
  echo "  2. Create a free account and project"
  echo "  3. Copy the connection string from the dashboard"
  echo ""
  exit 1
fi

echo ""
echo "🔧 Setting up 7S PSYAR KURD for Vercel deployment..."
echo ""

# Step 1: Switch schema to PostgreSQL
echo "📝 Step 1: Switching Prisma schema to PostgreSQL..."
cp prisma/schema.prisma prisma/schema.sqlite.prisma.bak
cp prisma/schema.postgresql.prisma prisma/schema.prisma
echo "   ✅ Schema switched to PostgreSQL"

# Step 2: Update .env with Neon URL
echo "📝 Step 2: Updating .env with Neon connection string..."
echo "DATABASE_URL=$NEON_URL" > .env
echo "   ✅ .env updated"

# Step 3: Generate Prisma Client
echo "📝 Step 3: Generating Prisma Client..."
npx prisma generate
echo "   ✅ Prisma Client generated"

# Step 4: Push schema to Neon
echo "📝 Step 4: Creating tables in Neon database..."
npx prisma db push
echo "   ✅ Tables created"

# Step 5: Seed categories
echo "📝 Step 5: Seeding 6 categories..."
node -e "
const { PrismaClient } = require('@prisma/client');
const db = new PrismaClient();
async function main() {
  const count = await db.category.count();
  if (count === 0) {
    await db.category.createMany({
      data: [
        { nameBadini: 'ئایینی', nameSorani: 'ئایینی' },
        { nameBadini: 'زانستی', nameSorani: 'زانستی' },
        { nameBadini: 'مێژوویی', nameSorani: 'مێژوویی' },
        { nameBadini: 'جوگرافی', nameSorani: 'جوگرافی' },
        { nameBadini: 'وەرزشی', nameSorانی: 'وەرزشی' },
        { nameBadini: 'گشتی', nameSorani: 'گشتی' },
      ],
    });
    console.log('6 categories created');
  } else {
    console.log('Categories already exist:', count);
  }
  await db.\$disconnect();
}
main();
"
echo "   ✅ Categories seeded"

echo ""
echo "🎉 Setup complete! Now deploy to Vercel:"
echo ""
echo "  1. Add DATABASE_URL to Vercel Environment Variables:"
echo "     $NEON_URL"
echo ""
echo "  2. Deploy:"
echo "     npx vercel --prod"
echo ""
