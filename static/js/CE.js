//////CHAINELEMENT BY ALEX MERCED OF ALEXMERCED.COM

////////////////////////////
// getQueryHash
////////////////////////////

const getQueryHash = () => {
  const hash = window.location.href.split('#')[1];

  const queryArray1 = window.location.href.split('?')[1];

  const queryArray2 = queryArray1 ? queryArray1.split('#')[0].split('&') : [];

  const queryEntries = queryArray2.map((value) => {
      return value.split('=');
  });

  return [Object.fromEntries(queryEntries), hash];
};

////////////////////////
//capture props
///////////////////////

const captureProps = (element) => {
  const att = [...element.attributes];
  const entries = att.map((value) => {
      return [value.name, value.value];
  });

  return Object.fromEntries(entries);
};

///////////////////////////
//ChainElement
//////////////////////////

class ChainElement extends HTMLElement {
  constructor(state = {}) {
      super();
      this.state = state;
      this.props = captureProps(this);
      this.attachShadow({ mode: 'open' });
      ChainElement.list.push(this);
      this.build();
  }
  static list = [];
  static storage = {};
  static query = getQueryHash()[0];

  static buildAll() {
      ChainElement.list.forEach((value) => value.build());
  }

  static doc = {
      select: (q) => {
          return document.querySelector(q);
      },
      selectAll: (q) => {
          return document.querySelectorAll(q);
      },
      byId: (q) => {
          return document.getElementById(q);
      },
      byTag: (q) => {
          return document.getElementsByTagName(q);
      },
      byClass: (q) => {
          return document.getElementsByClassName(q);
      },
      create: (q) => {
          return document.createElement(q);
      },
      remove: (q) => {
          return document.removeChild(q);
      },
      append: (q) => {
          return document.appendChild(q);
      },
      replace: (q, y) => {
          return document.replaceChild(q, y);
      },
  };

  static shad = {
      select: (e, q) => {
          return e.shadowRoot.querySelector(q);
      },
      selectAll: (e, q) => {
          return e.shadowRoot.querySelectorAll(q);
      },
      byId: (e, q) => {
          return e.shadowRoot.getElementById(q);
      },
      byTag: (e, q) => {
          return e.shadowRoot.getElementsByTagName(q);
      },
      byClass: (e, q) => {
          return e.shadowRoot.getElementsByClassName(q);
      },
      create: (e, q) => {
          return e.shadowRoot.createElement(q);
      },
      remove: (e, q) => {
          return e.shadowRoot.removeChild(q);
      },
      append: (e, q) => {
          return e.shadowRoot.appendChild(q);
      },
      replace: (e, q, y) => {
          return e.shadowRoot.replaceChild(q, y);
      },
  };

  static makeTag(name, element) {
      window.customElements.define(name, element);
  }

  builder(state, props, global, query) {
      return '';
  }

  build() {
      this.props = captureProps(this);
      this.shadowRoot.innerHTML = this.builder(
          this.state,
          this.props,
          ChainElement.storage,
          ChainElement.query
      );
      this.postBuild(
          this.state,
          this.props,
          ChainElement.storage,
          ChainElement.query
      );
  }

  postBuild(state, props, global, query) {
      return null;
  }

  setState(newState) {
      this.state = { ...this.state, ...newState };
      this.build();
  }
}
