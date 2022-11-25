export function addFuncToComponent<C, P extends Record<string, any>>(
  component: C,
  funcs: P
): C & P {
  const ret = component as any
  for (const key in funcs) {
    if (funcs.hasOwnProperty(key)) {
      ret[key] = funcs[key]
    }
  }
  return ret
}
