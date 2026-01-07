# GuildRecruiter v3.7
Automated guild recruitment addon for Turtle WoW.

GuildRecruiter helps guild officers send recruitment messages automatically in world chat, with full control over timing, zones, and message content. The addon is designed to be simple to use, safe to run, and respectful of Turtle WoW’s gameplay rules.

---

## ✨ Features

### Automatic recruitment
- Sends recruitment messages at a configurable interval  
- Only runs if the player is in the correct guild and has invite permissions  
- Pauses automatically when AFK or DND  

### Zone‑aware behavior
- Only recruits in allowed zones  
- Optional **World Override** mode to recruit everywhere  
- Detects new or unknown zones and lets you review them with `/gr zones`  

### Custom messages
- Add, remove, and list recruitment messages  
- Messages are stored per character  

### Built‑in help window
- `/gr` opens a scrollable help window  
- Clear and readable layout  

---

## 📦 Installation

1. Download or clone the addon folder  
2. Place it in:  
   Interface/AddOns/GuildRecruiter/  
3. Restart the game  

---

## 🧠 Slash Commands

### General
**/gr**  
Open or close the help window.

**/gr on**  
Enable automatic recruitment.

**/gr off**  
Disable automatic recruitment.

**/gr now**  
Send a recruitment message immediately.

**/gr status**  
Show current settings.

---

### Zone tools
**/gr zones**  
Show zones not yet defined in the addon.

---

### Recruitment settings
**/gr timer <seconds>**  
Set delay between recruitment messages.

**/gr channel <name>**  
Set the chat channel to send messages in.

**/gr guild <guild name>**  
Set the guild name required to run recruitment.

**/gr worldoverride on**  
**/gr worldoverride off**  
Enable or disable recruiting in all zones.

---

### Message management
**/gr msg list**  
List recruitment messages.

**/gr msg add <text>**  
Add a recruitment message.

**/gr msg remove <number>**  
Remove a recruitment message.

---

## ❤️ Credits

Created by **Subby** for the Turtle WoW community.
