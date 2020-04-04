
import { LitElement, html, css } from 'lit-element';

class NativeElement extends LitElement {

  render(){
    return html`
      <button @click="${this.handleClick}">Native Func Request</button>
    `;
  }

  handleClick(e) {
    console.log('--in native--');
    _superapp.callphone();
    // send event to logic layer here, may request native functionality
  }
}

class SimpleElement extends LitElement {
  static get properties() {
    return { data: { type: String } };
  }

  constructor() {
    super();
    this.id = '';
    this.data = 'No Change';
  }

  static get styles() {
    return css`
      div { background-color: light-gray; }
      * { color: blue; }
  `}

  render(){
    return html`
      <button @click="${this.handleClick}">Simple Element</button>
      <div>Response:${this.data}</div>
    `;
  }

  handleClick(e) {
    console.log('--in simple--');
    
  }
}

customElements.define('native-element', NativeElement);
customElements.define('simple-element', SimpleElement);

var _superapp = {
  callphone: function() {
    SUPA.postMessage('callmemaybe');
  }
};
var _page = {};

// App top level declarations
function App(params) {
  _superapp = params;
}

// receive data from logic layer here
function Page(params) {
  _page = params;
}