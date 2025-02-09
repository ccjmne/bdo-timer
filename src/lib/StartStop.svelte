<script lang="ts">
  import { onDestroy, onMount } from 'svelte'
  import Icon from '@iconify/svelte'

  let {
    time = $bindable([0, 1200]),
    loop = $bindable([1, Infinity]),
    running = $bindable(false),
    beep,
  }: {
    time: [current: number, goal: number]
    loop: [current: number, goal: number]
    running: boolean
    beep: boolean
  } = $props()

  let interval: number | null = $state(null)
  let endSound: HTMLAudioElement

  let runnable = $derived(time[1] > 0)

  let action = $derived.by(() => {
    if (running) return 'Pause'
    if (time[0] === 0 && loop[0] === 1) return 'Start'
    if (time[0] === time[1] && loop[0] === loop[1]) return 'Restart'
    return 'Resume'
  })

  $effect(() => {
    if (running && time[0] >= time[1]) {
      if (beep) endSound.play()
      pause()
      if (loop[0] < loop[1]) click()
    }
  })

  function resume() {
    clearInterval(interval!)
    interval = setInterval(() => (time[0] = Math.min(time[1], time[0] + 1)), 1000)
    running = true
  }

  function pause() {
    clearInterval(interval!)
    interval = null
    running = false
  }

  function click() {
    if (running) return pause()
    if (time[0] === time[1]) {
      time[0] = 0
      loop[0] = loop[0] === loop[1] ? 1 : loop[0] + 1
    }
    if (runnable) resume()
  }

  onDestroy(pause)
  onMount(() => {
    endSound = document.querySelector('#endSound')!
  })
</script>

<button type="button" class="btn grow" disabled={!runnable} onclick={click}>
  {#if action === 'Start'}
    <Icon icon="mdi:play" />
  {:else if action === 'Resume'}
    <Icon icon="mdi:step-forward" />
  {:else if action === 'Pause'}
    <Icon icon="mdi:pause" />
  {:else if action === 'Restart'}
    <Icon icon="mdi:step-backward" />
  {/if}
  {action}
</button>
<audio id="endSound" src="./beep.ogg"></audio>
