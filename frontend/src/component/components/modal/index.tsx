import './modal.less'
import { show } from './show'
// import { alert } from './alert'
import { Modal } from './modal'
import { clear } from './clear'
import { addFuncToComponent } from "../../utils/add-func-to-component"

export default addFuncToComponent(Modal, {
  show,
  alert,
  confirm,
  clear,
})