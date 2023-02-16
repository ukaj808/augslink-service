const html = `
    <link rel="stylesheet" href="/public/styles/queue-section.css">
    <h1>Queue Section</h1>
`;

export const define = (html) => {
    class QueueSection extends HTMLElement {
        constructor() {
            super();
            const shadow = this.attachShadow({mode: 'open'});
            shadow.innerHTML = html;
        }
    }
    customElements.define('queue-section', QueueSection);
}

define(html);
