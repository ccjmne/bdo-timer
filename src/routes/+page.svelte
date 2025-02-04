<script lang="ts">
  import { onMount } from 'svelte';
  import TimeInput from '../lib/TimeInput.svelte';
    import ticks from '$lib/d3-array/ticks';

  let cur = $state(0)
  let max = $state(1200)
  let interval: number | null = $state(null)
  let endSound: HTMLAudioElement;

  function startStop() {
    if (interval) {
      clearInterval(interval);
      interval = null;
    } else {
      if (cur === max) {
        cur = 0;
      }

      interval = setInterval(() => {
        if (cur >= max) {
          clearInterval(interval!);
          interval = null;
          endSound.play();
        } else {
          cur += 1;
        }
      }, 100);
    }
  }

  onMount(() => {
    endSound = document.querySelector('#endSound')!;
  });

  let theticks = $derived(ticks(0, max, 5))
</script>

<main class="flex flex-col items-center justify-center h-screen bg-gray-800 text-white">
  <form on:submit|preventDefault={startStop} class="flex items-center space-x-2">
    <input type="number" bind:value={cur} min="0" max={max} class="input w-20" />
    <span>/</span>
    <input type="number" bind:value={max} min="0" class="input w-20 border-none" />
    <button type="submit" class="btn btn-primary">{interval ? 'Stop' : 'Start'}</button>
  </form>
  <div class="w-full max-w-xs">
    <input type="range" bind:value={cur} min="0" max={max} class="range" />
    <div class="flex justify-between px-2.5 mt-2 text-xs">
{#each theticks as tick, index}
    <span>|</span>
{/each}
    </div>
    <div class="flex justify-between px-2.5 mt-2 text-xs">
{#each theticks as tick, index}
  <span>{tick}</span>
{/each}
    </div>
  </div>
  <TimeInput bind:value={cur}/>
  <TimeInput bind:value={max}/>
</main>
<audio id="endSound" src="./beep.ogg"></audio>
