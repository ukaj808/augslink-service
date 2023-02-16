const html = `
    <link rel="stylesheet" href="/public/styles/order-section.css">
    <ol id="user-order-list" class="user-order-list">
       <!-- Insert template list item here -->
    </ol>
    <template id="user-template">
       <li class="user-order-list__user">
          <!-- This label acts as a sort of template itself, being replaced by the css counter -->
          <label class="user-order-list__order-lbl"></label>
          <label class="user-order-list__username-lbl"></label></li>
    </template>
`
const define = (html) => {
    const roomElement = document.getElementById("room");
    let shadow;

    const createNewUserListElement = (userDetails) => {
        const userTemplate = shadow.querySelector('#user-template');
        const clone = userTemplate.content.cloneNode(true);
        const listItemElement = clone.querySelector("li");

        listItemElement.id = userDetails.userId;

        const usernameLabel = listItemElement.children[1];

        usernameLabel.textContent = userDetails.username;

        return clone;
    }

    const createWholeUserList = (users) => {
        const fragment = new DocumentFragment();
        users.forEach(user => {
            fragment.appendChild(createNewUserListElement({userId: user.id, username: user.username}));
        })
        return fragment;
    }

    const onUserJoin = ({detail}) => {
        shadow.querySelector("#user-order-list").appendChild(createNewUserListElement(detail));
    }

    const onUserLeft = ({detail}) => {
        shadow.getElementById(detail.userId).remove();
    }

    const onUserWelcome = ({detail}) => {
        const currentUsers = Array.from(detail.roomState.connectedUsers.values());
        shadow.querySelector("#user-order-list").appendChild(createWholeUserList(currentUsers));
        console.log(detail);
    }

    class OrderSection extends HTMLElement {
        constructor() {
            super();
            shadow = this.attachShadow({mode: 'open'});
            shadow.innerHTML = html;
        }

        connectedCallback() {
            super.connectedCallback && super.connectedCallback();
            roomElement.addEventListener("user-enter", onUserJoin);
            roomElement.addEventListener("user-left", onUserLeft);
            roomElement.addEventListener("user-welcome", onUserWelcome);
        }

        disconnectedCallback() {
            roomElement.removeEventListener("user-enter", onUserJoin);
            roomElement.removeEventListener("user-left", onUserLeft)
            roomElement.removeEventListener("user-welcome", onUserWelcome)
            super.disconnectedCallback && super.disconnectedCallback();
        }

    }
    customElements.define('order-section', OrderSection);
}

define(html);
