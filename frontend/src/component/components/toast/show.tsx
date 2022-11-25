import React, {
  createRef,
  forwardRef,
  useEffect,
  useImperativeHandle,
  useState,
} from 'react'
import { Toast, ToastProps } from './toast'
import { render, unmount as reactUnmount } from '../../utils/render'
import { mergeProps } from '../../utils/merge-props'
import { resolveContainer } from '../../utils/get-render-container'
import { clear } from '../modal/clear'


export function unmountNode(container: HTMLDivElement) {
  const unmountResult = reactUnmount(container)
  if (unmountResult && container.parentNode) {
    container.parentNode.removeChild(container)
  }
}

export const containers = [] as HTMLDivElement[]

export type ToastShowProps = Omit<ToastProps, 'visible'>

export let defaultProps = {
  duration: 2000,
  position: 'center',
  maskClickable: true,

}

export function config(
  configOptions: Pick<ToastProps, 'duration' | 'position' | 'maskClickable'>
) {
  defaultProps = mergeProps(defaultProps, configOptions)
}


export type ToastHandler = {
  close: () => void
}

type ToastShowRef = ToastHandler

export function show(p: ToastShowProps | string) {
  const props = mergeProps(
    defaultProps,
    typeof p === 'string' ? { content: p } : p
  )
  let timer = 0
  const { getContainer = () => document.body } = props
  const container = document.createElement('div')
  const bodyContainer = resolveContainer(getContainer)
  bodyContainer.appendChild(container)
  clear()
  containers.push(container)

  const TempToast = forwardRef<ToastShowRef>((_, ref) => {
    const [visible, setVisible] = useState(true)
    useEffect(() => {
      return () => {
        props.afterClose?.()
      }
    }, [])

    useEffect(() => {
      if (props.duration === 0) {
        return
      }
      timer = window.setTimeout(() => {
        setVisible(false)
      }, props.duration)
      return () => {
        window.clearTimeout(timer)
      }
    }, [])

    useImperativeHandle(ref, () => ({
      close: () => setVisible(false),
    }))
    return (
      <Toast
        {...props}
        getContainer={() => container}
        visible={visible}
        afterClose={() => {
          unmountNode(container)
        }}
      />
    )
  })

  const ref = createRef<ToastShowRef>()
  render(<TempToast ref={ref} />, container)
  return {
    close: () => {
      ref.current?.close()
    },
  } as ToastHandler
}


