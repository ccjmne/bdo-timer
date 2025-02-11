<script lang="ts">
  import type { Snippet } from 'svelte'
  import EditableNumber from './EditableNumber.svelte'

  let { value = $bindable(1200), children: labels }: { value: number; children: Snippet } = $props()

  let hours = $derived(Math.floor(value / 3600))
  let minutes = $derived(Math.floor((value % 3600) / 60))
  let seconds = $derived(value % 60)

  function setHours(h: number) {
    value = Math.max(0, h * 3600 + minutes * 60 + seconds)
  }
  function setMinutes(m: number) {
    value = Math.max(0, hours * 3600 + m * 60 + seconds)
  }
  function setSeconds(s: number) {
    value = Math.max(0, hours * 3600 + minutes * 60 + s)
  }
</script>

<div class={['grid grid-cols-3 text-center [&>:nth-child(n+4)]:text-xs [&>:nth-child(n+4)]:muted']}>
  <EditableNumber class="min-w-8" bind:value={() => hours, setHours}></EditableNumber>
  <EditableNumber class="min-w-8" bind:value={() => minutes, setMinutes}></EditableNumber>
  <EditableNumber class="min-w-8" bind:value={() => seconds, setSeconds}></EditableNumber>
  {@render labels()}
</div>
