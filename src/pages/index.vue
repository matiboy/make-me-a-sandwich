<script setup lang="ts">
import ingredientsListU from '~/assets/database/ingredients.json'
import recipesListU from '~/assets/database/recipes.json'
import type { Ingredient, Recipe, RecipeIngredient } from '~/types/ingredient'

defineOptions({
  name: 'IndexPage',
})

const ingredientsList: Ingredient[] = ingredientsListU
const recipesList: Recipe[] = recipesListU

let ingredientNameSample = $ref('')

function findRecipe(ingredientId: number, returnExists = false) {
  return recipesList[returnExists ? 'find' : 'filter'](
    r => r.ingredients.find(ri => ri.id === ingredientId),
  )
}

const realIngredientsList = ingredientsList.filter(i => !!(findRecipe(i.id, true)))

const ingredientNameSamples: string[] = ingredientsList.reduce((acc, i) => i.object_name.length < 10 ? [...acc, i.object_name] : acc, [])
const ingredientNameSamplesCopy = [...ingredientNameSamples]
function getRandomIngredient() {
  if (!ingredientNameSamplesCopy.length)
    ingredientNameSamplesCopy.push(...ingredientNameSamples)
  const i = Math.floor(Math.random() * ingredientNameSamplesCopy.length)
  writeWords(ingredientNameSamplesCopy.splice(i, 1)[0])
}
setTimeout(getRandomIngredient, 300)
const { pause, resume, isActive } = useIntervalFn(getRandomIngredient, 3e3)

const ingredientNameInput = $ref<HTMLElement | null>(null)
const mySandwich = $ref<SVGElement | null>(null)
const elements = [
  ['darkSide', 'step1Text'],
  ['lightSide', 'step2Text'],
  ['topSide', 'step3Text'],
  ['olivePick', 'step4Text'],
]
onMounted(() => {
  ingredientNameInput?.addEventListener('focus', () => {
    ingredientNameSample = ''
    pause()
  })
  ingredientNameInput?.addEventListener('blur', () => {
    if (!ingredientNameInput.value) {
      ingredientNameSample = ''
      getRandomIngredient()
      resume()
    }
  })
})
watch(() => mySandwich, (s) => {
  // Not sure why, getting null on load if too quick
  setTimeout(() => {
    const doc = s.getSVGDocument()
    for (const i in elements) {
      const [side, textBox] = elements[i]
      doc.getElementById(side).addEventListener('click', () => {
        selectedIngredients.splice(Number.parseInt(i), 1)
      })
      doc.getElementById(textBox).addEventListener('click', () => {
        selectedIngredients.splice(Number.parseInt(i), 1)
      })
    }
  }, 1e3)
})

function writeWords(word: string) {
  ingredientNameSample = ''
  const parts = word.split('')
  const i = setInterval(() => {
    if (parts.length === 0) {
      clearInterval(i)
      return
    }
    ingredientNameSample += parts.shift()
  }, 600 / parts.length)
}

const selectedIngredients = $ref<Ingredient[]>([])
const availableRecipes = $computed(() => {
  if (!selectedIngredients.length)
    return []
  return selectedIngredients.reduce((acc, i) => {
    const thisIngredientRecipes = findRecipe(i.id)
    return acc.filter(r => thisIngredientRecipes.includes(r))
  }, [...recipesList])
})

function selectIngredient(ingredient: Ingredient) {
  if (!ingredient)
    return
  if (selectedIngredients.includes(ingredient))
    return
  selectedIngredients.push(ingredient)
  ingredientName = ''
  availableIngredients = []
  getRandomIngredient()
  resume()
}

let availableIngredients: Ingredient[] = $ref([])
function searchIngredient(evt, isEnter = false) {
  const value = evt.target.value
  if (!value)
    ingredientNameSample = ''

  if (value.length < 2 && !isEnter) {
    availableIngredients = []
    return
  }
  // Exact match
  const ingredients: Ingredient[] = []
  // Start with
  ingredients.push(...realIngredientsList.filter(i => !ingredients.includes(i) && i.object_name.startsWith(value)))
  // Contains
  ingredients.push(...realIngredientsList.filter(i => !ingredients.includes(i) && i.object_name.includes(value)))
  availableIngredients = ingredients.filter(i => !selectedIngredients.includes(i))
  if (isEnter && availableIngredients.length)
    selectIngredient(availableIngredients[0])
}

const { t } = useI18n()
let ingredientName = $ref('')
let oneRecipe = $ref<Recipe | null>(null)

function findIngredientFromRecipeIngredient(ingredient: RecipeIngredient): Ingredient {
  return ingredientsList.find(i => i.id === ingredient.id)!
}

watch(() => selectedIngredients.length + (!!oneRecipe).toString(), (v) => {
  const mySandwichSVG = mySandwich.getSVGDocument()
  const elementsCopy = [...elements]
  if (oneRecipe) {
    for (const i in elements) {
      const [side, textBox] = elements[i]
      mySandwichSVG.getElementById(side).setAttribute('opacity', 1)
      if (oneRecipe.ingredients[i])
        mySandwichSVG.getElementById(textBox).textContent = findIngredientFromRecipeIngredient(oneRecipe.ingredients[i]).object_name
    }
    return
  }
  for (const ingredient of selectedIngredients) {
    if (!elementsCopy.length)
      break
    const [side, textBox] = elementsCopy.shift()
    mySandwichSVG.getElementById(side).setAttribute('opacity', 1)
    mySandwichSVG.getElementById(textBox).textContent = ingredient.object_name
  }
  // The rest, if any should be hidden again
  for (const [side, textBox] of elementsCopy) {
    mySandwichSVG.getElementById(side).setAttribute('opacity', 0)
    mySandwichSVG.getElementById(textBox).textContent = ''
  }
})
function selectRecipe(r: Recipe | null) {
  oneRecipe = r
}
const randomRecipes = $computed(() => {
  if (availableRecipes.length < 9)
    return availableRecipes
  const recipes = [...availableRecipes]
  const randomRecipes: Recipe[] = []
  for (let i = 0; i < 9; i++) {
    const r = recipes.splice(Math.floor(Math.random() * recipes.length), 1)[0]
    randomRecipes.push(r)
  }
  return randomRecipes
})
</script>

