import { db } from '@/lib/db'
import { NextResponse } from 'next/server'

// Default categories - these will be created on every cold start
// if they don't already exist. This ensures the app always has
// categories available, even on Vercel where SQLite is ephemeral.
const DEFAULT_CATEGORIES = [
  { nameBadini: 'ئایینی', nameSorani: 'ئایینی' },
  { nameBadini: 'زانستی', nameSorani: 'زانستی' },
  { nameBadini: 'مێژوویی', nameSorani: 'مێژوویی' },
  { nameBadini: 'جوگرافی', nameSorani: 'جوگرافی' },
  { nameBadini: 'وەرزشی', nameSorani: 'وەرزشی' },
  { nameBadini: 'گشتی', nameSorani: 'گشتی' },
]

export async function POST() {
  try {
    const existingCount = await db.category.count()

    if (existingCount === 0) {
      // No categories exist - seed the default ones
      await db.category.createMany({
        data: DEFAULT_CATEGORIES,
      })

      return NextResponse.json(
        { message: '6 default categories created successfully. Add questions via admin panel.', created: 6 },
        { status: 201 }
      )
    }

    return NextResponse.json(
      { message: 'Categories already exist', count: existingCount },
      { status: 200 }
    )
  } catch (error) {
    console.error('Seed error:', error)
    return NextResponse.json({ error: 'Failed to seed data', details: String(error) }, { status: 500 })
  }
}

// GET endpoint to check seed status
export async function GET() {
  try {
    const categoryCount = await db.category.count()
    const questionCount = await db.question.count()
    const participantCount = await db.participant.count()

    return NextResponse.json({
      categories: categoryCount,
      questions: questionCount,
      participants: participantCount,
      needsSeed: categoryCount === 0,
    })
  } catch (error) {
    console.error('Seed status error:', error)
    return NextResponse.json({ error: 'Failed to check seed status', details: String(error) }, { status: 500 })
  }
}
