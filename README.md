# qb-phone (with discord app)
Stock qb-phone with an added discord app.

Run the provided discordapp.sql file

```sql
CREATE TABLE `phone_chatrooms` (
    `id` INT unsigned NOT NULL AUTO_INCREMENT,
    `room_code` VARCHAR(10) NOT NULL UNIQUE,
    `room_name` VARCHAR(15) NOT NULL,
    `room_owner_id` VARCHAR(20),
    `room_owner_name` VARCHAR(60),
    `room_members` TEXT DEFAULT '{}', 
    `room_pin` VARCHAR(50),
    `unpaid_balance` DECIMAL(10,2) DEFAULT 0,
    `is_masked` BOOLEAN DEFAULT 0,
    `is_pinned` BOOLEAN DEFAULT 0,
    `created` DATETIME DEFAULT NOW(),
    PRIMARY KEY (`id`)
);

CREATE TABLE `phone_chatroom_messages` (
    `id` INT unsigned NOT NULL AUTO_INCREMENT,
    `room_id` INT unsigned,
    `member_id` VARCHAR(20),
    `member_name` VARCHAR(50),
    `message` TEXT NOT NULL,
     `is_pinned` BOOLEAN DEFAULT FALSE,
     `created` DATETIME DEFAULT NOW(),
    PRIMARY KEY (`id`)
);
```

The app is configured to work around legal and illegal selling of chatrooms (default location inside [Patochoe's Cyberbar MLO](https://www.gta5-mods.com/maps/mlo-cyber-bar-fivem-sp))

For legal selling, you approach the seller and purchase the chatroom (configued with qb-target and qb-input). For illegal selling you need to hack your phone with a cracked usb. *This script does not provide a way to get the item, you must implement this yourself (through house robbery loot tables or other means).*

The phone hack is by default using the paid cd_terminalhack resource. This can easily be swapped for an alternative in `qb-phone:client:TriggerPhoneHack` in client/room_creation.lua

Any bugs feel free to PR, I am not maintaining this resource just releasing my work to the public. It's been extensively tested already on a live server.
