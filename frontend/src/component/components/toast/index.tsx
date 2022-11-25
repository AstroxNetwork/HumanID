import './toast.less'
import { config, containers, show, unmountNode } from './show'
// import { alert } from './alert'
import { Toast } from './toast'
import { addFuncToComponent } from "../../utils/add-func-to-component"


export function clear() {
  while (true) {
    const container = containers.pop()
    if (!container) break
    unmountNode(container)
  }
}


export default addFuncToComponent(Toast, {
  show,
  config,
  clear,
})