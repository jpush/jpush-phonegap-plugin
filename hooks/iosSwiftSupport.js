/* JPush contains Swift objects. Keep this plugin's build additions removable and idempotent. */
const fs = require('fs');
const path = require('path');
const BEGIN = '// BEGIN JPUSH SWIFT SUPPORT';
const END = '// END JPUSH SWIFT SUPPORT';
function transform(content, remove) {
  const begin = content.indexOf('\n' + BEGIN + '\n');
  if (begin !== -1) {
    const end = content.indexOf(END + '\n', begin);
    if (end === -1) throw new Error('Incomplete JPush Swift support block');
    content = content.slice(0, begin) + content.slice(end + END.length + 1);
  }
  if (remove) return content;
  const additions = [];
  const paths = '"$(TOOLCHAIN_DIR)/usr/lib/swift/$(PLATFORM_NAME)" "$(SDKROOT)/usr/lib/swift"';
  const settings = new Map();
  const logicalLines = [];
  let continued = '';
  let inBlock = false;
  let quote = '';
  for (const physical of content.split('\n')) {
    let line = '';
    for (let i = 0; i < physical.length; i++) {
      const char = physical[i], next = physical[i + 1];
      if (inBlock) { if (char === '*' && next === '/') { inBlock = false; i++; } continue; }
      if (quote) {
        line += char;
        if (char === '\\' && next !== undefined) { line += next; i++; }
        else if (char === quote) quote = '';
      } else if (char === '/' && next === '/') { break; }
      else if (char === '/' && next === '*') { inBlock = true; i++; }
      else { line += char; if (char === '"' || char === "'") quote = char; }
    }
    if (/\\\s*$/.test(line)) continued += line.replace(/\\\s*$/, '') + ' ';
    else { logicalLines.push(continued + line); continued = ''; }
  }
  if (continued || inBlock || quote) throw new Error('Incomplete xcconfig syntax in JPush Swift support');
  for (const line of logicalLines) {
    const match = line.match(/^\s*(LIBRARY_SEARCH_PATHS(?:\[[^\]]+\])*)\s*=\s*(.*?)\s*;?\s*$/);
    if (match) settings.set(match[1], match[2].replace(/;$/, '').trim());
  }
  if (!settings.has('LIBRARY_SEARCH_PATHS')) settings.set('LIBRARY_SEARCH_PATHS', '$(inherited)');
  for (const [key, value] of settings) {
    additions.push(key + ' = ' + (value.includes('$(inherited)') ? value : '$(inherited) ' + value) + ' ' + paths);
  }
  additions.push('ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES = YES');
  return content + '\n' + BEGIN + '\n' + additions.join('\n') + '\n' + END + '\n';
}
module.exports = function(context) {
  const file = path.join(context.opts.projectRoot, 'platforms', 'ios', 'cordova', 'build-extras.xcconfig');
  if (!fs.existsSync(file)) return; // Android-only hosts need no iOS mutation.
  const before = fs.readFileSync(file, 'utf8');
  const after = transform(before, context.hook === 'before_plugin_uninstall');
  if (after !== before) fs.writeFileSync(file, after);
};
module.exports.transform = transform;
