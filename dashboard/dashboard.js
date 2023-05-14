import AbstractView from '/js/AbstractView.js'
import '/component/dashboard/graph-line.js'
import '/component/dashboard/graph-bar.js'
import '/component/dashboard/dashboard-todo.js'
import '/component/dashboard/task-google.js'
import '/component/dashboard/task-slack.js'
import '/component/dashboard/dashboard-message.js'
import '/component/dashboard/dashboard-voicemail.js'
import '/component/dashboard/dashboard-calendar.js'
import '/component/dashboard/dashboard-progressbar.js'

import 'https://cdn.jsdelivr.net/npm/chart.js'

export default class extends AbstractView {
  constructor(params) {
    super(params)
    this.setTitle('Dashboard')
    this.__template_path = '/dashboard/dashboard.html'
  }
}
