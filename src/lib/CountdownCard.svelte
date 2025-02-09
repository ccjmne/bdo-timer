<script lang="ts">
  // TODO: Look into offline version
  import Icon from '@iconify/svelte'
  import TimeInput from './TimeInput.svelte'

  let {
    time = $bindable([0, 1200]),
    dir = $bindable(true),
    beeping = $bindable(true),
    running,
  }: {
    time: [current: number, goal: number]
    dir: boolean
    beeping: boolean
    running: boolean
  } = $props()
</script>

<div
  class="grid place-items-center join grid-cols-[auto_1fr] grid-rows-[1fr_1fr] bg-base-100 rounded-sm w-full"
>
  <button class="btn btn-md h-full join-item" onclick={() => (dir = !dir)}>
    <label class="swap swap-rotate {dir ? 'swap-active' : ''}">
      <Icon class="swap-on" icon="ic:baseline-keyboard-double-arrow-up" />
      <Icon class="swap-off" icon="ic:baseline-keyboard-double-arrow-down" />
    </label>
  </button>
  <div
    class="p-2 relative row-span-2 rounded-e-sm border-[#8882] border-t-1 border-r-0 w-full shadow-sm"
  >
    <div
      class="flex justify-evenly absolute inset-0 pointer-events-none overflow-hidden max-sm:[&>:nth-child(-n+12)]:hidden"
    >
      {#each Array(24)}
        <div
          class="w-[1px] before:absolute before:w-[1px] bg-[#8882] line
                {dir ? 'line-reverse' : ''} {running ? 'before:opacity-100' : 'before:opacity-0'}"
          style="--delay: {Math.random() * 2}s;"
        ></div>
      {/each}
    </div>
    <div class="flex justify-evenly items-center w-full max-sm:flex-col">
      {#if dir}
        <TimeInput
          label="Elapsed"
          bind:value={() => time[0], v => ((time[1] = Math.max(time[1], v)), (time[0] = v))}
        />
      {:else}
        <TimeInput
          label="Remaining"
          bind:value={() => time[1] - time[0],
          v => ((time[1] = Math.max(time[1], v)), (time[0] = time[1] - v))}
        />
      {/if}
      <div class="divider sm:divider-horizontal text-xs m-0 muted">of</div>
      {#if dir}
        <TimeInput
          bind:value={() => time[1], v => ((time[1] = v), (time[0] = Math.min(v, time[0])))}
        />
      {:else}
        <TimeInput
          bind:value={() => time[1],
          v => ((time[0] = Math.max(0, time[0] + v - time[1])), (time[1] = v))}
        />
      {/if}
    </div>
  </div>
  <button class="btn btn-md rounded-bl-sm h-full join-item" onclick={() => (beeping = !beeping)}>
    <label class="swap {beeping ? 'swap-active' : ''}">
      <Icon class="swap-on" icon="mdi:music-note" />
      <Icon class="swap-off" icon="mdi:music-note-off" />
    </label>
  </button>
</div>

<style>
  .line {
    &::before {
      transition: opacity 0.5s;
      background: linear-gradient(to bottom, #8880 0%, #888a 100%);
      animation: drop 2s var(--delay) infinite cubic-bezier(0.25, 0.46, 0.45, 0.94);
    }

    &.line-reverse::before {
      background: linear-gradient(to top, #8880 0%, #888a 100%);
      animation-direction: reverse;
    }
  }

  @keyframes drop {
    from {
      bottom: 100%;
      height: 50%;
    }
    to {
      bottom: -5%;
      height: 5%;
    }
  }
</style>
