<template>
  <nav w="full" flex="~ justify-center items-center" h="120px" shadow="~ md gray-200 dark:#130b00" bg="white dark:#231402" p="x-2" m="b-2">
    <a href="/" class="h-90%"><MassLogo class="h-full" shadow="~ orange-700 lg" /></a>
  </nav>
  <main
    mx-auto h="lg:700px xl:820px" text="center gray-700 dark:gray-200" w="full lg:1000px xl:1200px" bg="gray-300 dark:#130b00"
  >
    <RouterView />
    <TheFooter />
  </main>
</template>
