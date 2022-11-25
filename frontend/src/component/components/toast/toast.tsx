import React, { ReactNode, useMemo } from 'react'
import classNames from 'classnames'
import Mask from '../mask'
import type { MaskProps } from '../mask'
import { PropagationEvent } from '../../utils/with-stop-propagation'
import { GetContainer } from '../../utils/get-render-container'
import { mergeProps } from '../../utils/merge-props'

const classPrefix = `rc-toast`

export interface ToastProps {
  afterClose?: () => void
  maskStyle?: MaskProps['style']
  maskClassName?: string
  maskClickable?: boolean
  content?: ReactNode
  icon?: 'success' | 'fail' | 'loading' | React.ReactNode
  duration?: number
  position?: 'top' | 'bottom' | 'center'
  visible?: boolean
  getContainer?: GetContainer
  stopPropagation?: PropagationEvent[]
}

const defaultProps = {
  maskClickable: true,
  stopPropagation: ['click'],
}

export const Toast: React.FC<ToastProps> = p => {
  const props = mergeProps(defaultProps, p)
  const { maskClickable, content, icon, position } = props

  const iconElement = useMemo(() => {
    if (icon === null || icon === undefined) return null
    // switch (icon) {
    //   case 'success':
    //     return <CheckOutline />
    //   case 'fail':
    //     return <CloseOutline />
    //   case 'loading':
    //     return (
    //       <SpinLoading color='white' className={`${classPrefix}-loading`} />
    //     )
    //   default:
    //     return icon
    // }
  }, [icon])

  const top = useMemo(() => {
    switch (position) {
      case 'top':
        return '20%'
      case 'bottom':
        return '80%'
      default:
        return '50%'
    }
  }, [position])
  return (
    <Mask
      visible={props.visible}
      destroyOnClose
      opacity={0}
      disableBodyScroll={!maskClickable}
      getContainer={props.getContainer}
      afterClose={props.afterClose}
      style={{
        pointerEvents: maskClickable ? 'none' : 'auto',
        ...props.maskStyle,
      }}
      className={classNames(`${classPrefix}-mask`, props.maskClassName)}
      stopPropagation={props.stopPropagation}
    >
      <div className={classNames(`${classPrefix}-wrap`)}>
        <div
          style={{ top }}
          className={classNames(
            `${classPrefix}-main`,
            icon ? `${classPrefix}-main-icon` : `${classPrefix}-main-text`
          )}
        >
          {iconElement && (
            <div className={`${classPrefix}-icon`}>{iconElement}</div>
          )}
          {content}
        </div>
      </div>
    </Mask>
  )
}
