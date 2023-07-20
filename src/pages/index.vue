<script setup lang="ts">
import ingredientsList from '~/assets/database/ingredients.json'

defineOptions({
  name: 'IndexPage',
})

let ingredientNameSample = $ref('')

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

onMounted(() => {
  ingredientNameInput?.addEventListener('focus', () => {
    ingredientNameSample = ''
    pause()
  })
  ingredientNameInput?.addEventListener('blur', () => {
    getRandomIngredient()
    resume()
  })
})

function writeWords(word) {
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

function searchIngredient(value) {
  if (value.length < 3)
    return
  const ingredient = ingredientsList.find(i => i.object_name === value)
  if (!ingredient)
    return
  router.push({ name: 'ingredient', params: { id: ingredient.id } })
}

const router = useRouter()

const { t } = useI18n()
const ingredientName = $ref('')
</script>

<template>
  <div>
    <div w-full bg="red dark:#5a0909" text-4xl flex="~">
      <div w="1/2">
        <embed src="blank_sandwich.svg" w="full">
      </div>
      <div w="1/2" flex="~ col justify-center items-center" my-auto>
        <div h="1/2" flex="~ col justify-end items-center" gap="3">
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
          >
        </div>
        <div />
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
  </div>
</template>

<style>
.red {
  color: red;
}
</style>

<route lang="yaml">
meta:
  layout: default
</route>
