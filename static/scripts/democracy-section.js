const html = `
    <link rel="stylesheet" href="/public/styles/democracy-section.css">
    <h1>Democracy Section</h1>
`;

export const define = (html) => {
    class DemocracySection extends HTMLElement {
        constructor() {
            super();
            const shadow = this.attachShadow({mode: 'open'});
            shadow.innerHTML = html;
        }
    }
    customElements.define('democracy-section', DemocracySection);
}

define(html);
