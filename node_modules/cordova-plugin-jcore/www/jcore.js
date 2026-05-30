var exec = require('cordova/exec')

exports.coolMethod = function (arg0, success, error) {
  exec(success, error, 'jcore', 'coolMethod', [arg0])
}
module.exports = {
     testCountryCode: function (code) {
         if(device.platform === "Android"){
              exec(null, null, "JCorePlugin", 'testCountryCode', [code]);
            }
        },
        setAuth: function (enable) {
            if(device.platform === "Android"){
              exec(null, null, "JCorePlugin", 'setAuth', [enable]);
            }
        },
         enableAutoWakeup: function (enable) {
            if(device.platform === "Android"){
              exec(null, null, "JCorePlugin", 'enableAutoWakeup', [enable]);
            }
        }
}