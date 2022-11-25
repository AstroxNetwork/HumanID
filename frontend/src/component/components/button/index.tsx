import classNames from 'classnames'
import { useImperativeHandle, useRef, forwardRef } from 'react'
import { mergeProps } from '../../utils/merge-props'
import { NativeProps, withNativeProps } from '../../utils/native-props'

const classPrefix = `rc-button`

type NativeButtonProps = React.DetailedHTMLProps<
  React.ButtonHTMLAttributes<HTMLButtonElement>,
  HTMLButtonElement
>

export type ButtonProps = {
  color?: 'default' | 'primary' | 'success' | 'warning' | 'danger'
  fill?: 'solid' | 'outline' | 'none'
  size?: 'mini' | 'small' | 'middle' | 'large'
  block?: boolean
  disabled?: boolean
  onClick?: (
    event: React.MouseEvent<HTMLButtonElement, MouseEvent>
  ) => void | Promise<void> | unknown
  type?: 'submit' | 'reset' | 'button'
  shape?: 'default' | 'rounded' | 'rectangular'
  children?: React.ReactNode
} & Pick<
  NativeButtonProps,
  'onMouseDown' | 'onMouseUp' | 'onTouchStart' | 'onTouchEnd'
> &
  NativeProps<
    | '--text-color'
    | '--background-color'
    | '--border-radius'
    | '--border-width'
    | '--border-style'
    | '--border-color'
  >

export type ButtonRef = {
  nativeElement: HTMLButtonElement | null
}

const defaultProps: ButtonProps = {
  color: 'default',
  fill: 'solid',
  block: false,
  type: 'button',
  shape: 'default',
  size: 'middle',
}
const Button = forwardRef<ButtonRef, ButtonProps>((p, ref) => {
  const props = mergeProps(p, defaultProps)
  const nativeButtonRef = useRef<HTMLButtonElement>(null)

  useImperativeHandle(ref, () => ({
    get nativeElement() {
      return nativeButtonRef.current
    },
  }))
  return withNativeProps(
    props,
    <button
      ref={nativeButtonRef}
      type={props.type}
      className={classNames(
        classPrefix,
        props.color ? `${classPrefix}-${props.color}` : null,
        {
          [`${classPrefix}-block`]: props.block,
          [`${classPrefix}-disabled`]: props.disabled,
          [`${classPrefix}-fill-outline`]: props.fill === 'outline',
          [`${classPrefix}-fill-none`]: props.fill === 'none',
          [`${classPrefix}-mini`]: props.size === 'mini',
          [`${classPrefix}-small`]: props.size === 'small',
          [`${classPrefix}-large`]: props.size === 'large',
        },
        `${classPrefix}-shape-${props.shape}`
      )}
      disabled={props.disabled}
      onMouseDown={props.onMouseDown}
      onMouseUp={props.onMouseUp}
      onTouchStart={props.onTouchStart}
      onTouchEnd={props.onTouchEnd}
    >
      {props.children}
    </button>
  )
})

export default Button
