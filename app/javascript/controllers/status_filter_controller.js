import { Controller } from "stimulus"

export default class extends Controller {
  filterByStatus() {
    this.element.closest("form").submit()
  }
}