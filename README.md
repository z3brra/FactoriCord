# 🧩 FactoriCord
**FactoriCord** is a complete, **decentralized SaaS suite** designed to bridge Factorio servers and Discord seamlessly.

It consitsts of : 
- 🧠 A **discord bot** (user-facing)
- ⚙️ A lightweight **API client** (installed on your VPS)
- 🌐 A secure **central API** (liniking both parts)

Together, they let you **monitor, log and display** Factorio events on Dsicord.

All withou manual configuration.

# 🚀 What It Does
**FactoriCord** automatically logs and sync :
- ✅ Player **joins, leaves**, and **deaths**
- 🕒 **Session** tracking
- 💬  **Chat bridge** (coming soon)
- 📊 More advenced events and functionnality in futures updates

All events are formatted inco clean Discord embeds, localized and sent to the right channels automatically.

> 🗣️ FactoriCord currently supports English ``GB`` and French ``FR`` (i18n ready).

# 🧠 Architecture & Philosophy
FactoriCord is a **distributed SaaS** system, where the user stays fully autonomous :

| Component | Description |
| --------- | ----------- |
| 🧩 Discord Bot | The entry point. Handles registration, onboarding, and events delivery to your server through the API. |
| ⚙️ API Client (agent) | Installed on your VPS, it needs Factorio logs and securely communicates with the central API to push events. |
| 🌐 Central API | Validates tokens, serves client updates, and ensures data integrity. |

Everything runs **decentrally on the user's machine**, but the orchestration remains **as-a-service** which means : 
- No hosting required
- No manual configuration (key in hands)
- Automatic updates and authentication

# 🧭 Onboarding flow / steps
Setting up FactoriCord is fully guided through Discord :
1. [Invite the bot](https://discord.com/oauth2/authorize?client_id=1431812070566793368&permissions=3408481685073008&integration_type=0&scope=bot) to your Discord server
2. Use the command ``!register``. The bot starts the registration process for your server.
3. The **bot contacts the API**, requesting a new **sever token**.
4. The **API responds** with a unique authentication token for your Discord server (guild).
5. The bot displays **your custom installation command**, ready to copy-paste on your VPS.
6. On your VPS, **run the command** (the scripts automatically installs Python and dependencies, downaloads and configure the FactoriCord client, and set it up as a **systemd service**)
7. The API Client registers with the central PAI using your server token to finalizing the link.
8. ✅ From now on, **your Factorio server is connected !**

The bot will automatically relay in-game events to your Discord server :)

# 🧩 Why it's different ?
- 🧱 **Decentralized :** Each user hosts their own API Client.
- 🔒 **Secure :** Token based communication and isolated services
- 💡 **Automatic :** from registration to logging -> Zero manual setup
- 🌍 **Multi-language :** built-in i18n support (EN / FR)
- 🔄 **Self-updating :** Client and bot stay synced automatically by auto-update.

# 💬 Join the Community
Ready to connect your Factorio world to Discord ?

Join the community and start your setup in minutes :

👉 **[Join the FactoriCord Discord](https://discord.gg/nhXebNj5AZ)**