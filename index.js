/**
 * Created by zhouzhongyu on 2017/5/24.
 */
var crypto = require('crypto');
var fs = require('fs');
var config = require('qn-config.json');
var Q = require('q');
(function(){
    'use static';
    var _rootPath = "";//文件根目录
    var _getFileMd5Code = function(file,_cb){
        //从文件创建一个可读流
        var stream = fs.createReadStream(_rootPath + file);
        var fsHash = crypto.createHash('md5');

        stream.on('data', function(d) {
            fsHash.update(d);
        });

        stream.on('end', function() {
            var md5 = fsHash.digest('hex');
            console.log("文件的MD5是：%s", md5);
            _cb && _cb(md5);
        });
    };

    var _isModify = function(file){
        var defer = Q.defer();
        fs.exists(file,function(isExist){
            Q.resolve(isExist);
        });
        return defer.promise;
    };

    /**
     * 从配置文件中，依次读取配置的文件，计算MD5值
     * 如果当前目录下存在相同MD5值的文件，则表示未改动，跳过
     * 如果不存在相同MD5值的文件，表示有改动，则在同目录下生成重命名后的文件，并修改引用的JSP文件
     */
    var _main = function(){
        var _rootPath = config.rootPath,
            _fileList = config.fileList;
        _fileList.forEach(function(fileItem){
            var _fileName = fileItem.originFileName,
                _path = fileItem.path,
                _file = _rootPath + _path + _fileName;
            _getFileMd5Code(_file,function(md5){
                _isModify(md5).then(function(isModify){
                    if(isModify){

                        var _txt = fs.readFileSync(_file, 'utf8');
                        fs.writeFileSync(fileName, _txt, 'utf8');
                    }
                });
            });
        });
    };
})();
