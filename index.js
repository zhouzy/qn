/**
 * Created by zhouzhongyu on 2017/5/24.
 */
var crypto = require('crypto');
var fs = require('fs');
var config = require('./qn-config.json');
var Q = require('q');
var path = require('path');
(function(){
    'use static';
    var _rootPath = config.rootPath;//文件根目录
    var _getFileMd5Code = function(file,_cb){
        //从文件创建一个可读流
        var stream = fs.createReadStream(file);
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
        console.log("判断文件[" + file + "]是否存在");
        var defer = Q.defer();
        fs.exists(file,function(isExist){
            defer.resolve(!isExist);
        });
        return defer.promise;
    };

    var _changeRel = function(relFile,oldFileName,fileName){
        console.log(relFile);
        console.log(oldFileName);
        console.log(fileName);
        var EOL = (process.platform === 'win32' ? '\r\n' : '\n');
        var text = fs.readFileSync(relFile, 'utf8');
        // 将文件按行拆成数组
        var arr = text.split(/\r?\n/);
        arr = arr.map(function (line,index){
            if(line.indexOf(oldFileName) >= 0){
                console.log("替换源文件第" + index + "行");
            }
            return line.replace(oldFileName,fileName);
        });
        try{
            fs.writeFileSync(relFile, arr.join(EOL), 'utf8');
        }catch(e){
            console.dir(e);
        }
    };

    var _loadTemp = function(){
        try{
            var _temp = fs.readFileSync(path.join(process.cwd(),".qn_temp"),'utf-8');
            if(_temp){
                return JSON.parse(_temp);
            }
            else{
                return {};
            }
        }catch(e){
            return {};
        }
    };

    /**
     * 从配置文件中，依次读取配置的文件，计算MD5值
     * 如果当前目录下存在相同MD5值的文件，则表示未改动，跳过
     * 如果不存在相同MD5值的文件，表示有改动，则在同目录下生成重命名后的文件，并修改引用的JSP文件
     */
    var _main = function(){
        var _rootPath = config.rootPath,
            _fileList = config.fileList,
            _temp = _loadTemp();

        _fileList.forEach(function(fileItem){
            var _originName = fileItem.originFileName,
                _arr = _originName.split('\.'),
                _fileName = _arr[0],
                _suffixes = _arr[1],
                _path = fileItem.path,
                _file = path.join(_rootPath,_path,_originName),
                _relFiles = fileItem.relFiles;

            console.log("计算资源文件:[" + _file + "]哈希值");
            _getFileMd5Code(_file,function(md5){
                console.log("哈希值:" + md5);
                var md5File = _file.replace(_fileName,md5);
                _isModify(md5File).then(function(isModify){
                    if(isModify){
                        console.log("文件有改动");
                        var _txt = fs.readFileSync(_file, 'utf8');
                        fs.writeFileSync(md5File, _txt, 'utf8');
                        var _oldName = _temp[_fileName] || _fileName;
                        //资源文件修改后，修改所有引用了该文件的JSP文件
                        console.log("修改引用的文件");
                        _relFiles.forEach(function(relFile){
                            relFile = path.join(_rootPath,relFile);
                            console.log(relFile + "->");
                            _changeRel(relFile,_oldName + "." + _suffixes,md5 + "." + _suffixes);
                            _temp[_fileName] = md5;
                            fs.writeFileSync(process.cwd() + '/.qn_temp', JSON.stringify(_temp), 'utf8');
                        });
                    }
                    else{
                        console.log("该文件未改动");
                    }
                });
            });
        });
    };
    _main();
})();
