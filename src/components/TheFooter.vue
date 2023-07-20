<script setup lang="ts">
const { t, locale } = useI18n()
</script>

<template>
  <nav flex="~ col gap-4" justify-center py-6 text="xl gray-600 dark:gray-400">
    <p text="sm" p="x-2 md:x-5">
      <em>Disclaimer</em>: I am not in any way affiliated with <a underline href="https://www.sandwichesofhistory.com/">Sandwiches of History</a>; all content on this site is freely available by watching <a underline href="https://www.youtube.com/@SandwichesofHistory">Barry's videos on YouTube</a>.<br>
      Every sandwich has a direct link (not embedded) to his corresponding YouTube video. If you identify a missing or broken link please report it, thanks.
    </p>
    <div>
      <RouterLink icon-btn to="/" :title="t('button.home')">
        <div i-carbon-at />
      </RouterLink>

      <button icon-btn :title="t('button.toggle_dark')" @click="toggleDark()">
        <div i="carbon-sun dark:carbon-moon" />
      </button>
    </div>
  </nav>
</template>
