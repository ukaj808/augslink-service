const html = `
    <link rel="stylesheet" href="/public/styles/drop-section.css">
    <h1>Drop Section</h1>
`;

export const define = (html) => {
    class DropSection extends HTMLElement {
        constructor() {
            super();
            const shadow = this.attachShadow({mode: 'open'});
            shadow.innerHTML = html;
        }
    }
    customElements.define('drop-section', DropSection);
}

define(html);
