<script lang="ts">
  import CountdownCard from '$lib/CountdownCard.svelte'
  import LoopControls from '$lib/LoopControls.svelte'

  let time: [current: number, goal: number] = $state([0, 1200])
  let loop: [current: number, goal: number] = $state([1, Infinity])
  let running = $state(false)
  let dir = $state(true)
  let beeping = $state(true)
</script>

<main class="flex flex-col text-white gap-4">
  <LoopControls bind:time bind:loop bind:running {beeping}></LoopControls>
  <input
    type="range"
    bind:value={time[0]}
    min={0}
    max={time[1]}
    class="range w-full"
    oninput={() => (running = false)}
  />
  <div class="flex flex-col gap-2 sm:flex-row place-items-center w-full justify-between">
    <CountdownCard bind:time bind:dir bind:beeping {running} />
  </div>
</main>
