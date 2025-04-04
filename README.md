# Meta Trader 5 + WebSockets + Real-time Ticker Messages
An example on how to push real-time ticker updates from MetaTrader 5 over WebSockets to any server.
Uses the robust WebSocket library implementation found in the MQL5 Book. 
Sets a super tight update interval to have near-zero latency ticker updates.

In use for our trade signaling website: https://solidsignals.xyz — Consistent Profitable Trades.
Written in MQL5, developed by @polyclick

# Instructions
1. Download the project directory
2. Install the MQL5Book library in /MQL5/Include/MQL5Book/
3. Create an Expert Advisor foldder in /MQL5/Experts/{YOUR_EXPERT}
4. Copy the code over into your new folder
5. Compile
6. Whitelist the WebSocket url in Tools > Options
7. Attach compiled expert to any chart

# Getting help
Check out our website: Solid Signals — https://solidsignals.xyz
Join us on Discord: https://discord.gg/NMVSE5mGkX
