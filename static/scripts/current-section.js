const html = `
        <link rel="stylesheet" href="/public/styles/current-section.css">
        <div class="current_song-info-container">
            <h2 class="current__song-name">Life of the Party</h2>
            <h3 class="current__artist">by Kanye West</h3>
            <h4 class="current__source">source: youtube</h4>
        </div>
        <div class="current__song-time-container">
            <label for="cur-time-input" class="current__song-current-time">00:00</label>
            <input class="current__time-slider" id="cur-time-input" type="range" min="1" max="100" value="0" disabled/>
            <label class="current__song-total-time">4:21</label>
        </div>
        <div class="current__volume-container">
            <label class="current__vol-down">-</label>
            <input class="current__vol-slider" id="cur-vol-input" type="range" min="1" max="100" value="50"/>
            <label class="current__vol-up">+</label>
        </div>
`;

const define = (html) => {
  const roomElement = document.getElementById("room");
  let timeSlider;
  let volSlider;
  let volLabel;
  let shadow;

  // Using "function" to bind "this" to input element.
  const bindVolSlider = function () {
    volLabel.innerHTML = this.value;
  };

  class CurrentSection extends HTMLElement {
    constructor() {
      super();
      shadow = this.attachShadow({ mode: "open" });
      shadow.innerHTML = html;
      timeSlider = shadow.getElementById("cur-time-input");
      volSlider = shadow.getElementById("cur-vol-input");
      volLabel = shadow.getElementById("cur-vol-lbl");
    }

    connectedCallback() {
      super.connectedCallback && super.connectedCallback();
      volSlider.addEventListener("input", bindVolSlider);
    }

    disconnectedCallback() {
      volSlider.removeEventListener("input", bindVolSlider);
      super.disconnectedCallback && super.disconnectedCallback();
    }
  }
  customElements.define("current-section", CurrentSection);
};

define(html);
