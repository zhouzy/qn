/**
 * Created by zhouzhongyu on 2017/5/24.
 */
let crypto = require('crypto');
let fs = require('fs');
let config = require('./qn-config.json');
let Q = require('q');
let path = require('path');

(function(){
    const EOL = (process.platform === 'win32' ? '\r\n' : '\n');
    const _rootPath = config.rootPath;//文件根目录
    const tempFileName = "_qn_temp.log";
    const resourceFilePrefix = "_qn_";

    let _getFileMd5Code = function(file,_cb){
        let stream = fs.createReadStream(file);
        let fsHash = crypto.createHash('md5');

        stream.on('data', function(d) {
            fsHash.update(d);
        });

        stream.on('end', function() {
            var md5 = fsHash.digest('hex');
            md5 = md5.substring(md5.length - 8);
            _cb && _cb(md5);
        });
    };

    let _isModify = function(file){
        let defer = Q.defer();
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
    let _changeRel = function(relFile,relativeOldFileName,relativeFileName){
        var text = fs.readFileSync(relFile, 'utf8');
        // 将文件按行拆成数组
        var arr = text.split(/\r?\n/);
        let oldFileName = relativeOldFileName.split("/");
        oldFileName = oldFileName[oldFileName.length-1];

        let fileName = relativeFileName.split("/");
        fileName = fileName[fileName.length-1];

        arr.forEach(function(line,index){
            if(line.indexOf("/" + relativeOldFileName) >= 0){
                console.log("\t\t替换%s文件第%s行",relFile,index);
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
    let _updateLink = function(line,oldFileName,fileName){
        line = line.replace("/" + oldFileName,"/" + fileName);
        if(line.indexOf('data-origin-file') < 0){
            line = line.replace(/(script|link)\s/,"$1 data-origin-file=\"" + oldFileName + "\" ");
        }
        return line;
    };

    let _loadTemp = function(){
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
    let _findFileInPath = function(_relativePath,_array){
        if(!_relativePath){
            return [];
        }
        if(_relativePath && Object.prototype.toString.call(_relativePath) !== '[object Array]'){
            _relativePath = [_relativePath];
        }
        let promiseList = [];
        _relativePath.forEach(function(retPath){
            let files = fs.readdirSync(path.join(_rootPath + retPath));
            files.forEach(function(filename){
                let _resource = {};
                let _defer = Q.defer();
                promiseList.push(_defer.promise);
                fs.stat(path.join(_rootPath,retPath,filename), function (err, stats) {
                    if (err) throw err;
                    if (stats.isFile()){
                        _resource.originFileName = filename;
                        _resource.path = retPath.replace(/\\/g,"/");
                        console.log("\t取到文件:%s",JSON.stringify(_resource));
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
    let _isRelTheFile = function(resource,htmlFile){
        if(!/.+\/$/.test(resource.path)){
            resource.path += "/";
        }
        let _originFile = resource.path + resource.originFileName;

        if(_originFile){
            try{
                let _f = path.join(_rootPath,htmlFile.path,htmlFile.originFileName);
                console.log("\t读取文件：%s",_f);
                let fileStream = fs.readFileSync(_f,"UTF-8");
                let match = fileStream.match(_originFile);
                if(match){
                    console.log("\t[%s]引用了该文件",_f);
                }
                return !!match;
            }
            catch(e){
                console.error("\t读取文件失败!");
                return false;
            }
        }
    };

    /**
     * 从配置文件中，依次读取配置的文件，计算MD5值
     * 如果当前目录下存在相同MD5值的文件，则表示未改动，跳过
     * 如果不存在相同MD5值的文件，表示有改动，则在同目录下生成重命名后的文件，并修改引用的JSP文件
     */
    let handleResource = function(_fileList){
        console.log("2.开始处理文件，配置为:%s",JSON.stringify(_fileList));
        try{
            let _rootPath = config.rootPath,
                _temp = _loadTemp();
            _fileList.forEach(function(fileItem,_index){
                let _originName = fileItem.originFileName,
                    _arr = _originName.split('\.'),
                    _fileName = _arr[0],
                    _suffixes = _arr[1],
                    _path = fileItem.path,
                    _file = path.join(_rootPath,_path,_originName),
                    _relFiles = fileItem.relFiles;
                _getFileMd5Code(_file,function(md5){
                    console.log("\t文件 [%s] 哈希值:%s ",_originName,md5);
                    let _md5FileName = resourceFilePrefix + _fileName + "." + md5;
                    let _md5File = _file.replace(_fileName,_md5FileName);
                    let _oldName = _fileName;
                    _isModify(_md5File).then(function(isModify){
                        if(isModify){
                            console.log("\t[%s] 已经修改,生成新文件", _fileName);
                            fs.writeFileSync(_md5File, fs.readFileSync(_file, 'utf8') , 'utf8');
                            if(_temp && _temp[_index]){
                                _oldName = _temp[_index]['qnResource'] || _fileName;
                            }
                            _fileList[_index]['qnResource'] = _md5FileName;
                        }
                        else{
                            console.log("\t[%s] 哈希文件已经存在",_md5File);
                        }
                        console.log("\t处理引用了该文件的HTML文件:%s",JSON.stringify(_relFiles));
                        if(_relFiles && _relFiles.length){
                            let _relativePath = _path;
                            if(!/.+\/$/.test(_relativePath)){
                                _relativePath += "/";
                            }
                            let _relativeOriginFile = _relativePath + _oldName + "." + _suffixes;
                            let _relativeNewFile = _relativePath + _md5FileName + "." + _suffixes;

                            _relFiles.forEach(function(relFile){
                                relFile = path.join(_rootPath,relFile);
                                _changeRel(relFile,_relativeOriginFile,_relativeNewFile);
                            });
                        }
                        fs.writeFileSync(path.join(process.cwd(),tempFileName), JSON.stringify(_fileList).replace(/\,/g,","+EOL), 'utf8');
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
		console.info("读取JSP文件:");
        return Q.all(_findFileInPath(config.relFileRoot, jspFiles)).then(() => {
            // 过滤所有非jsp文件
            jspFiles = jspFiles.filter(file => {
                return file.originFileName.indexOf('.jsp') >= 0;
            });
            return jspFiles;
        });
    };

    let _rollbackLink = function(line,lineNumber){
        const reg = /\/_qn_[\w.-]+(\.\w+)/;
        const originReg = /data-origin-file="(\S+)\.\w+/;
        if(line.indexOf('data-origin-file') >= 0){
			console.info('\t\t\t重写引用地址');
			console.info('\t\t\t文件行数:%s',lineNumber);
			console.info('\t\t\t%s',line);
            let originFile = originReg.exec(line)[1];
            line = line.replace(reg, `/${originFile.split('.')[0]}$1`);
            line = line.replace(/\sdata-origin-file=\".+?\"\s/," ");
        }
        return line;
    };

    let _rollbackRel = function(relFile){
        console.log("\t\t解析文件:[%s]",relFile);
        let text = fs.readFileSync(relFile, 'utf8');
        // 将文件按行拆成数组
        let arr = text.split(/\r?\n/);
        arr.forEach(function(line,index){
            arr[index] =  _rollbackLink(line,index);
        });
        try{
            let fileStream = arr.join(EOL);
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
        let _resources = [];
        Q.all(_findFileInPath(config.resourceRoot,_resources)).then(function(){
        	let toDeleteFiles = [];
            _resources.forEach(file => {
                console.log(JSON.stringify(file));
                if(/^\_qn\_.+/.test(file.originFileName)){
                	toDeleteFiles.push(file);
                }
            });
            toDeleteFiles.forEach(file => {
            	_deleteFile(file);
			})
        });
    };

    let _deleteFile = function(fileInfo){
        if(!/.+\/$/.test(fileInfo.path)){
            fileInfo.path += "/";
        }
        let filePath = fileInfo.path + fileInfo.originFileName;
        console.warn("删除文件:" + filePath);
        fs.unlinkSync(filePath);
    };

    let _main = function(){
        console.log("开始打包资源文件====\n");
        let _fileList = config.fileList || {};
        if(config.autoMode){
            //扫描所有的resource文件，然后找出所有引用该文件的JSP文件
            let _resources = [];
            console.log("\t1.读取资源文件");
            Q.all(_findFileInPath(config.resourceRoot,_resources)).then(function(){
                _resources = _resources.filter(resource => resource.originFileName.indexOf(resourceFilePrefix) < 0);
                console.log("\t资源文件总数:%s\n",_resources.length);
                let _htmlFiles = [];
                console.log("\t读取HTML文件");
                Q.all(_findFileInPath(config.relFileRoot,_htmlFiles)).then(function(){
                    console.log("\tHTML文件总数:%s\n",_htmlFiles.length);
                    _resources.forEach(function(resource){
                        console.log("\t读取引用了[%s]的所有文件",path.join(resource.path + "/" + resource.originFileName));
                        _htmlFiles.forEach(function(htmlFile){
                            resource.relFiles = resource.relFiles || [];
                            if(_isRelTheFile(resource,htmlFile)){
                                resource.relFiles.push(path.join(htmlFile.path,htmlFile.originFileName));
                            }
                        });
                        console.log("\t引用 [%s] 文件总数:%s\n",resource.originFileName,resource.relFiles.length);
                    });
                    handleResource(_resources);
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
        console.log('开始回滚');
        _rollbackFiles();
        return 1;
    }

    _main();
})();
