// 用户同意隐私后初始化；示例不预埋AppKey，不默认启用采集开关。
function initUpgradeExample() {
  JPush.init();
  document.addEventListener('jpush.onCommandResult', function(event) {
    if (event.command === 2013) { /* 按原生payload读取 event.commandData，不强制JSON转换 */ }
  });
}
