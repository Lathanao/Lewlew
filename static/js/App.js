// import Dashboard from '/dashboard/dashboard.js'
// import Order from '/backend/order.js'
// import Account from '/backend/account.js'
// import Login from '/backend/login.js'
// import Forget from '/backend/forget.js'
// import Log from '/log/log.js'

Storage = {} // https://stackoverflow.com/a/2010994
Storage.observers = []
Storage.event = []
Storage.test = 'test'
Storage.bank = 'Bank works well'
Storage.blink = 'blink'
Storage.label = 'Push the button'
Storage.label = 'Lew App'
Storage.filter = {}
Storage.filter.order = {}

const pathToRegex = (path) =>
  new RegExp('^' + path.replace(/\//g, '\\/').replace(/:\w+/g, '(.+)') + '$')

const getParams = (match) => {
  const values = match.result.slice(1)
  const keys = Array.from(match.route.path.matchAll(/:(\w+)/g)).map(
    (result) => result[1]
  )

  return Object.fromEntries(
    keys.map((key, i) => {
      return [key, values[i]]
    })
  )
}

const navigateTo = (url) => {
  history.pushState(null, null, url)
  router()
}

const router = async () => {
  const routes = [
    { path: '/dashboard', view: 'dashboard' },
    { path: '/order', view: 'order' },
    { path: '/login', view: 'login' },
    { path: '/logout', view: 'login' },
    { path: '/forget', view: 'forget' },
    { path: '/log', view: 'log' },
    { path: '/account', view: 'account' },
    { path: '/account/:id', view: 'account' },
  ]

  // Test each route for potential match
  const potentialMatches = routes.map( route => {
    return {
      route: route,
      result: location.pathname.match(pathToRegex(route.path)),
    }
  })

  let match = potentialMatches.find(
    (potentialMatch) => potentialMatch.result !== null
  )

  if (!match) {
    match = {
      route: routes[0],
      result: [location.pathname],
    }
  }

  const {default: Page} = await import(`${match.route.path}/${match.route.view}.js`)
  const page = new Page(getParams(match))
  document.querySelector('#app').innerHTML = await page.getHtml()
}

window.addEventListener('popstate', router)

document.addEventListener('DOMContentLoaded', () => {
  document.body.addEventListener('click', (e) => {
    let lewlink = e.target.closest('a')
    if (lewlink && lewlink.matches('[lew-link]')) {
      e.preventDefault()
      navigateTo(e.target.closest('a').href)
    }
  })
  router()
})
