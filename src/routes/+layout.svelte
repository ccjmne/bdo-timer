<script>
  import '../app.css'
</script>

<svelte:head>
  <link rel="preload" href="/outfit.woff2" as="font" type="font/woff2" crossorigin="anonymous" />
  <link rel="preload" href="/syne.woff2" as="font" type="font/woff2" crossorigin="anonymous" />
</svelte:head>

<main class="flex w-screen h-screen place-items-center place-content-center bg-[#252d38]">
  <div class="w-[90vw] lg:w-sm">
    <slot />
  </div>
</main>
