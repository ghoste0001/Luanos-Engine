local Signal = require("@signal")

local propTable = {
    Name = "Sound",
    SoundId = "./src/assets/sounds/bbqchickenalert.mp3",
    IsLoaded = false,

    Volume = 0.5,
    PlaybackSpeed = 1,
    Looped = false,
    Playing = false,
    PlayOnRemove = false,
}