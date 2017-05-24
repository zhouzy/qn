/**
 * Created by zhouzhongyu on 2017/5/24.
 */
var crypto = require('crypto');
var fs = require('fs');
(function(){
    'use static';
    var _rootPath = "";//文件根目录
    var _getFileMd5Code = function(file){
        //从文件创建一个可读流
        var stream = fs.createReadStream(_rootPath + file);
        var fsHash = crypto.createHash('md5');

        stream.on('data', function(d) {
            fsHash.update(d);
        });

        stream.on('end', function() {
            var md5 = fsHash.digest('hex');
            console.log("文件的MD5是：%s", md5);
        });
    };
    /**
     * 从配置文件中，依次读取配置的文件路径
     * 每一项记录原始文件名、上次MD5文件名、当前文件名
     *
     * 读取JSP目录下的所有JSP文件，对其中所有引用的JS和CSS替换成最新的MD5文件名
     */
})();
