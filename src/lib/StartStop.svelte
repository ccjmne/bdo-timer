<script lang="ts">
  import { onDestroy, onMount } from 'svelte'

  let {
    cur = $bindable(0),
    max = $bindable(1200),
    loop = $bindable(1),
    loops = $bindable(Infinity),
    onrunning = () => {},
  }: {
    cur: number
    max: number
    loop: number
    loops: number
    onrunning: (running: boolean) => void
  } = $props()

  let interval: number | null = $state(null)
  let endSound: HTMLAudioElement

  let runnable = $derived(max > 0)
  let running = $derived(interval !== null)

  let action = $derived.by(() => {
    if (running) return 'Pause'
    if (cur === 0 && loop === 1) return 'Start'
    if (cur === max && loop === loops) return 'Restart'
    return 'Resume'
  })

  $effect(() => {
    if (running && cur >= max) {
      endSound.play()
      pause()
      if (loop < loops) {
        click()
      }
    }
  })

  function resume() {
    clearInterval(interval!)
    interval = setInterval(() => (cur = Math.min(max, cur + 1)), 1000)
    onrunning(running)
  }

  function pause() {
    clearInterval(interval!)
    interval = null
    onrunning(running)
  }

  function click() {
    if (running) {
      return pause()
    }
    if (cur === max) {
      cur = 0
      loop = loop === loops ? 1 : loop + 1
    }
    if (runnable) {
      resume()
    }
  }

  onDestroy(pause)
  onMount(() => {
    endSound = document.querySelector('#endSound')!
  })
</script>

<button type="button" class="btn self-center" disabled={!runnable} onclick={click}>
  {action}
</button>
<audio id="endSound" src="./beep.ogg"></audio>
