<script lang="ts">
  import Play from '~icons/mdi/play'
  import Pause from '~icons/mdi/pause'
  import Forward from '~icons/mdi/step-forward'
  import Backward from '~icons/mdi/step-backward'

  let {
    time = $bindable([0, 1200]),
    loop = $bindable([1, Infinity]),
    running = $bindable(false),
    beeping,
  }: {
    time: [current: number, goal: number]
    loop: [current: number, goal: number]
    running: boolean
    beeping: boolean
  } = $props()

  let beep: HTMLAudioElement
  let runnable = $derived(time[1] > 0)
  let action = $derived.by(() => {
    if (running) return 'Pause'
    if (time[0] === 0 && loop[0] === 1) return 'Start'
    if (time[0] === time[1] && loop[0] === loop[1]) return 'Restart'
    return 'Resume'
  })

  function nexttick() {
    if (!runnable) return
    if (time[0] < time[1]) return (time[0] += 1)
    if (beeping) beep.play()
    if (loop[0] < loop[1]) nextloop()
    else running = false
  }

  function nextloop() {
    time[0] = 0
    loop[0] = loop[0] === loop[1] ? 1 : loop[0] + 1
  }

  function click() {
    if (time[0] === time[1]) nextloop()
    running = !running
  }

  $effect(() => {
    let ival = running && setInterval(nexttick, 1000)
    return () => clearInterval(ival as number)
  })
</script>

<button type="button" class="btn grow" disabled={!runnable} onclick={click}>
  {#if action === 'Start'}
    <Play />
  {:else if action === 'Resume'}
    <Forward />
  {:else if action === 'Pause'}
    <Pause />
  {:else if action === 'Restart'}
    <Backward />
  {/if}
  {action}
</button>
<audio bind:this={beep} src="./beep.ogg"></audio>
