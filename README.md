# ⚡️ Meta Trader 5 + WebSockets + Real-time Ticker Messages
An example on how to push real-time ticker updates from MetaTrader 5 over WebSockets to any server.

![Real-time Tickers](/Readme-assets/Tickers.gif)

- 📘 Uses the robust WebSocket library implementation found in the MQL5 Book
- ⚡️ Sets a super tight update interval to have near-zero latency ticker updates
- 🚚 Combines ticker updates for symbols that changed in the same interval
- 📚 Uses JAson library to serialize/deserialize json

In use for our trade signaling website: [https://solidsignals.xyz](https://solidsignals.xyz) — Consistent Profitable Trades\
Written in MQL5, by polyclick

# Important

MetaTrader 5 limits the symbols we can track. You can only request data from symbols that are listed in the Market Watch window. Keep this in mind when configuring the Expert Advisor. You'll find an array of strings for the symbols you want to track. Make sure you add those symbols in the Market Watch. Make sure the symbol name in the script is spelled correctly.

# Instructions
## 1. Download this github project

Shouldn't be too hard :)


## 2. Install the MQL5Book library

Place the `MQL5Book` directory in the default `/MQL5/Include/` directory, resulting in the full path being: `/MQL5/Include/MQL5Book`

When installed correctly your file structure should look like this:

![Include](/Readme-assets/Include.png)

## 3. Create your custom Expert Advisor folder & Copy files

Create your own custom Expert Advisor folder under `/MQL5/Experts/{FOLDER_NAME}` \
Copy everything in this repo from `Expert/` into your custom folder

![Include](/Readme-assets/Expert.png)

## 4. Compile

Compile & pray 🙏🏼 \
Fix any include path issues

## 6. Whitelist the WebSocket url in Tools > Options

![Whitelist](/Readme-assets/Whitelist.png)

## 7. Attach compiled expert to any chart

Although the Expert Advisor doesn't really use the `onTick()` event, we need to add it to a chart to start its execution.

There are some print statements in the code to help you debug.

# Extra

## Start A Local, Temporary WebSocket Server
During development, setting up a temporary WebSocket server helps monitoring the sent Expert Advisor messages. For this, I suggest you use `wscat`:

Starts a temporary WebSocket server on your local machine:
```
npx wscat -l 8080
```
Then, use `untun` to expose the local server for incoming public traffic using CloudFlare (Free):
```
npx untun@latest tunnel http://localhost:8080
```
![Tunnel](/Readme-assets/Tunnel.png)

Untun will return a public url that routes public traffic to your local machine.

- Use the public url in the `Tools > Options` dialog (whitelist)
- Fill in the public url as an input for the Expert Advisor

If connection fails, try different variations of the same url in both the `Tools > Options` (whitelist dialog) and the EA input parameter (WebSocket address):

- `http://random-url.trycloudflare.com`
- `https://random-url.trycloudflare.com`
- `ws://random-url.trycloudflare.com`
- `wss://random-url.trycloudflare.com`

# Getting help
- Open an issue
- Check out our website: Solid Signals — [https://solidsignals.xyz](https://solidsignals.xyz)
- Join us on Discord: [https://discord.gg/NMVSE5mGkX](https://discord.gg/NMVSE5mGkX)
