
export let supportsPassive = false

if (document !== undefined) {
  try {
    const opts = {}
    Object.defineProperty(opts, 'passive', {
      get() {
        supportsPassive = true
      },
    })
    window.addEventListener('test-passive', null as any, opts)
  } catch (e) {}
}