<template>
  <div w-full h="lg:500px xl:600px" text-4xl flex="~">
    <div w="1/2" h="full" position="relative">
      <embed ref="mySandwich" src="blank_sandwich.svg" position="absolute" top="0" left="0" right="0" bottom="0" w="full">
      <div text="sm" position="relative" :hidden="!selectedIngredients.length || !!oneRecipe">
        Hint: click on an ingredient to remove it
      </div>
    </div>
    <div p="x-3" w="1/2" h="full" bg="red dark:#5a0909">
      <div v-show="oneRecipe" flex="~ col justify-start items-center" text="white dark:gray-400" p="t-5" h="full">
        <div flex="~ justify-between items-center" w="full">
          <i i-carbon-chevron-left h-8 w-8 cursor-pointer @click="oneRecipe = null" />
          <div text="2xl" m="b-3" font="bold" underline>
            {{ oneRecipe?.object_name }}
          </div>
          <div h-8 w-8>
&nbsp;
          </div>
        </div>
        <div text="lg left" w-full p="4">
          <p my-3>
            Published: {{ oneRecipe?.publish_date }}
          </p>
          <p my-3>
            Watch it <a :href="oneRecipe?.video_url">on
              <img src="/youtube.png" alt="YouTube" ml-3 class="inline h-[30px]">
            </a>
          </p>
          <p v-if="oneRecipe?.bread_type" my-3>
            Bread: {{ oneRecipe?.bread_type }}
          </p>
          <p my-3>
            Ingredients:
            <ul list="disc inside" p="l-3">
              <li v-for="ingredient in oneRecipe?.ingredients" :key="ingredient.id">
                {{ findIngredientFromRecipeIngredient(ingredient).object_name }} <span v-if="ingredient.specific">(specifically {{ ingredient.specific }})</span>
              </li>
            </ul>
          </p>
          <p v-if="oneRecipe?.plus_up_ingredients?.length" my-3>
            Plus up:
            <ul list="disc inside" p="l-3">
              <li v-for="ingredient in oneRecipe?.plus_up_ingredients" :key="ingredient.id">
                {{ findIngredientFromRecipeIngredient(ingredient).object_name }} <span v-if="ingredient.specific">(specifically {{ ingredient.specific }})</span>
              </li>
            </ul>
          </p>
        </div>
      </div>
      <div v-show="!oneRecipe" flex="~ col justify-start items-center" h="full">
        <div h="1/2" w="full" flex="~ col justify-end items-center" gap="3" relative>
          <div text="white dark:gray-400 3xl">
            What ingredient is in your kitchen?
          </div>
          <input
            id="input" ref="ingredientNameInput"
            v-model="ingredientName"
            type="text"
            p="x-4 y-2"
            w="90% md:80% lg:70% xl:60%"
            text="center"
            bg="red-300 dark:red-800"
            border="~ rounded gray-200 dark:gray-700"
            outline="none active:none"
            :placeholder="ingredientNameSample"
            @input="searchIngredient"
            @keyup.enter="searchIngredient($event, true)"
          >
          <p v-show="ingredientName.length > 2 && !availableIngredients.length" absolute bottom="-30px" text="white dark:gray-400 sm">
            No matching ingredient found.
          </p>
        </div>
        <div w="full" text="left" h="1/8" p="t-4">
          <span v-for="ingredient, i in availableIngredients" :key="i" inline cursor="pointer" underline m="r-2" @click="selectIngredient(ingredient)">
            {{ ingredient.object_name }}<span v-if="i < availableIngredients.length - 1">&nbsp;,</span>
          </span>
        </div>
        <div w="full" text="base white" h="37.5%" p="t-4" :hidden="availableRecipes.length > 0 || !selectedIngredients.length" @click="selectedIngredients = []">
          Looks like we can't find a recipe for those ingredients.<br><span cursor-pointer underline>Clear them and try again</span>.
        </div>
        <div w="full" text="base white" h="37.5%" p="t-4" :hidden="!availableRecipes.length">
          <div text="lg">
            You may be looking for:
          </div>
          <div grid="~ cols-3 gap-3" text="white dark:gray-400 center">
            <div v-for="recipe, i in randomRecipes" :key="i" cursor="pointer" underline m="r-1" @click="selectRecipe(recipe)">
              {{ recipe.object_name }}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div text="black dark:gray-400" p="t-2">
    <p>
      <a rel="noreferrer" href="" target="_blank">
        Make me A Sweet Sandwich
      </a>
    </p>
    <p>
      <em text-sm opacity-75>{{ t('intro.desc') }}</em>
    </p>
  </div>
</template>

<route lang="yaml">
meta:
  layout: default
</route>
