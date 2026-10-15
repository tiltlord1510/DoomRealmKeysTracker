# 🔑 Doom Realm Key Tracker

![WoW Version](https://img.shields.io/badge/WoW-9.2.7-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

**Doom Realm Key Tracker** is a lightweight, standalone World of Warcraft Addon built for **Shadowlands 9.2.7**. It provides a clean, backdropless UI overlay to track and display real-time inventory counts for **8 specific key items** directly from your bags and bank.

---

## ✨ Features

* **🔑 Live Item Tracking:** Continuously monitors item counts across bags and bank with automatic color coding for items in stock vs. zero count.
* **👻 Borderless Overlay:** Backgroundless design that integrates seamlessly into your UI without screen clutter.
* **📐 Resizable & Moveable:** Freely drag the overlay frame anywhere on screen, and scale its dimensions using the bottom-right grabber handle.
* **📍 Minimap Button:** Movable minimap icon for quick toggling and access.
* **⚙️ In-Game Settings Panel:** Integrated into WoW's native Interface Options menu (`/drkt` or `/doomkeys`).
* <img width="327" height="324" alt="image" src="https://github.com/user-attachments/assets/b99e32cf-4315-438f-a834-961b5f53e2c6" />


---

## 🎨 Advanced Customization

* **🔡 Font Selection & Scaling:**
  * Custom scrollable font menu with live typeface previews.
  * Full **LibSharedMedia-3.0** support (*ElvUI, SharedMedia, Details!, WeakAuras*).
  * Built-in fallback fonts (*Friz Quadrata, Arial Narrow, Skurri, Morpheus, 2002, 2002B, FRIQT__CYR*).
  * Text size slider (font scale 8pt–24pt).

* **🎨 Custom Color Pickers:**
  * Header title color.
  * Individual colors for every item slot (Items 1 through 8).
  * Separate colors for positive counts (`> 0`) and empty counts (`= 0`).

---

## 🖱️ Controls & Shortcuts

| Action | Shortcut |
| :--- | :--- |
| **Toggle Overlay Frame** | Left-Click Minimap Icon |
| **Open Options Menu** | Right-Click Main Frame OR Shift + Left-Click Minimap Icon |
| **Move Frame / Minimap Icon** | Left-Click & Drag |
| **Resize Main Frame** | Drag Bottom-Right Corner Grip |
| **Slash Commands** | `/drkt` or `/doomkeys` |

---

## 📦 Installation

1. Download or clone this repository.
2. Place the `DoomRealmKeyTracker` folder inside your WoW AddOns directory:
   ```text
   World of Warcraft\_retail_\Interface\AddOns\DoomRealmKeyTracker\
