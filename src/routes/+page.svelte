<script lang="ts">
  import { onDestroy, onMount } from 'svelte'
  import TimeInput from '../lib/TimeInput.svelte'

  let cur = $state(0)
  let max = $state(1200)
  let interval: number | null = $state(null)
  let endSound: HTMLAudioElement

  let running = $derived(interval !== null)
  let action = $derived(running ? 'Pause' : { 0: 'Start', [max]: 'Restart' }[cur] || 'Resume')

  function resume() {
    clearInterval(interval!)
    interval = setInterval(() => {
      if ((cur = Math.min(max, cur + 1)) === max) {
        endSound.play()
        pause()
        if (loop) {
          click()
        }
      }
    }, 1000)
  }

  function pause() {
    clearInterval(interval!)
    interval = null
  }

  function click() {
    if (running) {
      return pause()
    }
    if (cur === max) {
      cur = 0
    }
    resume()
  }

  onDestroy(pause)
  onMount(() => {
    endSound = document.querySelector('#endSound')!
  })

  let loop = $state(false)
</script>

<main class="flex flex-col items-center justify-center h-screen bg-gray-800 text-white gap-4">
  <div style="font-size: .5em">
    <label class="fieldset-label">
      <input type="checkbox" bind:checked={loop} class="toggle toggle-xs" />
      Loop: {loop ? 'on' : 'off'}
    </label>
  </div>
  <input type="range" bind:value={cur} min="0" {max} class="range" />
  <div id="textual">
    <TimeInput bind:value={() => cur, v => ((cur = v), (max = Math.max(max, cur)))} />
    <span class="muted">of</span>
    <TimeInput bind:value={() => max, v => ((max = v), (cur = Math.min(max, cur)))} />
  </div>
  <button type="button" class="btn btn-primary w-50" onclick={click}>{action}</button>
</main>
<audio id="endSound" src="./beep.ogg"></audio>

<style>
  #textual {
    display: flex;
    align-items: center;
    gap: 2em;
  }
</style>
