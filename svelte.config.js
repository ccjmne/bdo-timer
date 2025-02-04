import adapter from '@sveltejs/adapter-static'
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte'

/** @type {import('@sveltejs/kit').Config} */
const config = {
        preprocess: vitePreprocess(),
        kit: {
                adapter: adapter({
                        // default options are shown. On some platforms
                        // these options are set automatically — see below
                        pages: 'build',
                        assets: 'build',
                        precompress: true,
                        strict: true,
                        fallback: 'index.html',
                }),
                paths: {
                        base: process.argv.includes('dev') ? '' : process.env.BASE_PATH
                },
        },
}

export default config
