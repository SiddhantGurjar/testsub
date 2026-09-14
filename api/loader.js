const fs = require('fs');
const path = require('path');

module.exports = function handler(req, res) {
  const userAgent = req.headers['user-agent'] || '';
  
  const isBrowser = /Mozilla|Chrome|Safari|Edge|Firefox/i.test(userAgent);

  if (isBrowser) {
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
