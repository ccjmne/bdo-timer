<script lang="ts">
  import EditableNumber from './EditableNumber.svelte'

  let { value = $bindable(1200) } = $props()

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

<div class="grid grid-cols-3 gap-0.75 text-center">
  <EditableNumber bind:value={() => hours, setHours}>hours</EditableNumber>
  <EditableNumber bind:value={() => minutes, setMinutes}>minutes</EditableNumber>
  <EditableNumber bind:value={() => seconds, setSeconds}>seconds</EditableNumber>
</div>
