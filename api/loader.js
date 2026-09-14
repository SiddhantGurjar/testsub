const fs = require('fs');
const path = require('path');

module.exports = function handler(req, res) {
  const userAgent = req.headers['user-agent'] || '';
  
  // Browsers send specific headers when a user types the URL into the address bar
  const isBrowserNav = req.headers['sec-fetch-mode'] === 'navigate' || req.headers['sec-fetch-dest'] === 'document';
  const prefersHtml = (req.headers['accept'] || '').includes('text/html');
  
  // Some executors spoof the user-agent, but we explicitly allow known ones just in case
  const isKnownExecutor = /Roblox|Krnl|Synapse|Fluxus|Delta|Hydrogen|Codex|Arceus|Trigon|Vega|Evon|Valyse/i.test(userAgent);

  // If it looks like a real browser navigating to the page, block it.
  if ((isBrowserNav || prefersHtml) && !isKnownExecutor) {
    res.setHeader('Content-Type', 'text/html');
    return res.status(403).send("<h1>This Content Is Unavailable.</h1>");
  }

  try {
    const scriptPath = path.join(process.cwd(), 'BloxFruits.lua');
    const luaScript = fs.readFileSync(scriptPath, 'utf8');

    res.setHeader('Content-Type', 'text/plain');
    res.status(200).send(luaScript);
  } catch (error) {
    res.status(500).send("Error loading script: " + error.message);
  }
}
