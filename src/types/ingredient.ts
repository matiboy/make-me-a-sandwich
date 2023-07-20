export interface Ingredient {
  id: number
  object_name: string
  category: string
}

export interface RecipeIngredient {
  id: number
  quantity: string
  specific: string
}

export interface Recipe {
  id: number
  object_name: string
  ingredients: RecipeIngredient[]
  plus_up: string
  score: number
  plus_up_score: number
  plus_up_ingredients: RecipeIngredient[]
  publish_date: string
  source: number
  bread_type: string
}
