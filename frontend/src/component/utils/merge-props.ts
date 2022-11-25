import _ from 'lodash'

export function mergeProps<A, B>(a: A, b: B): B & A
export function mergeProps<A, B>(...items: any[]) {
  let ret = {}
  const itemsReverse = items.reverse()
  for (let i = 0; i < itemsReverse.length; i++) {
    ret = _.defaultsDeep(ret, itemsReverse[i])
  }

  return ret
}
