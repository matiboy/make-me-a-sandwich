<template>
  <nav w="full" flex="~ justify-center items-center" h="120px" shadow="~ md gray-200" p="x-2" m="b-2">
    <MassLogo h="90%" shadow="~ orange-700 lg" />
  </nav>
  <main
    mx-auto text="center gray-700 dark:gray-200" w="full lg:1000px xl:1200px" bg="gray-300 dark:gray-600"
  >
    <RouterView />
    <TheFooter />
  </main>
</template>
