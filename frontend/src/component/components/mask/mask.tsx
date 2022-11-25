import React, { useEffect, useMemo, useRef, useState } from 'react'
import { useLockScroll } from '../../hooks/use-lock-scroll'
import {
  GetContainer,
  renderToContainer,
} from '../../utils/get-render-container'
import { mergeProps } from '../../utils/merge-props'
import { NativeProps, withNativeProps } from '../../utils/native-props'
import { PropagationEvent, withStopPropagation } from '../../utils/with-stop-propagation'

export type MaskProps = {
  visible?: boolean
  onMaskClick?: (event: React.MouseEvent<HTMLDivElement, MouseEvent>) => void
  destroyOnClose?: boolean
  forceRender?: boolean
  disableBodyScroll?: boolean
  color?: 'black' | 'white'
  opacity?: 'default' | 'thin' | 'thick' | number
  getContainer?: GetContainer
  afterShow?: () => void
  afterClose?: () => void
  stopPropagation?: PropagationEvent[]
  children?: React.ReactNode
} & NativeProps<'--z-index'>

enum opacityRecord {
  default = 0.55,
  thin = 0.35,
  thick = 0.75,
}

const classPrefix = `rc-mask`

const defaultProps = {
  visible: true,
  destroyOnClose: false,
  forceRender: false,
  color: 'black',
  opacity: 'default',
  disableBodyScroll: true,
  getContainer: null,
  stopPropagation: ['click'],
}

export const Mask: React.FC<MaskProps> = (p) => {
  const props = mergeProps(defaultProps, p )
  const ref = useRef<HTMLDivElement>(null)
  
  useLockScroll(ref, props.visible && props.disableBodyScroll)

  const background = useMemo(() => {
    const opacity = opacityRecord[props.opacity] ?? props.opacity
    const rgb = props.color === 'white' ? '255, 255, 255' : '0, 0, 0'
    return `rgba(${rgb}, ${opacity})`
  }, [props.color, props.opacity])

  useEffect(() => {
    if(props.visible) {
      props.afterShow?.()
    } else {
      props.afterClose?.()
    }
  }, [props.visible])

  const node =  withStopPropagation(
    props.stopPropagation,
    withNativeProps(
      props,
      <div
      className={classPrefix}
      ref={ref}
      style={{
        background,
        ...props.style,
        display: props.visible ? undefined : 'none',
      }}
      onClick={(e) => {
        if (e.target === e.currentTarget) {
          props.onMaskClick?.(e)
        }
      }}
    >
      {props.onMaskClick && (
        <div
          className={`${classPrefix}-aria-button`}
          role="button"
          // aria-label={locale.Mask.name}
          onClick={props.onMaskClick}
        />
      )}
      <div className={`${classPrefix}-content`}>
        {props.children}
      </div>
    </div>
    ))

  return renderToContainer(props.getContainer, node)
}
