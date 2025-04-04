# ⚡️ Meta Trader 5 + WebSockets + Real-time Ticker Messages
An example on how to push real-time ticker updates from MetaTrader 5 over WebSockets to any server.

![Real-time Tickers](/Readme-assets/Tickers.gif)

- 📘 Uses the robust WebSocket library implementation found in the MQL5 Book
- ⚡️ Sets a super tight update interval to have near-zero latency ticker updates
- 📚 Uses JAson library to serialize/deserialize json

In use for our trade signaling website: [https://solidsignals.xyz](https://solidsignals.xyz) — Consistent Profitable Trades.\
Written in MQL5, developed by polyclick

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

For testing purposes it's useful to have a temporary WebSocketServer running.
To do this, I suggest you use `wscat` and `untun`:

Start a temporary websocket server on localhost:
```
npx wscat -l 8080
```

Expose localhost to public traffic using CloudFlare (Free)
```
npx untun@latest tunnel http://localhost:8080
```
It will return a random url that tunnels public traffic to your local machine.
Use the url you get from CloudFlare in the `Tools` > `Options` dialog (whitelist).
Fill in the url as an input for the Expert Advisor.
If connection doesn't work try different variations in both the `Tools > Option` whitelist dialog as the input websocket parameter:

- `http://random-url.trycloudflare.com`
- `https://random-url.trycloudflare.com`
- `ws://random-url.trycloudflare.com`
- `wss://random-url.trycloudflare.com`

# Getting help
- Open an issue, or;
- Check out our website: Solid Signals — [https://solidsignals.xyz](https://solidsignals.xyz)
- Join us on Discord: [https://discord.gg/NMVSE5mGkX](https://discord.gg/NMVSE5mGkX)
