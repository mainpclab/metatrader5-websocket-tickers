# ⚡️ MetaTrader 5 + WebSockets + Real-time Ticker Messages

A solution for streaming real-time ticker updates from MetaTrader 5 over WebSockets to any server.

![Real-time Tickers](/Readme-assets/Tickers.gif)

- 📘 Leverages the robust WebSocket library implementation from the MQL5 Book
- ⚡️ Implements tight update intervals for near-zero latency ticker updates
- 🚚 Batches ticker updates for symbols that changed within the same interval
- 📚 Utilizes JAson library for JSON serialization/deserialization

Currently powering our trade signaling platform: [https://solidsignals.xyz](https://solidsignals.xyz) — Consistent Profitable Trades
Written in MQL5, by polyclick

## Important Note

MetaTrader 5 restricts symbol tracking to those listed in the Market Watch window. When configuring the Expert Advisor, ensure that:
1. All symbols you want to track are added to the Market Watch
2. Symbol names in your configuration array match exactly with those in Market Watch
3. Spelling is correct for all symbol names

## Setup Instructions

### 1. Download this GitHub project

Shouldn't be too hard :)

### 2. Install the MQL5Book library

Place the `MQL5Book` directory in your MetaTrader 5 include directory:
```
/MQL5/Include/MQL5Book
```

When installed correctly, your directory structure should look like this:

![Include Directory Structure](/Readme-assets/Include.png)

### 3. Set up your Expert Advisor folder

1. Create a custom Expert Advisor folder at `/MQL5/Experts/{YOUR_FOLDER_NAME}`
2. Copy all files from the `Expert/` directory in this repo to your custom folder

![Expert Directory Structure](/Readme-assets/Expert.png)

### 4. Compile the Expert Advisor

1. Open MetaEditor
2. Compile the Expert Advisor
3. Resolve any include path issues that may arise

### 5. Whitelist WebSocket URL

In MetaTrader 5:
1. Navigate to Tools > Options
2. Add your WebSocket server URL to the allowed URLs list

![Whitelist Configuration](/Readme-assets/Whitelist.png)

### 6. Attach the Expert Advisor to a chart

Even though the Expert Advisor doesn't primarily use the `onTick()` event, it needs to be attached to a chart to initialize and run.

Debug messages are included in the code to assist with troubleshooting.

## Development Tools

### Local WebSocket Server Setup

For development and testing, you can create a temporary WebSocket server:

1. Start a local WebSocket server using `wscat`:
```bash
npx wscat -l 8080
```

2. Expose your local server to the internet using `untun` (CloudFlare-based tunneling):
```bash
npx untun@latest tunnel http://localhost:8080
```

![Tunnel Configuration](/Readme-assets/Tunnel.png)

3. Use the public URL provided by `untun` in:
   - The MetaTrader 5 Tools > Options whitelist
   - The Expert Advisor input parameters

If connection fails, try these URL variations in both the whitelist and EA parameters:
- `http://random-url.trycloudflare.com`
- `https://random-url.trycloudflare.com`
- `ws://random-url.trycloudflare.com`
- `wss://random-url.trycloudflare.com`

## Support

- Open an issue on GitHub
- Visit our website: [https://solidsignals.xyz](https://solidsignals.xyz)
- Join our Discord community: [https://discord.gg/NMVSE5mGkX](https://discord.gg/NMVSE5mGkX)
