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
        console.log("计算资源文件:[%s]哈希值",file);
        var stream = fs.createReadStream(file);
        var fsHash = crypto.createHash('md5');

        stream.on('data', function(d) {
            fsHash.update(d);
        });

        stream.on('end', function() {
            var md5 = fsHash.digest('hex');
            _cb && _cb(md5);
        });
    };

    var _isModify = function(file){
        console.log("判断文件[%s]是否存在",file);
        var defer = Q.defer();
        fs.exists(file,function(isExist){
            defer.resolve(!isExist);
        });
        return defer.promise;
    };

    /**
     * 修改引用文件引用资源地址
     * @param relFile
     * @param oldFileName
     * @param fileName
     * @private
     */
    var _changeRel = function(relFile,oldFileName,fileName){
        var EOL = (process.platform === 'win32' ? '\r\n' : '\n');
        var text = fs.readFileSync(relFile, 'utf8');
        // 将文件按行拆成数组
        var arr = text.split(/\r?\n/);
        arr.forEach(function(line,index){
            if(line.indexOf(oldFileName) >= 0){
                console.log("替换源文件第" + index + "行");
                arr[index] =  _updateLink(line,oldFileName,fileName);
            }
        });
        try{
            fs.writeFileSync(relFile, arr.join(EOL), 'utf8');
        }catch(e){
            console.dir(e);
        }
    };

    /**
     * 修改文件中对资源文件的引用，如果是第一次替换，保存一个原始文件名到标签上
     * @param line
     * @param oldFileName
     * @param fileName
     * @private
     */
    var _updateLink = function(line,oldFileName,fileName){
        if(line.indexOf('data-origin-file') < 0){
            line = line.replace(/(script|link)\s/,"$1 data-origin-file=" + oldFileName + " ");
        }
        line = line.replace(oldFileName,fileName);
        return line;
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
     * 搜索出所有的资源文件
     * @param _relativePath
     * @param _array
     * @returns {Array}
     * @private
     */
    var _findFileInPath = function(_relativePath,_array){
        var files = fs.readdirSync(path.join(_rootPath + _relativePath));
        var promiseList = [];
        files.forEach(function (filename) {
            var _resource = {};
            var _defer = Q.defer();
            promiseList.push(_defer.promise);
            fs.stat(path.join(_rootPath,_relativePath,filename), function (err, stats) {
                if (err) throw err;
                if (stats.isFile()){
                    _resource.originFileName = filename;
                    _resource.path = _relativePath;
                    _array.push(_resource);
                    _defer.resolve(_resource);
                    console.log("读取到文件信息:%s",JSON.stringify(_resource));
                }
                else if (stats.isDirectory()) {
                    _defer.resolve(Q.all(_findFileInPath(path.join(_relativePath,filename),_array)));
                }
            });
        });
        return promiseList;
    };

    /**
     * 是否引用了该文件
     * @param resource
     * @param relFile
     * @private
     */
    var _isRelTheFile = function(resource,relFile){
        var _originFile = resource.originFileName;
        if(_originFile){
            try{
                var _f = path.join(_rootPath,relFile.path,relFile.originFileName);
                console.log("读取文件：%s",_f);
                var fileStream = fs.readFileSync(_f,"UTF-8");
                var match = fileStream.match(_originFile);
                if(match){
                    console.log("%s文件引用了该文件",relFile);
                }
                return !!match;
            }
            catch(e){
                console.error("读取文件失败!!!");
                return false;
            }
        }
    };

    /**
     * 从配置文件中，依次读取配置的文件，计算MD5值
     * 如果当前目录下存在相同MD5值的文件，则表示未改动，跳过
     * 如果不存在相同MD5值的文件，表示有改动，则在同目录下生成重命名后的文件，并修改引用的JSP文件
     */
    var handleResource = function(_fileList){
        console.log("开始处理文件，配置为:%s",JSON.stringify(_fileList));
        try{
            var _rootPath = config.rootPath,
                _temp = _loadTemp();
            _fileList.forEach(function(fileItem){
                var _originName = fileItem.originFileName,
                    _arr = _originName.split('\.'),
                    _fileName = _arr[0],
                    _suffixes = _arr[1],
                    _path = fileItem.path,
                    _file = path.join(_rootPath,_path,_originName),
                    _relFiles = fileItem.relFiles;
                _getFileMd5Code(_file,function(md5){
                    console.log("文件[%s]->[%s]",_originName,md5);
                    var md5File = _file.replace(_fileName,md5);
                    _isModify(md5File).then(function(isModify){
                        if(isModify){
                            console.log("[%s]文件已经修改,替换引用的文件",_originName);
                            var _txt = fs.readFileSync(_file, 'utf8');
                            fs.writeFileSync(md5File, _txt, 'utf8');
                            var _oldName = _temp[_fileName] || _fileName;
                            //资源文件修改后，修改所有引用了该文件的JSP文件
                            console.log("替换引用的文件%s",JSON.stringify(_relFiles));
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
        }catch(e){
            console.error(e);
        }
    };
    var _main = function(){
        var _fileList = config.fileList || {};
        if(config.autoMode){
            //扫描所有的resource文件，然后找出所有引用该文件的JSP文件
            var _arr = [];
            Q.all(_findFileInPath(path.join(_rootPath,config.resourceRoot),_arr)).then(function(){
                console.log("一共扫描到的%s个资源文件",_arr.length);
                var _relArr = [];
                Q.all(_findFileInPath(path.join(_rootPath,config.relFileRoot),_relArr)).then(function(){
                    _arr.forEach(function(resource){
                        console.log("扫描所有引用了[%s]的文件开始",resource.originFileName);
                        _relArr.forEach(function(relFile){
                            if(_isRelTheFile(resource,relFile)){
                                resource.relFiles = resource.relFiles || [];
                                resource.relFiles.push(path.join(relFile.path,relFile.originFileName));
                            }
                        });
                        console.log("扫描所有引用了[%s]的文件结束，一共找到[%s]个文件",resource.originFileName,_relArr.length);
                    });
                    handleResource(_arr);
                });
            });
        }
        else{
            handleResource(_fileList);
        }
        console.log("end===");
    };
    _main();
})();
