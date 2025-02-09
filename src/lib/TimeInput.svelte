<script lang="ts">
  import EditableNumber from './EditableNumber.svelte'

  let {
    value = $bindable(1200),
    label,
  }: {
    value: number
    label?: string
  } = $props()

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

<div class="grid grid-cols-3 gap-0-0.75">
  {#if label}
    <EditableNumber class="min-w-[3.5ch]" bind:value={() => hours, setHours}></EditableNumber>
    <EditableNumber class="min-w-[3.5ch]" bind:value={() => minutes, setMinutes}></EditableNumber>
    <EditableNumber class="min-w-[3.5ch]" bind:value={() => seconds, setSeconds}></EditableNumber>
    <span class="text-center muted col-span-3" style="font-size: 16px;">
      {label}
    </span>
  {:else}
    <EditableNumber class="min-w-[3.5ch]" bind:value={() => hours, setHours}>h</EditableNumber>
    <EditableNumber class="min-w-[3.5ch]" bind:value={() => minutes, setMinutes}>m</EditableNumber>
    <EditableNumber class="min-w-[3.5ch]" bind:value={() => seconds, setSeconds}>s</EditableNumber>
  {/if}
</div>
