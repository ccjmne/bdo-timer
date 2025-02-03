<script lang="ts">
  import { onMount } from 'svelte';
  import TimeInput from '../lib/TimeInput.svelte';

  let cur = 0;
  let max = 10;
  let interval: number | null = null;
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
</script>

<main>
<form on:submit|preventDefault={startStop}>
<input type="number" bind:value={cur} min="0" max={max} />
/
<input type="number" bind:value={max} min="0" />
<button type="submit">{interval ? 'Stop' : 'Start'}</button>
</form>
<input type="range" bind:value={cur} min="0" max={max} />
<TimeInput bind:value={cur}/>
<TimeInput bind:value={max}/>
</main>
<audio id="endSound" src="./beep.ogg"></audio>

<style lang="scss">
main {
    display: flex;
    place-content: center;
    background: #333;
    color: ghostwhite;
    flex-direction: column;
    align-items: center;
    height: 100vh;
    margin: 0;
}
:root * {
    font-size: 24px;
}

input[type="number"] {
    border: none;
    background: transparent;
    outline: none;
    color: inherit;
    width: 4ch;
}

input[type="range"] {
    width: 90vw;
}
</style>

