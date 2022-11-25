import React, { FC, ReactNode, useState } from 'react'
import classNames from 'classnames'
import Mask from '../mask'
import type { MaskProps } from '../mask'
import { NativeProps, withNativeProps } from '../../utils/native-props'
import {
  GetContainer,
  renderToContainer,
} from '../../utils/get-render-container'
import {
  PropagationEvent,
  withStopPropagation,
} from '../../utils/with-stop-propagation'
import { mergeProps } from '../../utils/merge-props'
import { Action, ModalActionButton } from './modal-action-button'

export type ModalProps = {
  afterClose?: () => void
  afterShow?: () => void
  header?: ReactNode
  title?: ReactNode
  content?: ReactNode
  actions?: Action[]
  onAction?: (action: Action, index: number) => void | Promise<void>
  closeOnAction?: boolean
  onClose?: () => void
  closeOnMaskClick?: boolean
  visible?: boolean
  getContainer?: GetContainer
  bodyStyle?: React.CSSProperties
  bodyClassName?: string
  maskStyle?: MaskProps['style']
  maskClassName?: string
  stopPropagation?: PropagationEvent[]
  showCloseButton?: boolean
  disableBodyScroll?: boolean
} & NativeProps

const defaultProps = {
  visible: false,
  actions: [] as Action[],
  closeOnAction: false,
  closeOnMaskClick: false,
  stopPropagation: ['click'],
  showCloseButton: false,
  getContainer: null,
  disableBodyScroll: true,
}

export const Modal: FC<ModalProps> = (p) => {
  const props = mergeProps(defaultProps, p)

  const body = (
    <div
      className={classNames(cls('body'), props.bodyClassName)}
      style={props.bodyStyle}
    >
      {props.showCloseButton && (
        <a
          className={classNames(cls('close'), 'adm-plain-anchor')}
          onClick={props.onClose}
        >
          close
        </a>
      )}
      {!!props.header && <div className={cls('header')}>{props.header}</div>}
      {!!props.title && <div className={cls('title')}>{props.title}</div>}
      <div className={cls('content')}>
        {typeof props.content === 'string' ? props.content : props.content}
      </div>
      <div
        className={classNames(
          cls('footer'),
          props.actions.length === 0 && cls('footer-empty')
        )}
      >
        {props.actions.map((action, index) => {
          return (
            <ModalActionButton
              key={action.key}
              action={action}
              onAction={async () => {
                await Promise.all([
                  action.onClick?.(),
                  props.onAction?.(action, index),
                ])
                if (props.closeOnAction) {
                  props.onClose?.()
                }
              }}
            />
          )
        })}
      </div>
    </div>
  )

  const node = withStopPropagation(
    props.stopPropagation,
    withNativeProps(
      props,
      <div
        className={cls()}
        style={{
          display: props.visible ? undefined : 'none',
        }}
      >
        <Mask
          visible={props.visible}
          onMaskClick={props.closeOnMaskClick ? props.onClose : undefined}
          style={props.maskStyle}
          className={classNames(cls('mask'), props.maskClassName)}
          disableBodyScroll={props.disableBodyScroll}
        />
        <div
          className={cls('wrap')}
          style={{
            pointerEvents: props.visible ? undefined : 'none',
          }}
        >
          <div style={props.style}>{body}</div>
        </div>
      </div>
    )
  )

  return renderToContainer(props.getContainer, node)
}

function cls(name: string = '') {
  return 'rc-modal' + (name && '-') + name
}
