const initialState = {};

ChainElement.storage.hello = 'Hello World';

ChainElement.storage.bank = 'Hello Bank';


class TestTest extends ChainElement {
    constructor() {
        super(initialState);
    }

    builder(state, props, storage, query) {

        let linkList = this.querySelectorAll('a')
        console.log(linkList)
        linkList.forEach((Value, index, obj) => {
          linkList[index].addEventListener('click', function (event) {
            event.preventDefault()
            console.log(this)
          }); 
        });

        const style = `<style>a{color: blue;}</style>`;

        const template = `<a>${storage.hello}</a>`;

        return `${style} ${template}`;
    }
    postBuild
}

class TestStorage extends ChainElement {
  constructor() {
      super(initialState);
  }

  builder(state, props, storage, query) {
      const style = `<style>p{color: blue;}</style>`;

      const template = `<p>${storage.bank}</p>`;
      console.log(storage)
      return `${style} ${template}`;
  }
}


console.log(ChainElement.query);

// ChainElement.makeTag('test-test', TestTest);

// ChainElement.makeTag('test-storage', TestStorage);


customElements.define('test-test', TestTest)
customElements.define('test-storage', TestStorage)