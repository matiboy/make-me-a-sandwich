<script setup lang="ts">
defineOptions({
  name: 'IndexPage',
})
let ingredientNameSample = $ref('')

const ingredientNameSamples = ['tuna', 'salami', 'cheese', 'ham', 'egg', 'tomato', 'lettuce', 'cucumber', 'onion', 'mayonnaise', 'mustard', 'ketchup', 'peanut butter', 'jam', 'honey', 'chicken', 'bacon', 'turkey', 'beef', 'pork', 'sausage', 'pepperoni', 'salmon', 'tuna', 'anchovy', 'sardine', 'mackerel', 'herring', 'trout', 'cod', 'haddock', 'prawn', 'shrimp', 'lobster', 'crab', 'mushroom', 'avocado', 'olive', 'pepper']
function getRandomIngredient() {
  writeWords(ingredientNameSamples[Math.floor(Math.random() * ingredientNameSamples.length)])
}
setTimeout(getRandomIngredient, 300)
const { pause, resume, isActive } = useIntervalFn(getRandomIngredient, 3e3)

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

const user = useUserStore()
const name = ref(user.savedName)

const router = useRouter()

const { t } = useI18n()
const ingredientName = $ref('')
</script>

<template>
  <div>
    <div w-full bg="red dark:#2e0505" text-4xl flex="~">
      <div w="1/2">
        <embed src="blank_sandwich.svg" w="full">
      </div>
      <div w="1/2" flex="~ col justify-center items-center" my-auto>
        <div h="1/2" flex="~ col justify-end items-center" gap="3">
          <div text="white dark:gray-400 3xl">
            What ingredient is in your kitchen?
          </div>
          <input
            id="input"
            v-model="ingredientName"
            type="text"
            p="x-4 y-2"
            w="90% md:80% lg:70% xl:60%"
            text="center"
            bg="red-300 dark:red-800"
            border="~ rounded gray-200 dark:gray-700"
            outline="none active:none"
            :placeholder="ingredientNameSample"
          >
        </div>
        <div />
      </div>
    </div>
    <div text="black dark:white" p="t-2">
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
