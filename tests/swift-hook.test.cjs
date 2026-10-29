const {test}=require('node:test');const assert=require('node:assert/strict');const transform=require('../hooks/iosSwiftSupport').transform;
test('repeated prepare is idempotent and uninstall exactly restores user contents',()=>{const before='// user\nLIBRARY_SEARCH_PATHS = $(inherited) "$(PROJECT_DIR)/custom path"\nOTHER_LDFLAGS = $(inherited) -ObjC\n';const prepared=transform(before,false);assert.equal(transform(prepared,false),prepared);assert.equal(transform(prepared,true),before);assert.ok(prepared.includes('"$(PROJECT_DIR)/custom path"'));assert.ok(prepared.includes('$(TOOLCHAIN_DIR)/usr/lib/swift/$(PLATFORM_NAME)'));});
test('conditional paths retained and new user edits outside marker survive removal',()=>{const before='LIBRARY_SEARCH_PATHS[sdk=iphoneos*] = "device custom"\n';const prepared=transform(before,false);assert.ok(prepared.includes('LIBRARY_SEARCH_PATHS[sdk=iphoneos*] = $(inherited) "device custom"'));const edited=prepared+'USER_SETTING = YES\n';assert.equal(transform(edited,true),before+'USER_SETTING = YES\n');});

test('end-of-line comments stay outside merged value and quoted slashes are not comments',()=>{
 const before='LIBRARY_SEARCH_PATHS = $(inherited) "/vendor libs" "$(ROOT)//path" // vendor comment\n';
 const prepared=transform(before,false);const block=prepared.split('// BEGIN JPUSH SWIFT SUPPORT')[1];
 assert.ok(block.includes('"/vendor libs" "$(ROOT)//path"'));assert.ok(!block.includes('vendor comment'));assert.ok(block.includes('$(TOOLCHAIN_DIR)'));assert.equal(transform(prepared,false),prepared);assert.equal(transform(prepared,true),before);
});
test('backslash continuations combine all paths without changing original bytes',()=>{
 const before='LIBRARY_SEARCH_PATHS = $(inherited) \\\n    "/vendor one" \\\n    "/vendor two" // keep\n';
 const prepared=transform(before,false);const block=prepared.split('// BEGIN JPUSH SWIFT SUPPORT')[1];
 assert.ok(block.includes('"/vendor one"'));assert.ok(block.includes('"/vendor two"'));assert.ok(!block.includes(' // keep'));assert.equal(transform(prepared,false),prepared);assert.equal(transform(prepared,true),before);
});
