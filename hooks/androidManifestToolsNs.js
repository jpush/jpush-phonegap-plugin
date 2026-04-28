/**
 * Ensures root <manifest> declares xmlns:tools so tools:replace on JPUSH_* meta-data merges.
 * Idempotent: if xmlns:tools is already present, does nothing (avoids edit-config conflicts at plugin add).
 */
'use strict';

const fs = require('fs');
const path = require('path');

const TOOLS_NS = 'xmlns:tools="http://schemas.android.com/tools"';

function hasToolsNamespace(xml) {
  return /\bxmlns:tools\s*=\s*["']http:\/\/schemas\.android\.com\/tools["']/.test(xml);
}

function ensureToolsNamespace(xml) {
  if (hasToolsNamespace(xml)) {
    return xml;
  }
  return xml.replace(/<manifest(\s+)/, '<manifest ' + TOOLS_NS + '$1');
}

module.exports = function (context) {
  const projectRoot = (context.opts && context.opts.projectRoot) || process.cwd();
  const candidates = [
    path.join(projectRoot, 'platforms', 'android', 'app', 'src', 'main', 'AndroidManifest.xml'),
    path.join(projectRoot, 'platforms', 'android', 'AndroidManifest.xml'),
  ];

  for (const manifestPath of candidates) {
    if (!fs.existsSync(manifestPath)) {
      continue;
    }
    const before = fs.readFileSync(manifestPath, 'utf8');
    const after = ensureToolsNamespace(before);
    if (after !== before) {
      fs.writeFileSync(manifestPath, after, 'utf8');
      console.log('[jpush-phonegap-plugin] Added ' + TOOLS_NS + ' to ' + manifestPath);
    }
  }
};
