let createRoomButton = document.getElementById("create-room");

const getRandomInt = function(max) {
    return Math.floor(Math.random() * max);
}

const disableButton = function() {
    createRoomButton.classList.add("welcome__button--disabled");
    return createRoomButton.disabled = true;
}

const enableButton = function() {
    createRoomButton.classList.remove("welcome__button--disabled");
    return createRoomButton.disabled = false;
}

const createRoomBackendCall = function() {
    console.log("createRoomBackendCall");
    return new Promise(async (resolve, reject) => {
        setTimeout(function () {
            if (getRandomInt(3) !== 3) {
                resolve("room_id_12312");
            } else {
                reject("Error!!!!!!!!");
            }
        }, 5000);
    });
}

const createRoom = async function() {
    try {
        disableButton();
        let roomId = await createRoomBackendCall();
        console.log(roomId);
    } catch(e) {
        console.log(e);
    }
    enableButton();
};
createRoomButton.addEventListener("click", createRoom);
