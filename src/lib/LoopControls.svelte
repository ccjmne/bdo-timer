<script lang="ts">
  import EditableNumber from './EditableNumber.svelte'
  import StartStop from './StartStop.svelte'

  let {
    time = $bindable([0, 1200]),
    loop = $bindable([1, Infinity]),
    onrunning = () => {},
  }: {
    time: [current: number, goal: number]
    loop: [current: number, goal: number]
    onrunning: (running: boolean) => void
  } = $props()

  let last = $derived(loop[0] === loop[1])
</script>

<div class="join">
  <div class="join-item flex flex-col">
    <button
      aria-label={last ? 'Repeat' : 'Do not repeat'}
      class="btn join-item"
      onclick={() => (loop[1] = last ? Infinity : loop[0])}
    >
      <!--
The SVG icons in this file were obtained from https://tabler.io/icons.

                                  MIT License

                       Copyright (c) 2020-2024 Paweł Kuna

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. -->
      <svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24">
        <path
          fill="none"
          stroke="currentColor"
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d={last
            ? 'M4 12V9a3 3 0 0 1 3-3h13m-3-3l3 3l-3 3m3 3v3a3 3 0 0 1-3 3H4m3 3l-3-3l3-3'
            : 'M4 12V9a3 3 0 0 1 2.08-2.856M10 6h10m-3-3l3 3l-3 3m3 3v3a3 3 0 0 1-.133.886m-1.99 1.984A3 3 0 0 1 17 18H4m3 3l-3-3l3-3M3 3l18 18'}
        />
      </svg>
    </button>
  </div>
  <div class="join-item bg-base-100 ps-4 muted relative top-[1px] flex place-items-center">
    Loop
  </div>
  <EditableNumber
    min={1}
    class="bg-base-100 px-2"
    bind:value={() => loop[0], v => ((loop[0] = v), (loop[1] = Math.max(loop[0], loop[1])))}
  ></EditableNumber>
  <div class="join-item bg-base-100 muted relative top-[1px] flex place-items-center">of</div>
  <EditableNumber
    class="bg-base-100 ps-2 pe-4"
    bind:value={() => loop[1], v => ((loop[1] = v), (loop[0] = Math.min(loop[0], loop[1])))}
  ></EditableNumber>
  <StartStop bind:time bind:loop {onrunning} />
  <button
    aria-label="Reset"
    class="btn join-item"
    disabled={loop[0] === 1}
    onclick={() => (loop[0] = 1)}
  >
    <svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24">
      <g
        class="icon-tabler"
        fill="none"
        stroke="currentColor"
        stroke-width="2"
        stroke-linecap="round"
        stroke-linejoin="round"
      >
        <path
          d="M20 18V6a2 2 0 0 0-2.75-1.84L9 10.26a2 2 0 0 0 0 3.5l8.25 6.1A2 2 0 0 0 20 18.11"
        />
        <path d="M4 20V4" />
      </g>
    </svg>
  </button>
</div>
