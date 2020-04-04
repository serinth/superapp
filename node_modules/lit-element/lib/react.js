/**
 * @license
 * Copyright (c) 2018 The Polymer Project Authors. All rights reserved.
 * This code may only be used under the BSD style license found at
 * http://polymer.github.io/LICENSE.txt
 * The complete set of authors may be found at
 * http://polymer.github.io/AUTHORS.txt
 * The complete set of contributors may be found at
 * http://polymer.github.io/CONTRIBUTORS.txt
 * Code distributed by Google as part of the polymer project is also
 * subject to an additional IP rights grant found at
 * http://polymer.github.io/PATENTS.txt
 */
const reservedReactProperties = ['children', 'localName', 'ref', 'style', 'className'];
/**
 *  Creates a React component from a LitElement or UpdatingElement.
 */
export const createReactComponent = (React, clazz, tagName) => {
    const Component = React.Component;
    const createElement = React.createElement;
    const setProperty = (node, name, value, old) => {
        if (clazz._classProperties.has(name)) {
            node[name] = value;
        }
        else if (name[0] === 'o' && name[1] === 'n') {
            // TODO(justinfagnani): camel-case to kebab-case conversion?
            if (old) {
                node.removeEventListener(name.substring(2), old);
            }
            if (value) {
                node.addEventListener(name.substring(2), value);
            }
        }
        else {
            node.setAttribute(name, value);
        }
    };
    return class extends Component {
        constructor(props) {
            super(props);
            this.ref = (c) => {
                this.base = c;
                if (this.props.ref) {
                    this.props.ref(c);
                }
            };
        }
        componentDidMount() {
            for (const i in this.props) {
                if (reservedReactProperties.indexOf(i) === -1) {
                    setProperty(this.base, i, this.props[i], null);
                }
            }
        }
        componentDidUpdate(old) {
            const { props } = this;
            for (const i in props) {
                if (reservedReactProperties.indexOf(i) === -1 &&
                    props[i] !== old[i]) {
                    setProperty(this.base, i, props[i], old[i]);
                }
            }
            for (const i in old) {
                if (reservedReactProperties.indexOf(i) === -1 && !(i in props)) {
                    setProperty(this.base, i, null, old[i]);
                }
            }
        }
        componentWillUnmount() {
            for (const i in this.props) {
                if (reservedReactProperties.indexOf(i) === -1) {
                    setProperty(this.base, i, null, null);
                }
            }
        }
        render() {
            const props = { ref: this.ref };
            for (const i in this.props) {
                if (reservedReactProperties.indexOf(i) !== -1) {
                    props[i] = this.props[i];
                }
            }
            return createElement(tagName, props, this.props.children);
        }
    };
};
//# sourceMappingURL=react.js.map