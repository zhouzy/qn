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

    var EOL = (process.platform === 'win32' ? '\r\n' : '\n');
    var _rootPath = config.rootPath;//文件根目录
    var tempFileName = "qnResource.temp";

    var _getFileMd5Code = function(file,_cb){
        console.log("计算资源文件:[%s]哈希值",file);
        var stream = fs.createReadStream(file);
        var fsHash = crypto.createHash('md5');

        stream.on('data', function(d) {
            fsHash.update(d);
        });

        stream.on('end', function() {
            var md5 = fsHash.digest('hex');
            md5 = md5.substring(md5.length - 8);
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
        var text = fs.readFileSync(relFile, 'utf8');
        // 将文件按行拆成数组
        var arr = text.split(/\r?\n/);
        arr.forEach(function(line,index){
            if(line.indexOf("/" + oldFileName) >= 0){
                console.log("替换%s文件第%s行",relFile,index);
                arr[index] =  _updateLink(line,oldFileName,fileName);
            }
        });
        try{
            var fileStream = arr.join(EOL);
            fs.writeFileSync(relFile, fileStream, 'utf8');
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
            line = line.replace(/(script|link)\s/,"$1 data-origin-file=\"" + oldFileName + "\" ");
        }
        line = line.replace("/" + oldFileName,"/" + fileName);
        return line;
    };

    var _loadTemp = function(){
        try{
            var _temp = fs.readFileSync(path.join(process.cwd(),tempFileName),'utf-8');
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
        if(!_relativePath){
            return [];
        }
        if(_relativePath && Object.prototype.toString.call(_relativePath) != '[object Array]'){
            _relativePath = [_relativePath];
        }
        var promiseList = [];
        _relativePath.forEach(function(retPath){
            var files = fs.readdirSync(path.join(_rootPath + retPath));
            files.forEach(function(filename){
                var _resource = {};
                var _defer = Q.defer();
                promiseList.push(_defer.promise);
                fs.stat(path.join(_rootPath,retPath,filename), function (err, stats) {
                    if (err) throw err;
                    if (stats.isFile()){
                        _resource.originFileName = filename;
                        _resource.path = retPath;
                        console.log("读取到文件信息:%s",JSON.stringify(_resource));
                        _array.push(_resource);
                        _defer.resolve(_resource);
                    }
                    else if (stats.isDirectory()) {
                        _defer.resolve(Q.all(_findFileInPath(path.join(retPath,filename),_array)));
                    }
                });
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
                    console.log("%s文件引用了该文件",_f);
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
            _fileList.forEach(function(fileItem,_index){
                var _originName = fileItem.originFileName,
                    _arr = _originName.split('\.'),
                    _fileName = _arr[0],
                    _suffixes = _arr[1],
                    _path = fileItem.path,
                    _file = path.join(_rootPath,_path,_originName),
                    _relFiles = fileItem.relFiles;
                _getFileMd5Code(_file,function(md5){
                    console.log("文件[%s]->[%s]",_originName,md5);
                    let _md5FileName = "qn_" + _fileName + "." + md5;
                    let _md5File = _file.replace(_fileName,_md5FileName);
                    _isModify(_md5File).then(function(isModify){
                        if(isModify){
                            console.log("[%s]文件已经修改,复制新文件", _fileName);
                            fs.writeFileSync(_md5File, fs.readFileSync(_file, 'utf8') , 'utf8');
                            var _oldName = _fileName;
                            if(_temp && _temp[_index]){
                                _oldName = _temp[_index]['qnResource'] || _fileName;
                            }
                            _fileList[_index]['qnResource'] = _md5FileName;
                            console.log("[%s]文件已经修改,替换所有引用了该资源文件的文件:%s",_originName,JSON.stringify(_relFiles));
                            if(_relFiles && _relFiles.length){
                                _relFiles.forEach(function(relFile){
                                    relFile = path.join(_rootPath,relFile);
                                    console.log(relFile + "->");
                                    _changeRel(relFile,_oldName + "." + _suffixes,_md5FileName + "." + _suffixes);
                                });
                            }
                            fs.writeFileSync(path.join(process.cwd(),tempFileName), JSON.stringify(_fileList).replace(/\,/g,","+EOL), 'utf8');
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

    let _getRollbackFileList = function() {
        // jsp文件
        let jspFiles = [];
        // 查询jsp文件
        return Q.all(_findFileInPath(config.relFileRoot, jspFiles)).then(() => {
            // 过滤所有非jsp文件
            jspFiles = jspFiles.filter(file => {
                return file.originFileName.indexOf('.jsp') >= 0;
            });

            return jspFiles;
        });
    };

    let _rollbackLink = function(line){
        // 正则
        const reg = /\/\w+\.\w+(\.css|\.js)/;
        const originReg = /data-origin-file="(\w+)/;

        if(line.indexOf('data-origin-file') >= 0){
            let originFile = originReg.exec(line)[1];
            line = line.replace(reg, `/${originFile.split('.')[0]}$1`);
        }
        
        return line;
    };

    let _rollbackRel = function(relFile){
        var text = fs.readFileSync(relFile, 'utf8');
        // 将文件按行拆成数组
        var arr = text.split(/\r?\n/);
        arr.forEach(function(line,index){
            arr[index] =  _rollbackLink(line);
        });
        try{
            var fileStream = arr.join(EOL);
            fs.writeFileSync(relFile, fileStream, 'utf8');
        }catch(e){
            console.dir(e);
        }
    };

    /**
     * [_rollbackFiles 回滚相应路径下文件内引用的资源文件]
     * @author Lesty
     * @return undefined
     */
    let _rollbackFiles = function() {
        const _rootPath = config.rootPath;
        _getRollbackFileList().then(jspFiles => {
            jspFiles.forEach(jspFile => {
                _rollbackRel(path.join(_rootPath, jspFile.path, jspFile.originFileName));
            });
        });
    };

    var _main = function(){
        var _fileList = config.fileList || {};
        if(config.autoMode){
            //扫描所有的resource文件，然后找出所有引用该文件的JSP文件
            var _arr = [];
            Q.all(_findFileInPath(config.resourceRoot,_arr)).then(function(){
                _arr = _arr.filter(el => el.originFileName.indexOf('qn_') < 0);
                console.log("一共扫描到的%s个资源文件",_arr.length);
                var _relArr = [];
                Q.all(_findFileInPath(config.relFileRoot,_relArr)).then(function(){
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
    };

    // 读取命令行参数
    let cmd = process.argv[2];
    if(cmd === '--rollback') { // 回滚
        console.log('正在回滚···');
        _rollbackFiles();
        return 1;
    }

    _main();
})();
