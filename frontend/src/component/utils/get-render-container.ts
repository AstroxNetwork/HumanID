
import { createPortal } from 'react-dom'
import { ReactElement, ReactPortal } from 'react'

export function resolveContainer(
  getContainer: HTMLElement | (() => HTMLElement) | undefined | null
) {
  const container =
    typeof getContainer === 'function' ? getContainer() : getContainer
  return container || document.body
}


export type GetContainer = HTMLElement | (() => HTMLElement) | null

export function renderToContainer(
  getContainer: GetContainer,
  node: ReactElement
) {
  if (typeof document !== 'undefined' && getContainer) {
    const container = resolveContainer(getContainer)
    return createPortal(node, container) as ReactPortal
  }
  return node
}
