export default class {
  constructor(params) {
    this.params = params
    this.__template = ''
    this.__template_path = ''

    const getCookie = (cookieKey) => {
      let cookieName = `${cookieKey}=`

      let cookieArray = document.cookie.split(';')

      for (let cookie of cookieArray) {
        while (cookie.charAt(0) == ' ') {
          cookie = cookie.substring(1, cookie.length)
        }

        if (cookie.indexOf(cookieName) == 0) {
          return cookie.substring(cookieName.length, cookie.length)
        }
      }
    }
    this.__uuid = getCookie('uuid')
  }

  setTitle(title) {
    document.title = title
  }

  async getHtml() {
    await fetch(this.__template_path)
      .then((res) => res.text())
      .then((res) => (this.__template = res))
    return this.__template
  }
}
