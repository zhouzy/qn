webpackJsonp([2,15],{

/***/ 15:
/***/ (function(module, exports, __webpack_require__) {

/*
  MIT License http://www.opensource.org/licenses/mit-license.php
  Author Tobias Koppers @sokra
  Modified by Evan You @yyx990803
*/

var hasDocument = typeof document !== 'undefined'

if (typeof DEBUG !== 'undefined' && DEBUG) {
  if (!hasDocument) {
    throw new Error(
    'vue-style-loader cannot be used in a non-browser environment. ' +
    "Use { target: 'node' } in your Webpack config to indicate a server-rendering environment."
  ) }
}

var listToStyles = __webpack_require__(98)

/*
type StyleObject = {
  id: number;
  parts: Array<StyleObjectPart>
}

type StyleObjectPart = {
  css: string;
  media: string;
  sourceMap: ?string
}
*/

var stylesInDom = {/*
  [id: number]: {
    id: number,
    refs: number,
    parts: Array<(obj?: StyleObjectPart) => void>
  }
*/}

var head = hasDocument && (document.head || document.getElementsByTagName('head')[0])
var singletonElement = null
var singletonCounter = 0
var isProduction = false
var noop = function () {}

// Force single-tag solution on IE6-9, which has a hard limit on the # of <style>
// tags it will allow on a page
var isOldIE = typeof navigator !== 'undefined' && /msie [6-9]\b/.test(navigator.userAgent.toLowerCase())

module.exports = function (parentId, list, _isProduction) {
  isProduction = _isProduction

  var styles = listToStyles(parentId, list)
  addStylesToDom(styles)

  return function update (newList) {
    var mayRemove = []
    for (var i = 0; i < styles.length; i++) {
      var item = styles[i]
      var domStyle = stylesInDom[item.id]
      domStyle.refs--
      mayRemove.push(domStyle)
    }
    if (newList) {
      styles = listToStyles(parentId, newList)
      addStylesToDom(styles)
    } else {
      styles = []
    }
    for (var i = 0; i < mayRemove.length; i++) {
      var domStyle = mayRemove[i]
      if (domStyle.refs === 0) {
        for (var j = 0; j < domStyle.parts.length; j++) {
          domStyle.parts[j]()
        }
        delete stylesInDom[domStyle.id]
      }
    }
  }
}

function addStylesToDom (styles /* Array<StyleObject> */) {
  for (var i = 0; i < styles.length; i++) {
    var item = styles[i]
    var domStyle = stylesInDom[item.id]
    if (domStyle) {
      domStyle.refs++
      for (var j = 0; j < domStyle.parts.length; j++) {
        domStyle.parts[j](item.parts[j])
      }
      for (; j < item.parts.length; j++) {
        domStyle.parts.push(addStyle(item.parts[j]))
      }
      if (domStyle.parts.length > item.parts.length) {
        domStyle.parts.length = item.parts.length
      }
    } else {
      var parts = []
      for (var j = 0; j < item.parts.length; j++) {
        parts.push(addStyle(item.parts[j]))
      }
      stylesInDom[item.id] = { id: item.id, refs: 1, parts: parts }
    }
  }
}

function listToStyles (parentId, list) {
  var styles = []
  var newStyles = {}
  for (var i = 0; i < list.length; i++) {
    var item = list[i]
    var id = item[0]
    var css = item[1]
    var media = item[2]
    var sourceMap = item[3]
    var part = { css: css, media: media, sourceMap: sourceMap }
    if (!newStyles[id]) {
      part.id = parentId + ':0'
      styles.push(newStyles[id] = { id: id, parts: [part] })
    } else {
      part.id = parentId + ':' + newStyles[id].parts.length
      newStyles[id].parts.push(part)
    }
  }
  return styles
}

function createStyleElement () {
  var styleElement = document.createElement('style')
  styleElement.type = 'text/css'
  head.appendChild(styleElement)
  return styleElement
}

function addStyle (obj /* StyleObjectPart */) {
  var update, remove
  var styleElement = document.querySelector('style[data-vue-ssr-id~="' + obj.id + '"]')
  var hasSSR = styleElement != null

  // if in production mode and style is already provided by SSR,
  // simply do nothing.
  if (hasSSR && isProduction) {
    return noop
  }

  if (isOldIE) {
    // use singleton mode for IE9.
    var styleIndex = singletonCounter++
    styleElement = singletonElement || (singletonElement = createStyleElement())
    update = applyToSingletonTag.bind(null, styleElement, styleIndex, false)
    remove = applyToSingletonTag.bind(null, styleElement, styleIndex, true)
  } else {
    // use multi-style-tag mode in all other cases
    styleElement = styleElement || createStyleElement()
    update = applyToTag.bind(null, styleElement)
    remove = function () {
      styleElement.parentNode.removeChild(styleElement)
    }
  }

  if (!hasSSR) {
    update(obj)
  }

  return function updateStyle (newObj /* StyleObjectPart */) {
    if (newObj) {
      if (newObj.css === obj.css &&
          newObj.media === obj.media &&
          newObj.sourceMap === obj.sourceMap) {
        return
      }
      update(obj = newObj)
    } else {
      remove()
    }
  }
}

var replaceText = (function () {
  var textStore = []

  return function (index, replacement) {
    textStore[index] = replacement
    return textStore.filter(Boolean).join('\n')
  }
})()

function applyToSingletonTag (styleElement, index, remove, obj) {
  var css = remove ? '' : obj.css

  if (styleElement.styleSheet) {
    styleElement.styleSheet.cssText = replaceText(index, css)
  } else {
    var cssNode = document.createTextNode(css)
    var childNodes = styleElement.childNodes
    if (childNodes[index]) styleElement.removeChild(childNodes[index])
    if (childNodes.length) {
      styleElement.insertBefore(cssNode, childNodes[index])
    } else {
      styleElement.appendChild(cssNode)
    }
  }
}

function applyToTag (styleElement, obj) {
  var css = obj.css
  var media = obj.media
  var sourceMap = obj.sourceMap

  if (media) {
    styleElement.setAttribute('media', media)
  }

  if (sourceMap) {
    // https://developer.chrome.com/devtools/docs/javascript-debugging
    // this makes source maps inside style tags work properly in Chrome
    css += '\n/*# sourceURL=' + sourceMap.sources[0] + ' */'
    // http://stackoverflow.com/a/26603875
    css += '\n/*# sourceMappingURL=data:application/json;base64,' + btoa(unescape(encodeURIComponent(JSON.stringify(sourceMap)))) + ' */'
  }

  if (styleElement.styleSheet) {
    styleElement.styleSheet.cssText = css
  } else {
    while (styleElement.firstChild) {
      styleElement.removeChild(styleElement.firstChild)
    }
    styleElement.appendChild(document.createTextNode(css))
  }
}


/***/ }),

/***/ 174:
/***/ (function(module, exports, __webpack_require__) {

var META     = __webpack_require__(46)('meta')
  , isObject = __webpack_require__(13)
  , has      = __webpack_require__(16)
  , setDesc  = __webpack_require__(7).f
  , id       = 0;
var isExtensible = Object.isExtensible || function(){
  return true;
};
var FREEZE = !__webpack_require__(25)(function(){
  return isExtensible(Object.preventExtensions({}));
});
var setMeta = function(it){
  setDesc(it, META, {value: {
    i: 'O' + ++id, // object ID
    w: {}          // weak collections IDs
  }});
};
var fastKey = function(it, create){
  // return primitive with prefix
  if(!isObject(it))return typeof it == 'symbol' ? it : (typeof it == 'string' ? 'S' : 'P') + it;
  if(!has(it, META)){
    // can't set metadata to uncaught frozen object
    if(!isExtensible(it))return 'F';
    // not necessary to add metadata
    if(!create)return 'E';
    // add missing metadata
    setMeta(it);
  // return object ID
  } return it[META].i;
};
var getWeak = function(it, create){
  if(!has(it, META)){
    // can't set metadata to uncaught frozen object
    if(!isExtensible(it))return true;
    // not necessary to add metadata
    if(!create)return false;
    // add missing metadata
    setMeta(it);
  // return hash weak collections IDs
  } return it[META].w;
};
// add metadata on freeze-family methods calling
var onFreeze = function(it){
  if(FREEZE && meta.NEED && isExtensible(it) && !has(it, META))setMeta(it);
  return it;
};
var meta = module.exports = {
  KEY:      META,
  NEED:     false,
  fastKey:  fastKey,
  getWeak:  getWeak,
  onFreeze: onFreeze
};

/***/ }),

/***/ 175:
/***/ (function(module, exports, __webpack_require__) {

// 7.2.2 IsArray(argument)
var cof = __webpack_require__(24);
module.exports = Array.isArray || function isArray(arg){
  return cof(arg) == 'Array';
};

/***/ }),

/***/ 345:
/***/ (function(module, exports, __webpack_require__) {


/* styles */
__webpack_require__(539)

var Component = __webpack_require__(3)(
  /* script */
  __webpack_require__(416),
  /* template */
  __webpack_require__(506),
  /* scopeId */
  "data-v-28e6d8df",
  /* cssModules */
  null
)
Component.options.__file = "D:\\IDEAWorkDir\\CCOD\\BLB\\ems\\WebRoot\\vue-static\\src\\list-field-config\\edit-custom-field.vue"
if (Component.esModule && Object.keys(Component.esModule).some(function (key) {return key !== "default" && key !== "__esModule"})) {console.error("named exports are not supported in *.vue files.")}
if (Component.options.functional) {console.error("[vue-loader] edit-custom-field.vue: functional components are not supported with templates, they should use render functions.")}

/* hot reload */
if (false) {(function () {
  var hotAPI = require("vue-hot-reload-api")
  hotAPI.install(require("vue"), false)
  if (!hotAPI.compatible) return
  module.hot.accept()
  if (!module.hot.data) {
    hotAPI.createRecord("data-v-28e6d8df", Component.options)
  } else {
    hotAPI.reload("data-v-28e6d8df", Component.options)
  }
})()}

module.exports = Component.exports


/***/ }),

/***/ 346:
/***/ (function(module, exports, __webpack_require__) {


/* styles */
__webpack_require__(533)

var Component = __webpack_require__(3)(
  /* script */
  __webpack_require__(418),
  /* template */
  __webpack_require__(501),
  /* scopeId */
  null,
  /* cssModules */
  null
)
Component.options.__file = "D:\\IDEAWorkDir\\CCOD\\BLB\\ems\\WebRoot\\vue-static\\src\\list-field-config\\list-field-config.vue"
if (Component.esModule && Object.keys(Component.esModule).some(function (key) {return key !== "default" && key !== "__esModule"})) {console.error("named exports are not supported in *.vue files.")}
if (Component.options.functional) {console.error("[vue-loader] list-field-config.vue: functional components are not supported with templates, they should use render functions.")}

/* hot reload */
if (false) {(function () {
  var hotAPI = require("vue-hot-reload-api")
  hotAPI.install(require("vue"), false)
  if (!hotAPI.compatible) return
  module.hot.accept()
  if (!module.hot.data) {
    hotAPI.createRecord("data-v-1788c522", Component.options)
  } else {
    hotAPI.reload("data-v-1788c522", Component.options)
  }
})()}

module.exports = Component.exports


/***/ }),

/***/ 347:
/***/ (function(module, exports, __webpack_require__) {


/* styles */
__webpack_require__(560)

var Component = __webpack_require__(3)(
  /* script */
  __webpack_require__(419),
  /* template */
  __webpack_require__(526),
  /* scopeId */
  null,
  /* cssModules */
  null
)
Component.options.__file = "D:\\IDEAWorkDir\\CCOD\\BLB\\ems\\WebRoot\\vue-static\\src\\list-field-config\\select-custom-field.vue"
if (Component.esModule && Object.keys(Component.esModule).some(function (key) {return key !== "default" && key !== "__esModule"})) {console.error("named exports are not supported in *.vue files.")}
if (Component.options.functional) {console.error("[vue-loader] select-custom-field.vue: functional components are not supported with templates, they should use render functions.")}

/* hot reload */
if (false) {(function () {
  var hotAPI = require("vue-hot-reload-api")
  hotAPI.install(require("vue"), false)
  if (!hotAPI.compatible) return
  module.hot.accept()
  if (!module.hot.data) {
    hotAPI.createRecord("data-v-f05ecaa6", Component.options)
  } else {
    hotAPI.reload("data-v-f05ecaa6", Component.options)
  }
})()}

module.exports = Component.exports


/***/ }),

/***/ 360:
/***/ (function(module, exports, __webpack_require__) {

var Component = __webpack_require__(3)(
  /* script */
  __webpack_require__(361),
  /* template */
  __webpack_require__(362),
  /* scopeId */
  null,
  /* cssModules */
  null
)
Component.options.__file = "D:\\IDEAWorkDir\\CCOD\\BLB\\ems\\WebRoot\\vue-static\\src\\lib-components\\page-header.vue"
if (Component.esModule && Object.keys(Component.esModule).some(function (key) {return key !== "default" && key !== "__esModule"})) {console.error("named exports are not supported in *.vue files.")}
if (Component.options.functional) {console.error("[vue-loader] page-header.vue: functional components are not supported with templates, they should use render functions.")}

/* hot reload */
if (false) {(function () {
  var hotAPI = require("vue-hot-reload-api")
  hotAPI.install(require("vue"), false)
  if (!hotAPI.compatible) return
  module.hot.accept()
  if (!module.hot.data) {
    hotAPI.createRecord("data-v-0ecb5501", Component.options)
  } else {
    hotAPI.reload("data-v-0ecb5501", Component.options)
  }
})()}

module.exports = Component.exports


/***/ }),

/***/ 361:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


module.exports = {
  props: ['topTitle']
};

/***/ }),

/***/ 362:
/***/ (function(module, exports, __webpack_require__) {

module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
  return _c('header', {
    staticClass: "tele-activity__right-part-header"
  }, [_c('div', {
    staticClass: "tele-activity__right-part-header-sidebar"
  }, [_c('span', [_vm._v(_vm._s(_vm.topTitle))]), _vm._v(" "), _vm._t("topContent")], 2)])
},staticRenderFns: []}
module.exports.render._withStripped = true
if (false) {
  module.hot.accept()
  if (module.hot.data) {
     require("vue-hot-reload-api").rerender("data-v-0ecb5501", module.exports)
  }
}

/***/ }),

/***/ 377:
/***/ (function(module, exports, __webpack_require__) {

module.exports = { "default": __webpack_require__(378), __esModule: true };

/***/ }),

/***/ 378:
/***/ (function(module, exports, __webpack_require__) {

__webpack_require__(88);
__webpack_require__(380);
module.exports = __webpack_require__(6).Array.from;

/***/ }),

/***/ 379:
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var $defineProperty = __webpack_require__(7)
  , createDesc      = __webpack_require__(26);

module.exports = function(object, index, value){
  if(index in object)$defineProperty.f(object, index, createDesc(0, value));
  else object[index] = value;
};

/***/ }),

/***/ 380:
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var ctx            = __webpack_require__(18)
  , $export        = __webpack_require__(23)
  , toObject       = __webpack_require__(99)
  , call           = __webpack_require__(104)
  , isArrayIter    = __webpack_require__(103)
  , toLength       = __webpack_require__(61)
  , createProperty = __webpack_require__(379)
  , getIterFn      = __webpack_require__(107);

$export($export.S + $export.F * !__webpack_require__(105)(function(iter){ Array.from(iter); }), 'Array', {
  // 22.1.2.1 Array.from(arrayLike, mapfn = undefined, thisArg = undefined)
  from: function from(arrayLike/*, mapfn = undefined, thisArg = undefined*/){
    var O       = toObject(arrayLike)
      , C       = typeof this == 'function' ? this : Array
      , aLen    = arguments.length
      , mapfn   = aLen > 1 ? arguments[1] : undefined
      , mapping = mapfn !== undefined
      , index   = 0
      , iterFn  = getIterFn(O)
      , length, result, step, iterator;
    if(mapping)mapfn = ctx(mapfn, aLen > 2 ? arguments[2] : undefined, 2);
    // if object isn't iterable or it's array with default iterator - use simple case
    if(iterFn != undefined && !(C == Array && isArrayIter(iterFn))){
      for(iterator = iterFn.call(O), result = new C; !(step = iterator.next()).done; index++){
        createProperty(result, index, mapping ? call(iterator, mapfn, [step.value, index], true) : step.value);
      }
    } else {
      length = toLength(O.length);
      for(result = new C(length); length > index; index++){
        createProperty(result, index, mapping ? mapfn(O[index], index) : O[index]);
      }
    }
    result.length = index;
    return result;
  }
});


/***/ }),

/***/ 416:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
    value: true
});

var _set = __webpack_require__(429);

var _set2 = _interopRequireDefault(_set);

var _from = __webpack_require__(377);

var _from2 = _interopRequireDefault(_from);

var _pageHeader = __webpack_require__(360);

var _pageHeader2 = _interopRequireDefault(_pageHeader);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

exports.default = {
    props: ['topTitle'],

    created: function created() {
        var _this = this;

        var queryObj = this.$route.query;

        this.changeType = queryObj.changeType;

        if (queryObj.changeType === 'add') {
            this.fieldType = queryObj.fieldType;

            if (this.fieldType === '10') {
                this.fieldItemArr = ['yyyy/MM/dd hh:mm:ss'];
            }
        } else {
            this.fieldKey = queryObj.fieldKey;

            $.post(ACT_CONFIG.ORIGIN_URL + '/namelist/getNameListFieldInfo', {
                field: this.fieldKey
            }).then(function (data) {
                if (!data.success) {
                    notice.danger(data.msg);
                    return;
                }

                var rows = data.rows;

                _this.fieldType = rows.componentType;
                _this.fieldItemArr = rows.candidateValue || [''];
                _this.commonField.name = rows.name;
                _this.commonField.isRequired = rows.isRequired;
                _this.commonField.remark = rows.remark;
            });
        }
    },
    data: function data() {
        return {
            FIELD_TYPE_MAP: window.ACT_CONFIG.FIELD_TYPE_MAP,

            changeType: 'add',

            fieldType: '1',

            fieldKey: '',

            commonField: {
                name: '',
                isRequired: false,
                remark: ''
            },

            fieldItemArr: ['']
        };
    },
    computed: {
        fieldTypeName: function fieldTypeName() {
            return this.FIELD_TYPE_MAP[this.fieldType].name;
        },

        fieldTypeDesc: function fieldTypeDesc() {
            return this.FIELD_TYPE_MAP[this.fieldType].desc;
        },

        cancelHref: function cancelHref() {
            if (this.changeType === 'add') {
                return '#/list-field-config/select-custom-field';
            } else {
                return '#/list-field-config';
            }
        },

        submitUrl: function submitUrl() {
            if (this.changeType === 'add') {
                return location.origin + '/namelist/addDefinedField';
            } else {
                return location.origin + '/namelist/goEdit/' + this.fieldKey;
            }
        }
    },
    methods: {
        uniqueArr: function uniqueArr(arr) {
            return (0, _from2.default)(new _set2.default(arr));
        },

        removeEmptyValue: function removeEmptyValue(arr) {
            return arr.filter(function (item) {
                return item.trim() !== '';
            });
        },

        checkField: function checkField(fieldTypeDesc) {
            if (fieldTypeDesc === 'select' || fieldTypeDesc === 'checkbox') {
                this.fieldItemArr = this.removeEmptyValue(this.fieldItemArr);

                if (this.fieldItemArr.length === 0) {
                    this.fieldItemArr.push('');
                    notice.warning('需要至少一个不为空的选项！');
                    return false;
                }

                for (var i = 0, iLen = this.fieldItemArr.length; i < iLen; i++) {
                    if (this.fieldItemArr[i].indexOf(',') !== -1) {
                        notice.warning('选项里不能包含英文逗号，请使用中文逗号替代！');
                        return false;
                    }
                }
            } else if (fieldTypeDesc === 'regexp') {} else if (fieldTypeDesc === 'telephone') {
                this.fieldItemArr = ['^\\d{7,8}$|^\\d{11,13}$'];
            } else if (fieldTypeDesc === 'datetime') {} else {
                this.fieldItemArr = [];
            }

            return true;
        },

        submitField: function submitField() {
            this.fieldItemArr = this.uniqueArr(this.fieldItemArr);

            if (this.commonField.name === '') {
                return notice.warning('标题不能为空！');
            }

            if (!this.checkField(this.fieldTypeDesc)) {
                return false;
            }

            var param = {
                componentType: this.fieldType,
                name: this.commonField.name,
                isRequired: this.commonField.isRequired,
                remark: this.commonField.remark,
                candidateValueList: this.fieldItemArr
            };

            $.post(this.submitUrl, param).then(function (data) {
                if (!data.success) {
                    notice.danger(data.msg);
                    return;
                }

                location.hash = '#/list-field-config';
            });
        },
        searchRegexp: function searchRegexp() {
            var url = location.origin + '/userField/regularExpression';
            window.open(url, "newwindow", "height=500,width=550,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no");
        }
    },

    components: { pageHeader: _pageHeader2.default }
};

/***/ }),

/***/ 417:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


module.exports = {
    props: {
        fieldInfo: {
            type: Object,
            required: true,
            default: {}
        },

        isActive: {
            type: Boolean,
            default: false
        },

        typeDesc: {
            type: String,
            default: ''
        }
    },
    data: function data() {
        return {};
    },
    methods: {
        changeField: function changeField(type) {
            this.$emit(type, this.fieldInfo.key);
        },

        editField: function editField() {
            this.$emit('edit-field', this.fieldInfo.key);
        }
    }
};

/***/ }),

/***/ 418:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
    value: true
});

var _pageHeader = __webpack_require__(360);

var _pageHeader2 = _interopRequireDefault(_pageHeader);

var _fieldInfoItem = __webpack_require__(492);

var _fieldInfoItem2 = _interopRequireDefault(_fieldInfoItem);

var _vuedraggable = __webpack_require__(563);

var _vuedraggable2 = _interopRequireDefault(_vuedraggable);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

exports.default = {
    props: ['topTitle'],
    created: function created() {
        this.refreshFieldList();
    },
    methods: {
        changeField: function changeField(type, fieldKey) {
            var _this = this;

            if (type !== "delete" || confirm("确定要删除该字段吗？删除后字段不可恢复！")) {
                $.post(this.CHANGE_URL + type + '/' + fieldKey).then(function (data) {
                    if (!data.success) {
                        notice.danger(data.msg);
                        return;
                    }

                    notice.success("操作成功!");

                    _this.refreshFieldList();
                });
            }
        },

        editField: function editField(fieldKey) {
            location.hash = '#/list-field-config/edit-custom-field?changeType=edit&fieldKey=' + fieldKey;
        },

        refreshFieldList: function refreshFieldList() {
            var _this2 = this;

            $.post(location.origin + '/namelist/queryField').then(function (data) {
                var rows = data.rows;
                if (!data.success) {
                    notice.danger(data.msg);
                    return;
                }

                _this2.activeList = rows.activeList;
                _this2.deactiveNameList = rows.deactiveNameList;
            });
        },

        dragSort: function dragSort() {
            var list = this.activeList;
            var ids = '';
            for (var i = 0, len = list.length; i < len; i++) {
                ids += list[i].key + ',';
            }
            $.ajax({
                url: location.origin + '/namelist/ajax',
                data: { type: 'sort', ids: ids },
                success: function success(data) {
                    if (data.success) {
                        notice.success(data.msg);
                    } else {
                        notice.warning(data.msg);
                    }
                }
            });
        }
    },
    data: function data() {
        return {
            deactiveNameList: [],

            activeList: [],
            CHANGE_URL: location.origin + '/namelist/change/'
        };
    },

    components: { pageHeader: _pageHeader2.default, fieldInfoItem: _fieldInfoItem2.default, draggable: _vuedraggable2.default }
};

/***/ }),

/***/ 419:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
    value: true
});

var _pageHeader = __webpack_require__(360);

var _pageHeader2 = _interopRequireDefault(_pageHeader);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

exports.default = {
    props: ['topTitle'],
    mounted: function mounted() {
        $('#datetimepicker').timeInput({
            format: "yyyy-MM-dd hh:mm:ss"
        });
        new PCAS("province_s", "city_s", "area_s");
    },
    methods: {
        selectType: function selectType(type) {
            location.hash = '#/list-field-config/edit-custom-field?changeType=add&fieldType=' + type;
        }
    },

    components: { pageHeader: _pageHeader2.default }
};

/***/ }),

/***/ 429:
/***/ (function(module, exports, __webpack_require__) {

module.exports = { "default": __webpack_require__(433), __esModule: true };

/***/ }),

/***/ 433:
/***/ (function(module, exports, __webpack_require__) {

__webpack_require__(91);
__webpack_require__(88);
__webpack_require__(92);
__webpack_require__(445);
__webpack_require__(446);
module.exports = __webpack_require__(6).Set;

/***/ }),

/***/ 434:
/***/ (function(module, exports, __webpack_require__) {

var forOf = __webpack_require__(100);

module.exports = function(iter, ITERATOR){
  var result = [];
  forOf(iter, false, result.push, result, ITERATOR);
  return result;
};


/***/ }),

/***/ 435:
/***/ (function(module, exports, __webpack_require__) {

// 0 -> Array#forEach
// 1 -> Array#map
// 2 -> Array#filter
// 3 -> Array#some
// 4 -> Array#every
// 5 -> Array#find
// 6 -> Array#findIndex
var ctx      = __webpack_require__(18)
  , IObject  = __webpack_require__(102)
  , toObject = __webpack_require__(99)
  , toLength = __webpack_require__(61)
  , asc      = __webpack_require__(437);
module.exports = function(TYPE, $create){
  var IS_MAP        = TYPE == 1
    , IS_FILTER     = TYPE == 2
    , IS_SOME       = TYPE == 3
    , IS_EVERY      = TYPE == 4
    , IS_FIND_INDEX = TYPE == 6
    , NO_HOLES      = TYPE == 5 || IS_FIND_INDEX
    , create        = $create || asc;
  return function($this, callbackfn, that){
    var O      = toObject($this)
      , self   = IObject(O)
      , f      = ctx(callbackfn, that, 3)
      , length = toLength(self.length)
      , index  = 0
      , result = IS_MAP ? create($this, length) : IS_FILTER ? create($this, 0) : undefined
      , val, res;
    for(;length > index; index++)if(NO_HOLES || index in self){
      val = self[index];
      res = f(val, index, O);
      if(TYPE){
        if(IS_MAP)result[index] = res;            // map
        else if(res)switch(TYPE){
          case 3: return true;                    // some
          case 5: return val;                     // find
          case 6: return index;                   // findIndex
          case 2: result.push(val);               // filter
        } else if(IS_EVERY)return false;          // every
      }
    }
    return IS_FIND_INDEX ? -1 : IS_SOME || IS_EVERY ? IS_EVERY : result;
  };
};

/***/ }),

/***/ 436:
/***/ (function(module, exports, __webpack_require__) {

var isObject = __webpack_require__(13)
  , isArray  = __webpack_require__(175)
  , SPECIES  = __webpack_require__(1)('species');

module.exports = function(original){
  var C;
  if(isArray(original)){
    C = original.constructor;
    // cross-realm fallback
    if(typeof C == 'function' && (C === Array || isArray(C.prototype)))C = undefined;
    if(isObject(C)){
      C = C[SPECIES];
      if(C === null)C = undefined;
    }
  } return C === undefined ? Array : C;
};

/***/ }),

/***/ 437:
/***/ (function(module, exports, __webpack_require__) {

// 9.4.2.3 ArraySpeciesCreate(originalArray, length)
var speciesConstructor = __webpack_require__(436);

module.exports = function(original, length){
  return new (speciesConstructor(original))(length);
};

/***/ }),

/***/ 438:
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var dP          = __webpack_require__(7).f
  , create      = __webpack_require__(90)
  , redefineAll = __webpack_require__(106)
  , ctx         = __webpack_require__(18)
  , anInstance  = __webpack_require__(101)
  , defined     = __webpack_require__(43)
  , forOf       = __webpack_require__(100)
  , $iterDefine = __webpack_require__(63)
  , step        = __webpack_require__(108)
  , setSpecies  = __webpack_require__(109)
  , DESCRIPTORS = __webpack_require__(4)
  , fastKey     = __webpack_require__(174).fastKey
  , SIZE        = DESCRIPTORS ? '_s' : 'size';

var getEntry = function(that, key){
  // fast case
  var index = fastKey(key), entry;
  if(index !== 'F')return that._i[index];
  // frozen object case
  for(entry = that._f; entry; entry = entry.n){
    if(entry.k == key)return entry;
  }
};

module.exports = {
  getConstructor: function(wrapper, NAME, IS_MAP, ADDER){
    var C = wrapper(function(that, iterable){
      anInstance(that, C, NAME, '_i');
      that._i = create(null); // index
      that._f = undefined;    // first entry
      that._l = undefined;    // last entry
      that[SIZE] = 0;         // size
      if(iterable != undefined)forOf(iterable, IS_MAP, that[ADDER], that);
    });
    redefineAll(C.prototype, {
      // 23.1.3.1 Map.prototype.clear()
      // 23.2.3.2 Set.prototype.clear()
      clear: function clear(){
        for(var that = this, data = that._i, entry = that._f; entry; entry = entry.n){
          entry.r = true;
          if(entry.p)entry.p = entry.p.n = undefined;
          delete data[entry.i];
        }
        that._f = that._l = undefined;
        that[SIZE] = 0;
      },
      // 23.1.3.3 Map.prototype.delete(key)
      // 23.2.3.4 Set.prototype.delete(value)
      'delete': function(key){
        var that  = this
          , entry = getEntry(that, key);
        if(entry){
          var next = entry.n
            , prev = entry.p;
          delete that._i[entry.i];
          entry.r = true;
          if(prev)prev.n = next;
          if(next)next.p = prev;
          if(that._f == entry)that._f = next;
          if(that._l == entry)that._l = prev;
          that[SIZE]--;
        } return !!entry;
      },
      // 23.2.3.6 Set.prototype.forEach(callbackfn, thisArg = undefined)
      // 23.1.3.5 Map.prototype.forEach(callbackfn, thisArg = undefined)
      forEach: function forEach(callbackfn /*, that = undefined */){
        anInstance(this, C, 'forEach');
        var f = ctx(callbackfn, arguments.length > 1 ? arguments[1] : undefined, 3)
          , entry;
        while(entry = entry ? entry.n : this._f){
          f(entry.v, entry.k, this);
          // revert to the last existing entry
          while(entry && entry.r)entry = entry.p;
        }
      },
      // 23.1.3.7 Map.prototype.has(key)
      // 23.2.3.7 Set.prototype.has(value)
      has: function has(key){
        return !!getEntry(this, key);
      }
    });
    if(DESCRIPTORS)dP(C.prototype, 'size', {
      get: function(){
        return defined(this[SIZE]);
      }
    });
    return C;
  },
  def: function(that, key, value){
    var entry = getEntry(that, key)
      , prev, index;
    // change existing entry
    if(entry){
      entry.v = value;
    // create new entry
    } else {
      that._l = entry = {
        i: index = fastKey(key, true), // <- index
        k: key,                        // <- key
        v: value,                      // <- value
        p: prev = that._l,             // <- previous entry
        n: undefined,                  // <- next entry
        r: false                       // <- removed
      };
      if(!that._f)that._f = entry;
      if(prev)prev.n = entry;
      that[SIZE]++;
      // add to index
      if(index !== 'F')that._i[index] = entry;
    } return that;
  },
  getEntry: getEntry,
  setStrong: function(C, NAME, IS_MAP){
    // add .keys, .values, .entries, [@@iterator]
    // 23.1.3.4, 23.1.3.8, 23.1.3.11, 23.1.3.12, 23.2.3.5, 23.2.3.8, 23.2.3.10, 23.2.3.11
    $iterDefine(C, NAME, function(iterated, kind){
      this._t = iterated;  // target
      this._k = kind;      // kind
      this._l = undefined; // previous
    }, function(){
      var that  = this
        , kind  = that._k
        , entry = that._l;
      // revert to the last existing entry
      while(entry && entry.r)entry = entry.p;
      // get next entry
      if(!that._t || !(that._l = entry = entry ? entry.n : that._t._f)){
        // or finish the iteration
        that._t = undefined;
        return step(1);
      }
      // return step by kind
      if(kind == 'keys'  )return step(0, entry.k);
      if(kind == 'values')return step(0, entry.v);
      return step(0, [entry.k, entry.v]);
    }, IS_MAP ? 'entries' : 'values' , !IS_MAP, true);

    // add [@@species], 23.1.2.2, 23.2.2.2
    setSpecies(NAME);
  }
};

/***/ }),

/***/ 439:
/***/ (function(module, exports, __webpack_require__) {

// https://github.com/DavidBruant/Map-Set.prototype.toJSON
var classof = __webpack_require__(62)
  , from    = __webpack_require__(434);
module.exports = function(NAME){
  return function toJSON(){
    if(classof(this) != NAME)throw TypeError(NAME + "#toJSON isn't generic");
    return from(this);
  };
};

/***/ }),

/***/ 440:
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var global         = __webpack_require__(0)
  , $export        = __webpack_require__(23)
  , meta           = __webpack_require__(174)
  , fails          = __webpack_require__(25)
  , hide           = __webpack_require__(8)
  , redefineAll    = __webpack_require__(106)
  , forOf          = __webpack_require__(100)
  , anInstance     = __webpack_require__(101)
  , isObject       = __webpack_require__(13)
  , setToStringTag = __webpack_require__(32)
  , dP             = __webpack_require__(7).f
  , each           = __webpack_require__(435)(0)
  , DESCRIPTORS    = __webpack_require__(4);

module.exports = function(NAME, wrapper, methods, common, IS_MAP, IS_WEAK){
  var Base  = global[NAME]
    , C     = Base
    , ADDER = IS_MAP ? 'set' : 'add'
    , proto = C && C.prototype
    , O     = {};
  if(!DESCRIPTORS || typeof C != 'function' || !(IS_WEAK || proto.forEach && !fails(function(){
    new C().entries().next();
  }))){
    // create collection constructor
    C = common.getConstructor(wrapper, NAME, IS_MAP, ADDER);
    redefineAll(C.prototype, methods);
    meta.NEED = true;
  } else {
    C = wrapper(function(target, iterable){
      anInstance(target, C, NAME, '_c');
      target._c = new Base;
      if(iterable != undefined)forOf(iterable, IS_MAP, target[ADDER], target);
    });
    each('add,clear,delete,forEach,get,has,set,keys,values,entries,toJSON'.split(','),function(KEY){
      var IS_ADDER = KEY == 'add' || KEY == 'set';
      if(KEY in proto && !(IS_WEAK && KEY == 'clear'))hide(C.prototype, KEY, function(a, b){
        anInstance(this, C, KEY);
        if(!IS_ADDER && IS_WEAK && !isObject(a))return KEY == 'get' ? undefined : false;
        var result = this._c[KEY](a === 0 ? 0 : a, b);
        return IS_ADDER ? this : result;
      });
    });
    if('size' in proto)dP(C.prototype, 'size', {
      get: function(){
        return this._c.size;
      }
    });
  }

  setToStringTag(C, NAME);

  O[NAME] = C;
  $export($export.G + $export.W + $export.F, O);

  if(!IS_WEAK)common.setStrong(C, NAME, IS_MAP);

  return C;
};

/***/ }),

/***/ 445:
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var strong = __webpack_require__(438);

// 23.2 Set Objects
module.exports = __webpack_require__(440)('Set', function(get){
  return function Set(){ return get(this, arguments.length > 0 ? arguments[0] : undefined); };
}, {
  // 23.2.3.1 Set.prototype.add(value)
  add: function add(value){
    return strong.def(this, value = value === 0 ? 0 : value, value);
  }
}, strong);

/***/ }),

/***/ 446:
/***/ (function(module, exports, __webpack_require__) {

// https://github.com/DavidBruant/Map-Set.prototype.toJSON
var $export  = __webpack_require__(23);

$export($export.P + $export.R, 'Set', {toJSON: __webpack_require__(439)('Set')});

/***/ }),

/***/ 451:
/***/ (function(module, exports, __webpack_require__) {

exports = module.exports = __webpack_require__(10)();
// imports


// module
exports.push([module.i, "\n.list-field-config__root {\n  height: 100%;\n  overflow: auto;\n}\n.list-field-config__breadcrumbs {\n  margin-bottom: 0;\n  padding-left: 0;\n  font-size: 16px;\n  font-weight: normal;\n}\n.list-field-config__breadcrumbs-item {\n  display: inline-block;\n}\n.list-field-config__breadcrumbs-item::after {\n  color: #999;\n  content: \">\";\n  margin: 0 5px;\n}\n.list-field-config__breadcrumbs-item:last-child::after {\n  display: none;\n}\n.list-field-config__router-link-active {\n  color: #337ab7;\n}\n.list-field-config__router-link-active:hover {\n  color: #48b6d7;\n}\n.list-field-config__main {\n  margin-top: 10px;\n}\n.list-field-config__section-contain {\n  padding: 0 15px 15px 15px;\n  overflow: hidden;\n}\n.list-field-config__section-box {\n  margin-top: 15px;\n}\n.list-field-config__section-header {\n  margin-bottom: 15px;\n  font-size: 16px;\n}\n.list-field-config__header__reset {\n  padding-left: 0;\n}\n.list-field-config__section-title {\n  float: left;\n  padding-left: 10px;\n  border-left: 3px solid #21d376;\n}\n.list-field-config__section-title.active {\n  border-left-color: #21d376;\n}\n.list-field-config__section-title.unactive {\n  border-left-color: #888;\n}\n.list-field-config__h5__reset {\n  font-weight: bold;\n}\n.list-field-config__clear::after {\n  clear: both;\n  content: \".\";\n  display: block;\n  height: 0;\n  visibility: hidden;\n}\n.list-field-config__section-btn {\n  display: inline-block;\n  padding: 3px 14px;\n  font-size: 13px;\n  font-weight: 400;\n  line-height: 1.42857143;\n  text-align: center;\n  white-space: nowrap;\n  vertical-align: middle;\n  touch-action: manipulation;\n  cursor: pointer;\n  -webkit-user-select: none;\n  -moz-user-select: none;\n  -ms-user-select: none;\n  user-select: none;\n  background-image: none;\n  border-radius: 4px;\n  color: #444;\n  border: 1px solid #d2d2d2;\n}\n.list-field-config__section-btn:hover {\n  color: #fff;\n  background-color: #444;\n  border-color: transparent;\n}\n.list-field-config__section-btn[disabled],\n.list-field-config__section-btn.disabled {\n  color: #888;\n  cursor: not-allowed;\n}\n.list-field-config__section-btn.fr {\n  float: right;\n}\n.list-field-config__section-btn.success {\n  color: #21d376;\n}\n.list-field-config__section-btn.success:hover {\n  color: #fff;\n  background-color: #21d376;\n}\n.list-field-config__section-btn.danger {\n  color: #d9534f;\n  /*border: 1px solid @danger-color;*/\n}\n.list-field-config__section-btn.danger:hover {\n  color: #fff;\n  background-color: #d9534f;\n}\n.list-field-config__field-list {\n  border-bottom: 1px solid #eef0f5;\n  padding-bottom: 15px;\n}\n.list-field-config__ul__set {\n  padding-left: 0;\n  margin-bottom: 0;\n  list-style: none;\n}\n.list-field-config__field-list > li {\n  padding: 8px;\n  line-height: 32px;\n  font-size: 14px;\n  font-weight: normal;\n}\n.list-field-config__field-list > li:hover {\n  background: #eff4f5 none repeat scroll 0 0;\n}\n.list-field-config__select {\n  height: 30px;\n  border-radius: 4px;\n}\n.list-field-config__select.disabled,\n.list-field-config__select[disabled] {\n  cursor: not-allowed;\n}\n", "", {"version":3,"sources":["/./src/list-field-config/list-field-config.vue"],"names":[],"mappings":";AAAA;EACE,aAAa;EACb,eAAe;CAChB;AACD;EACE,iBAAiB;EACjB,gBAAgB;EAChB,gBAAgB;EAChB,oBAAoB;CACrB;AACD;EACE,sBAAsB;CACvB;AACD;EACE,YAAY;EACZ,aAAa;EACb,cAAc;CACf;AACD;EACE,cAAc;CACf;AACD;EACE,eAAe;CAChB;AACD;EACE,eAAe;CAChB;AACD;EACE,iBAAiB;CAClB;AACD;EACE,0BAA0B;EAC1B,iBAAiB;CAClB;AACD;EACE,iBAAiB;CAClB;AACD;EACE,oBAAoB;EACpB,gBAAgB;CACjB;AACD;EACE,gBAAgB;CACjB;AACD;EACE,YAAY;EACZ,mBAAmB;EACnB,+BAA+B;CAChC;AACD;EACE,2BAA2B;CAC5B;AACD;EACE,wBAAwB;CACzB;AACD;EACE,kBAAkB;CACnB;AACD;EACE,YAAY;EACZ,aAAa;EACb,eAAe;EACf,UAAU;EACV,mBAAmB;CACpB;AACD;EACE,sBAAsB;EACtB,kBAAkB;EAClB,gBAAgB;EAChB,iBAAiB;EACjB,wBAAwB;EACxB,mBAAmB;EACnB,oBAAoB;EACpB,uBAAuB;EACvB,2BAA2B;EAC3B,gBAAgB;EAChB,0BAA0B;EAC1B,uBAAuB;EACvB,sBAAsB;EACtB,kBAAkB;EAClB,uBAAuB;EACvB,mBAAmB;EACnB,YAAY;EACZ,0BAA0B;CAC3B;AACD;EACE,YAAY;EACZ,uBAAuB;EACvB,0BAA0B;CAC3B;AACD;;EAEE,YAAY;EACZ,oBAAoB;CACrB;AACD;EACE,aAAa;CACd;AACD;EACE,eAAe;CAChB;AACD;EACE,YAAY;EACZ,0BAA0B;CAC3B;AACD;EACE,eAAe;EACf,oCAAoC;CACrC;AACD;EACE,YAAY;EACZ,0BAA0B;CAC3B;AACD;EACE,iCAAiC;EACjC,qBAAqB;CACtB;AACD;EACE,gBAAgB;EAChB,iBAAiB;EACjB,iBAAiB;CAClB;AACD;EACE,aAAa;EACb,kBAAkB;EAClB,gBAAgB;EAChB,oBAAoB;CACrB;AACD;EACE,2CAA2C;CAC5C;AACD;EACE,aAAa;EACb,mBAAmB;CACpB;AACD;;EAEE,oBAAoB;CACrB","file":"list-field-config.vue","sourcesContent":[".list-field-config__root {\n  height: 100%;\n  overflow: auto;\n}\n.list-field-config__breadcrumbs {\n  margin-bottom: 0;\n  padding-left: 0;\n  font-size: 16px;\n  font-weight: normal;\n}\n.list-field-config__breadcrumbs-item {\n  display: inline-block;\n}\n.list-field-config__breadcrumbs-item::after {\n  color: #999;\n  content: \">\";\n  margin: 0 5px;\n}\n.list-field-config__breadcrumbs-item:last-child::after {\n  display: none;\n}\n.list-field-config__router-link-active {\n  color: #337ab7;\n}\n.list-field-config__router-link-active:hover {\n  color: #48b6d7;\n}\n.list-field-config__main {\n  margin-top: 10px;\n}\n.list-field-config__section-contain {\n  padding: 0 15px 15px 15px;\n  overflow: hidden;\n}\n.list-field-config__section-box {\n  margin-top: 15px;\n}\n.list-field-config__section-header {\n  margin-bottom: 15px;\n  font-size: 16px;\n}\n.list-field-config__header__reset {\n  padding-left: 0;\n}\n.list-field-config__section-title {\n  float: left;\n  padding-left: 10px;\n  border-left: 3px solid #21d376;\n}\n.list-field-config__section-title.active {\n  border-left-color: #21d376;\n}\n.list-field-config__section-title.unactive {\n  border-left-color: #888;\n}\n.list-field-config__h5__reset {\n  font-weight: bold;\n}\n.list-field-config__clear::after {\n  clear: both;\n  content: \".\";\n  display: block;\n  height: 0;\n  visibility: hidden;\n}\n.list-field-config__section-btn {\n  display: inline-block;\n  padding: 3px 14px;\n  font-size: 13px;\n  font-weight: 400;\n  line-height: 1.42857143;\n  text-align: center;\n  white-space: nowrap;\n  vertical-align: middle;\n  touch-action: manipulation;\n  cursor: pointer;\n  -webkit-user-select: none;\n  -moz-user-select: none;\n  -ms-user-select: none;\n  user-select: none;\n  background-image: none;\n  border-radius: 4px;\n  color: #444;\n  border: 1px solid #d2d2d2;\n}\n.list-field-config__section-btn:hover {\n  color: #fff;\n  background-color: #444;\n  border-color: transparent;\n}\n.list-field-config__section-btn[disabled],\n.list-field-config__section-btn.disabled {\n  color: #888;\n  cursor: not-allowed;\n}\n.list-field-config__section-btn.fr {\n  float: right;\n}\n.list-field-config__section-btn.success {\n  color: #21d376;\n}\n.list-field-config__section-btn.success:hover {\n  color: #fff;\n  background-color: #21d376;\n}\n.list-field-config__section-btn.danger {\n  color: #d9534f;\n  /*border: 1px solid @danger-color;*/\n}\n.list-field-config__section-btn.danger:hover {\n  color: #fff;\n  background-color: #d9534f;\n}\n.list-field-config__field-list {\n  border-bottom: 1px solid #eef0f5;\n  padding-bottom: 15px;\n}\n.list-field-config__ul__set {\n  padding-left: 0;\n  margin-bottom: 0;\n  list-style: none;\n}\n.list-field-config__field-list > li {\n  padding: 8px;\n  line-height: 32px;\n  font-size: 14px;\n  font-weight: normal;\n}\n.list-field-config__field-list > li:hover {\n  background: #eff4f5 none repeat scroll 0 0;\n}\n.list-field-config__select {\n  height: 30px;\n  border-radius: 4px;\n}\n.list-field-config__select.disabled,\n.list-field-config__select[disabled] {\n  cursor: not-allowed;\n}\n"],"sourceRoot":"webpack://"}]);

// exports


/***/ }),

/***/ 457:
/***/ (function(module, exports, __webpack_require__) {

exports = module.exports = __webpack_require__(10)();
// imports


// module
exports.push([module.i, "\n.edit-custom-field__root[data-v-28e6d8df] {\n  height: 100%;\n  overflow: auto;\n}\n.edit-custom-field__main[data-v-28e6d8df] {\n  margin-top: 10px;\n}\n.edit-custom-field__content[data-v-28e6d8df] {\n  padding: 50px 0;\n  font-weight: normal;\n  max-width: 950px;\n}\n.edit-custom-field__section-common[data-v-28e6d8df] {\n  width: 600px;\n  margin-left: 180px;\n}\n.edit-custom-field__field__focus[data-v-28e6d8df]:focus {\n  border-color: #009688;\n}\n.edit-custom-field__des[data-v-28e6d8df] {\n  color: #888;\n}\n.edit-custom-field__section-common-title[data-v-28e6d8df] {\n  font-size: 14px;\n  font-weight: normal;\n}\n.edit-custom-field__section-common-input[data-v-28e6d8df] {\n  height: 30px;\n  width: 400px;\n  border: 1px solid #a9a9a9;\n  padding: 0 10px;\n}\n.edit-custom-field__section-common-checkbox[data-v-28e6d8df] {\n  cursor: pointer;\n  color: #333;\n}\n.edit-custom-field__section-common-textarea[data-v-28e6d8df] {\n  height: 150px;\n  width: 600px;\n  padding: 10px;\n  resize: none;\n}\n.edit-custom-field__panel-section[data-v-28e6d8df] {\n  border-top: 1px solid #eee;\n  padding: 15px;\n  overflow: hidden;\n}\n.edit-custom-field__panel-section-title[data-v-28e6d8df] {\n  font-size: 14px;\n  font-weight: normal;\n  float: left;\n  width: 165px;\n}\n.edit-custom-field__panel-section-content[data-v-28e6d8df] {\n  float: left;\n  width: 720px;\n}\n.edit-custom-field__panel-section-lists[data-v-28e6d8df] {\n  list-style-type: none;\n  background: #fff;\n  margin: 0;\n  border: 1px solid #a9a9a9;\n  padding: 15px;\n}\n.edit-custom-field__panel-section-lists-item[data-v-28e6d8df] {\n  margin-bottom: 5px;\n}\n.edit-custom-field__panel-section-lists-item[data-v-28e6d8df]:hover {\n  background: #eff4f5;\n}\n.edit-custom-field__panel-section-input[data-v-28e6d8df] {\n  padding-left: 10px;\n  width: 300px;\n  height: 30px;\n  border: 1px solid #a9a9a9;\n}\n.edit-custom-field__panel-section-remove[data-v-28e6d8df] {\n  float: right;\n  height: 30px;\n  line-height: 30px;\n  text-align: center;\n  width: 30px;\n  background: none 0 0 repeat scroll #ff595f;\n  border-radius: 100%;\n  color: #fff;\n  font-size: 22px;\n}\n.edit-custom-field__panel-section-addicon[data-v-28e6d8df] {\n  display: inline-block;\n  height: 20px;\n  line-height: 20px;\n  text-align: center;\n  width: 20px;\n  background: #009688;\n  border-radius: 100%;\n  color: #fff;\n  font-size: 14px;\n  margin: 5px;\n}\n.edit-custom-field__panel-section-add[data-v-28e6d8df]:hover {\n  text-decoration: underline;\n}\n.edit-custom-field__panel-section-select[data-v-28e6d8df] {\n  width: 175px;\n  height: 30px;\n  border: 1px solid #a9a9a9;\n  letter-spacing: 4px;\n}\n.edit-custom-field__panel-section-operation[data-v-28e6d8df] {\n  margin-left: 180px;\n}\n", "", {"version":3,"sources":["/./src/list-field-config/edit-custom-field.vue"],"names":[],"mappings":";AAAA;EACE,aAAa;EACb,eAAe;CAChB;AACD;EACE,iBAAiB;CAClB;AACD;EACE,gBAAgB;EAChB,oBAAoB;EACpB,iBAAiB;CAClB;AACD;EACE,aAAa;EACb,mBAAmB;CACpB;AACD;EACE,sBAAsB;CACvB;AACD;EACE,YAAY;CACb;AACD;EACE,gBAAgB;EAChB,oBAAoB;CACrB;AACD;EACE,aAAa;EACb,aAAa;EACb,0BAA0B;EAC1B,gBAAgB;CACjB;AACD;EACE,gBAAgB;EAChB,YAAY;CACb;AACD;EACE,cAAc;EACd,aAAa;EACb,cAAc;EACd,aAAa;CACd;AACD;EACE,2BAA2B;EAC3B,cAAc;EACd,iBAAiB;CAClB;AACD;EACE,gBAAgB;EAChB,oBAAoB;EACpB,YAAY;EACZ,aAAa;CACd;AACD;EACE,YAAY;EACZ,aAAa;CACd;AACD;EACE,sBAAsB;EACtB,iBAAiB;EACjB,UAAU;EACV,0BAA0B;EAC1B,cAAc;CACf;AACD;EACE,mBAAmB;CACpB;AACD;EACE,oBAAoB;CACrB;AACD;EACE,mBAAmB;EACnB,aAAa;EACb,aAAa;EACb,0BAA0B;CAC3B;AACD;EACE,aAAa;EACb,aAAa;EACb,kBAAkB;EAClB,mBAAmB;EACnB,YAAY;EACZ,2CAA2C;EAC3C,oBAAoB;EACpB,YAAY;EACZ,gBAAgB;CACjB;AACD;EACE,sBAAsB;EACtB,aAAa;EACb,kBAAkB;EAClB,mBAAmB;EACnB,YAAY;EACZ,oBAAoB;EACpB,oBAAoB;EACpB,YAAY;EACZ,gBAAgB;EAChB,YAAY;CACb;AACD;EACE,2BAA2B;CAC5B;AACD;EACE,aAAa;EACb,aAAa;EACb,0BAA0B;EAC1B,oBAAoB;CACrB;AACD;EACE,mBAAmB;CACpB","file":"edit-custom-field.vue","sourcesContent":[".edit-custom-field__root {\n  height: 100%;\n  overflow: auto;\n}\n.edit-custom-field__main {\n  margin-top: 10px;\n}\n.edit-custom-field__content {\n  padding: 50px 0;\n  font-weight: normal;\n  max-width: 950px;\n}\n.edit-custom-field__section-common {\n  width: 600px;\n  margin-left: 180px;\n}\n.edit-custom-field__field__focus:focus {\n  border-color: #009688;\n}\n.edit-custom-field__des {\n  color: #888;\n}\n.edit-custom-field__section-common-title {\n  font-size: 14px;\n  font-weight: normal;\n}\n.edit-custom-field__section-common-input {\n  height: 30px;\n  width: 400px;\n  border: 1px solid #a9a9a9;\n  padding: 0 10px;\n}\n.edit-custom-field__section-common-checkbox {\n  cursor: pointer;\n  color: #333;\n}\n.edit-custom-field__section-common-textarea {\n  height: 150px;\n  width: 600px;\n  padding: 10px;\n  resize: none;\n}\n.edit-custom-field__panel-section {\n  border-top: 1px solid #eee;\n  padding: 15px;\n  overflow: hidden;\n}\n.edit-custom-field__panel-section-title {\n  font-size: 14px;\n  font-weight: normal;\n  float: left;\n  width: 165px;\n}\n.edit-custom-field__panel-section-content {\n  float: left;\n  width: 720px;\n}\n.edit-custom-field__panel-section-lists {\n  list-style-type: none;\n  background: #fff;\n  margin: 0;\n  border: 1px solid #a9a9a9;\n  padding: 15px;\n}\n.edit-custom-field__panel-section-lists-item {\n  margin-bottom: 5px;\n}\n.edit-custom-field__panel-section-lists-item:hover {\n  background: #eff4f5;\n}\n.edit-custom-field__panel-section-input {\n  padding-left: 10px;\n  width: 300px;\n  height: 30px;\n  border: 1px solid #a9a9a9;\n}\n.edit-custom-field__panel-section-remove {\n  float: right;\n  height: 30px;\n  line-height: 30px;\n  text-align: center;\n  width: 30px;\n  background: none 0 0 repeat scroll #ff595f;\n  border-radius: 100%;\n  color: #fff;\n  font-size: 22px;\n}\n.edit-custom-field__panel-section-addicon {\n  display: inline-block;\n  height: 20px;\n  line-height: 20px;\n  text-align: center;\n  width: 20px;\n  background: #009688;\n  border-radius: 100%;\n  color: #fff;\n  font-size: 14px;\n  margin: 5px;\n}\n.edit-custom-field__panel-section-add:hover {\n  text-decoration: underline;\n}\n.edit-custom-field__panel-section-select {\n  width: 175px;\n  height: 30px;\n  border: 1px solid #a9a9a9;\n  letter-spacing: 4px;\n}\n.edit-custom-field__panel-section-operation {\n  margin-left: 180px;\n}\n"],"sourceRoot":"webpack://"}]);

// exports


/***/ }),

/***/ 475:
/***/ (function(module, exports, __webpack_require__) {

exports = module.exports = __webpack_require__(10)();
// imports


// module
exports.push([module.i, "\n.field-info-item__text-unactive[data-v-be9e26c6] {\n  color: #888;\n}\n.field-info-item__root[data-v-be9e26c6] {\n  cursor: move;\n}\n", "", {"version":3,"sources":["/./src/list-field-config/field-info-item.vue"],"names":[],"mappings":";AAAA;EACE,YAAY;CACb;AACD;EACE,aAAa;CACd","file":"field-info-item.vue","sourcesContent":[".field-info-item__text-unactive {\n  color: #888;\n}\n.field-info-item__root {\n  cursor: move;\n}\n"],"sourceRoot":"webpack://"}]);

// exports


/***/ }),

/***/ 478:
/***/ (function(module, exports, __webpack_require__) {

exports = module.exports = __webpack_require__(10)();
// imports


// module
exports.push([module.i, "\n.z1 {\n  position: relative;\n  z-index: 1;\n}\n.select-custom-field__panel-box {\n  max-width: 950px;\n}\n.select-custom-field__root {\n  height: 100%;\n  overflow: auto;\n}\n.select-custom-field__main {\n  margin-top: 10px;\n}\n.select-custom-field__panel-section {\n  font-weight: normal;\n  padding: 15px;\n  overflow: hidden;\n  border-bottom: 1px solid #eff4f5;\n}\n.select-custom-field__panel-section-title {\n  font-size: 14px;\n  font-weight: normal;\n  float: left;\n  width: 20%;\n}\n.select-custom-field__panel-section-content {\n  float: right;\n  width: 80%;\n  background: #eff4f5;\n  padding: 15px;\n}\n.select-custom-field__panel-section-input {\n  height: 30px;\n  width: 400px;\n  border: 1px solid #a9a9a9;\n  padding: 5px;\n}\n.select-custom-field__panel-section-textarea {\n  width: 400px;\n  height: 100px;\n  resize: none;\n  padding: 5px;\n}\n.select-custom-field__panel-section-datetime {\n  width: 400px!important;\n}\n.select-custom-field__panel-section-datetime + span {\n  display: none;\n}\n.select-custom-field__panel-section-pcas {\n  width: 150px;\n  height: 30px;\n}\n.select-custom-field__panel-section-select {\n  height: 30px;\n  border-color: #a9a9a9;\n}\n.select-custom-field__panel-section-checkbox {\n  font-size: 14px;\n  color: #333;\n}\n.select-custom-field__panel-section__focus:focus {\n  border-color: #009688;\n}\n.select-custom-field__panel-section-des {\n  padding-top: 5px;\n  margin-bottom: 0;\n  color: #999;\n}\n", "", {"version":3,"sources":["/./src/list-field-config/select-custom-field.vue"],"names":[],"mappings":";AAAA;EACE,mBAAmB;EACnB,WAAW;CACZ;AACD;EACE,iBAAiB;CAClB;AACD;EACE,aAAa;EACb,eAAe;CAChB;AACD;EACE,iBAAiB;CAClB;AACD;EACE,oBAAoB;EACpB,cAAc;EACd,iBAAiB;EACjB,iCAAiC;CAClC;AACD;EACE,gBAAgB;EAChB,oBAAoB;EACpB,YAAY;EACZ,WAAW;CACZ;AACD;EACE,aAAa;EACb,WAAW;EACX,oBAAoB;EACpB,cAAc;CACf;AACD;EACE,aAAa;EACb,aAAa;EACb,0BAA0B;EAC1B,aAAa;CACd;AACD;EACE,aAAa;EACb,cAAc;EACd,aAAa;EACb,aAAa;CACd;AACD;EACE,uBAAuB;CACxB;AACD;EACE,cAAc;CACf;AACD;EACE,aAAa;EACb,aAAa;CACd;AACD;EACE,aAAa;EACb,sBAAsB;CACvB;AACD;EACE,gBAAgB;EAChB,YAAY;CACb;AACD;EACE,sBAAsB;CACvB;AACD;EACE,iBAAiB;EACjB,iBAAiB;EACjB,YAAY;CACb","file":"select-custom-field.vue","sourcesContent":[".z1 {\n  position: relative;\n  z-index: 1;\n}\n.select-custom-field__panel-box {\n  max-width: 950px;\n}\n.select-custom-field__root {\n  height: 100%;\n  overflow: auto;\n}\n.select-custom-field__main {\n  margin-top: 10px;\n}\n.select-custom-field__panel-section {\n  font-weight: normal;\n  padding: 15px;\n  overflow: hidden;\n  border-bottom: 1px solid #eff4f5;\n}\n.select-custom-field__panel-section-title {\n  font-size: 14px;\n  font-weight: normal;\n  float: left;\n  width: 20%;\n}\n.select-custom-field__panel-section-content {\n  float: right;\n  width: 80%;\n  background: #eff4f5;\n  padding: 15px;\n}\n.select-custom-field__panel-section-input {\n  height: 30px;\n  width: 400px;\n  border: 1px solid #a9a9a9;\n  padding: 5px;\n}\n.select-custom-field__panel-section-textarea {\n  width: 400px;\n  height: 100px;\n  resize: none;\n  padding: 5px;\n}\n.select-custom-field__panel-section-datetime {\n  width: 400px!important;\n}\n.select-custom-field__panel-section-datetime + span {\n  display: none;\n}\n.select-custom-field__panel-section-pcas {\n  width: 150px;\n  height: 30px;\n}\n.select-custom-field__panel-section-select {\n  height: 30px;\n  border-color: #a9a9a9;\n}\n.select-custom-field__panel-section-checkbox {\n  font-size: 14px;\n  color: #333;\n}\n.select-custom-field__panel-section__focus:focus {\n  border-color: #009688;\n}\n.select-custom-field__panel-section-des {\n  padding-top: 5px;\n  margin-bottom: 0;\n  color: #999;\n}\n"],"sourceRoot":"webpack://"}]);

// exports


/***/ }),

/***/ 481:
/***/ (function(module, exports, __webpack_require__) {

var __WEBPACK_AMD_DEFINE_FACTORY__, __WEBPACK_AMD_DEFINE_RESULT__;/**!
 * Sortable
 * @author	RubaXa   <trash@rubaxa.org>
 * @license MIT
 */

(function sortableModule(factory) {
	"use strict";

	if (true) {
		!(__WEBPACK_AMD_DEFINE_FACTORY__ = (factory),
				__WEBPACK_AMD_DEFINE_RESULT__ = (typeof __WEBPACK_AMD_DEFINE_FACTORY__ === 'function' ?
				(__WEBPACK_AMD_DEFINE_FACTORY__.call(exports, __webpack_require__, exports, module)) :
				__WEBPACK_AMD_DEFINE_FACTORY__),
				__WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__));
	}
	else if (typeof module != "undefined" && typeof module.exports != "undefined") {
		module.exports = factory();
	}
	else {
		/* jshint sub:true */
		window["Sortable"] = factory();
	}
})(function sortableFactory() {
	"use strict";

	if (typeof window == "undefined" || !window.document) {
		return function sortableError() {
			throw new Error("Sortable.js requires a window with a document");
		};
	}

	var dragEl,
		parentEl,
		ghostEl,
		cloneEl,
		rootEl,
		nextEl,
		lastDownEl,

		scrollEl,
		scrollParentEl,
		scrollCustomFn,

		lastEl,
		lastCSS,
		lastParentCSS,

		oldIndex,
		newIndex,

		activeGroup,
		putSortable,

		autoScroll = {},

		tapEvt,
		touchEvt,

		moved,

		/** @const */
		R_SPACE = /\s+/g,
		R_FLOAT = /left|right|inline/,

		expando = 'Sortable' + (new Date).getTime(),

		win = window,
		document = win.document,
		parseInt = win.parseInt,

		$ = win.jQuery || win.Zepto,
		Polymer = win.Polymer,

		captureMode = false,

		supportDraggable = !!('draggable' in document.createElement('div')),
		supportCssPointerEvents = (function (el) {
			// false when IE11
			if (!!navigator.userAgent.match(/Trident.*rv[ :]?11\./)) {
				return false;
			}
			el = document.createElement('x');
			el.style.cssText = 'pointer-events:auto';
			return el.style.pointerEvents === 'auto';
		})(),

		_silent = false,

		abs = Math.abs,
		min = Math.min,

		savedInputChecked = [],
		touchDragOverListeners = [],

		_autoScroll = _throttle(function (/**Event*/evt, /**Object*/options, /**HTMLElement*/rootEl) {
			// Bug: https://bugzilla.mozilla.org/show_bug.cgi?id=505521
			if (rootEl && options.scroll) {
				var _this = rootEl[expando],
					el,
					rect,
					sens = options.scrollSensitivity,
					speed = options.scrollSpeed,

					x = evt.clientX,
					y = evt.clientY,

					winWidth = window.innerWidth,
					winHeight = window.innerHeight,

					vx,
					vy,

					scrollOffsetX,
					scrollOffsetY
				;

				// Delect scrollEl
				if (scrollParentEl !== rootEl) {
					scrollEl = options.scroll;
					scrollParentEl = rootEl;
					scrollCustomFn = options.scrollFn;

					if (scrollEl === true) {
						scrollEl = rootEl;

						do {
							if ((scrollEl.offsetWidth < scrollEl.scrollWidth) ||
								(scrollEl.offsetHeight < scrollEl.scrollHeight)
							) {
								break;
							}
							/* jshint boss:true */
						} while (scrollEl = scrollEl.parentNode);
					}
				}

				if (scrollEl) {
					el = scrollEl;
					rect = scrollEl.getBoundingClientRect();
					vx = (abs(rect.right - x) <= sens) - (abs(rect.left - x) <= sens);
					vy = (abs(rect.bottom - y) <= sens) - (abs(rect.top - y) <= sens);
				}


				if (!(vx || vy)) {
					vx = (winWidth - x <= sens) - (x <= sens);
					vy = (winHeight - y <= sens) - (y <= sens);

					/* jshint expr:true */
					(vx || vy) && (el = win);
				}


				if (autoScroll.vx !== vx || autoScroll.vy !== vy || autoScroll.el !== el) {
					autoScroll.el = el;
					autoScroll.vx = vx;
					autoScroll.vy = vy;

					clearInterval(autoScroll.pid);

					if (el) {
						autoScroll.pid = setInterval(function () {
							scrollOffsetY = vy ? vy * speed : 0;
							scrollOffsetX = vx ? vx * speed : 0;

							if ('function' === typeof(scrollCustomFn)) {
								return scrollCustomFn.call(_this, scrollOffsetX, scrollOffsetY, evt);
							}

							if (el === win) {
								win.scrollTo(win.pageXOffset + scrollOffsetX, win.pageYOffset + scrollOffsetY);
							} else {
								el.scrollTop += scrollOffsetY;
								el.scrollLeft += scrollOffsetX;
							}
						}, 24);
					}
				}
			}
		}, 30),

		_prepareGroup = function (options) {
			function toFn(value, pull) {
				if (value === void 0 || value === true) {
					value = group.name;
				}

				if (typeof value === 'function') {
					return value;
				} else {
					return function (to, from) {
						var fromGroup = from.options.group.name;

						return pull
							? value
							: value && (value.join
								? value.indexOf(fromGroup) > -1
								: (fromGroup == value)
							);
					};
				}
			}

			var group = {};
			var originalGroup = options.group;

			if (!originalGroup || typeof originalGroup != 'object') {
				originalGroup = {name: originalGroup};
			}

			group.name = originalGroup.name;
			group.checkPull = toFn(originalGroup.pull, true);
			group.checkPut = toFn(originalGroup.put);
			group.revertClone = originalGroup.revertClone;

			options.group = group;
		}
	;


	/**
	 * @class  Sortable
	 * @param  {HTMLElement}  el
	 * @param  {Object}       [options]
	 */
	function Sortable(el, options) {
		if (!(el && el.nodeType && el.nodeType === 1)) {
			throw 'Sortable: `el` must be HTMLElement, and not ' + {}.toString.call(el);
		}

		this.el = el; // root element
		this.options = options = _extend({}, options);


		// Export instance
		el[expando] = this;

		// Default options
		var defaults = {
			group: Math.random(),
			sort: true,
			disabled: false,
			store: null,
			handle: null,
			scroll: true,
			scrollSensitivity: 30,
			scrollSpeed: 10,
			draggable: /[uo]l/i.test(el.nodeName) ? 'li' : '>*',
			ghostClass: 'sortable-ghost',
			chosenClass: 'sortable-chosen',
			dragClass: 'sortable-drag',
			ignore: 'a, img',
			filter: null,
			preventOnFilter: true,
			animation: 0,
			setData: function (dataTransfer, dragEl) {
				dataTransfer.setData('Text', dragEl.textContent);
			},
			dropBubble: false,
			dragoverBubble: false,
			dataIdAttr: 'data-id',
			delay: 0,
			forceFallback: false,
			fallbackClass: 'sortable-fallback',
			fallbackOnBody: false,
			fallbackTolerance: 0,
			fallbackOffset: {x: 0, y: 0}
		};


		// Set default options
		for (var name in defaults) {
			!(name in options) && (options[name] = defaults[name]);
		}

		_prepareGroup(options);

		// Bind all private methods
		for (var fn in this) {
			if (fn.charAt(0) === '_' && typeof this[fn] === 'function') {
				this[fn] = this[fn].bind(this);
			}
		}

		// Setup drag mode
		this.nativeDraggable = options.forceFallback ? false : supportDraggable;

		// Bind events
		_on(el, 'mousedown', this._onTapStart);
		_on(el, 'touchstart', this._onTapStart);
		_on(el, 'pointerdown', this._onTapStart);

		if (this.nativeDraggable) {
			_on(el, 'dragover', this);
			_on(el, 'dragenter', this);
		}

		touchDragOverListeners.push(this._onDragOver);

		// Restore sorting
		options.store && this.sort(options.store.get(this));
	}


	Sortable.prototype = /** @lends Sortable.prototype */ {
		constructor: Sortable,

		_onTapStart: function (/** Event|TouchEvent */evt) {
			var _this = this,
				el = this.el,
				options = this.options,
				preventOnFilter = options.preventOnFilter,
				type = evt.type,
				touch = evt.touches && evt.touches[0],
				target = (touch || evt).target,
				originalTarget = evt.target.shadowRoot && evt.path[0] || target,
				filter = options.filter,
				startIndex;

			_saveInputCheckedState(el);


			// Don't trigger start event when an element is been dragged, otherwise the evt.oldindex always wrong when set option.group.
			if (dragEl) {
				return;
			}

			if (type === 'mousedown' && evt.button !== 0 || options.disabled) {
				return; // only left button or enabled
			}


			target = _closest(target, options.draggable, el);

			if (!target) {
				return;
			}

			if (lastDownEl === target) {
				// Ignoring duplicate `down`
				return;
			}

			// Get the index of the dragged element within its parent
			startIndex = _index(target, options.draggable);

			// Check filter
			if (typeof filter === 'function') {
				if (filter.call(this, evt, target, this)) {
					_dispatchEvent(_this, originalTarget, 'filter', target, el, startIndex);
					preventOnFilter && evt.preventDefault();
					return; // cancel dnd
				}
			}
			else if (filter) {
				filter = filter.split(',').some(function (criteria) {
					criteria = _closest(originalTarget, criteria.trim(), el);

					if (criteria) {
						_dispatchEvent(_this, criteria, 'filter', target, el, startIndex);
						return true;
					}
				});

				if (filter) {
					preventOnFilter && evt.preventDefault();
					return; // cancel dnd
				}
			}

			if (options.handle && !_closest(originalTarget, options.handle, el)) {
				return;
			}

			// Prepare `dragstart`
			this._prepareDragStart(evt, touch, target, startIndex);
		},

		_prepareDragStart: function (/** Event */evt, /** Touch */touch, /** HTMLElement */target, /** Number */startIndex) {
			var _this = this,
				el = _this.el,
				options = _this.options,
				ownerDocument = el.ownerDocument,
				dragStartFn;

			if (target && !dragEl && (target.parentNode === el)) {
				tapEvt = evt;

				rootEl = el;
				dragEl = target;
				parentEl = dragEl.parentNode;
				nextEl = dragEl.nextSibling;
				lastDownEl = target;
				activeGroup = options.group;
				oldIndex = startIndex;

				this._lastX = (touch || evt).clientX;
				this._lastY = (touch || evt).clientY;

				dragEl.style['will-change'] = 'transform';

				dragStartFn = function () {
					// Delayed drag has been triggered
					// we can re-enable the events: touchmove/mousemove
					_this._disableDelayedDrag();

					// Make the element draggable
					dragEl.draggable = _this.nativeDraggable;

					// Chosen item
					_toggleClass(dragEl, options.chosenClass, true);

					// Bind the events: dragstart/dragend
					_this._triggerDragStart(evt, touch);

					// Drag start event
					_dispatchEvent(_this, rootEl, 'choose', dragEl, rootEl, oldIndex);
				};

				// Disable "draggable"
				options.ignore.split(',').forEach(function (criteria) {
					_find(dragEl, criteria.trim(), _disableDraggable);
				});

				_on(ownerDocument, 'mouseup', _this._onDrop);
				_on(ownerDocument, 'touchend', _this._onDrop);
				_on(ownerDocument, 'touchcancel', _this._onDrop);
				_on(ownerDocument, 'pointercancel', _this._onDrop);
				_on(ownerDocument, 'selectstart', _this);

				if (options.delay) {
					// If the user moves the pointer or let go the click or touch
					// before the delay has been reached:
					// disable the delayed drag
					_on(ownerDocument, 'mouseup', _this._disableDelayedDrag);
					_on(ownerDocument, 'touchend', _this._disableDelayedDrag);
					_on(ownerDocument, 'touchcancel', _this._disableDelayedDrag);
					_on(ownerDocument, 'mousemove', _this._disableDelayedDrag);
					_on(ownerDocument, 'touchmove', _this._disableDelayedDrag);
					_on(ownerDocument, 'pointermove', _this._disableDelayedDrag);

					_this._dragStartTimer = setTimeout(dragStartFn, options.delay);
				} else {
					dragStartFn();
				}


			}
		},

		_disableDelayedDrag: function () {
			var ownerDocument = this.el.ownerDocument;

			clearTimeout(this._dragStartTimer);
			_off(ownerDocument, 'mouseup', this._disableDelayedDrag);
			_off(ownerDocument, 'touchend', this._disableDelayedDrag);
			_off(ownerDocument, 'touchcancel', this._disableDelayedDrag);
			_off(ownerDocument, 'mousemove', this._disableDelayedDrag);
			_off(ownerDocument, 'touchmove', this._disableDelayedDrag);
			_off(ownerDocument, 'pointermove', this._disableDelayedDrag);
		},

		_triggerDragStart: function (/** Event */evt, /** Touch */touch) {
			touch = touch || (evt.pointerType == 'touch' ? evt : null);

			if (touch) {
				// Touch device support
				tapEvt = {
					target: dragEl,
					clientX: touch.clientX,
					clientY: touch.clientY
				};

				this._onDragStart(tapEvt, 'touch');
			}
			else if (!this.nativeDraggable) {
				this._onDragStart(tapEvt, true);
			}
			else {
				_on(dragEl, 'dragend', this);
				_on(rootEl, 'dragstart', this._onDragStart);
			}

			try {
				if (document.selection) {					
					// Timeout neccessary for IE9					
					setTimeout(function () {
						document.selection.empty();
					});					
				} else {
					window.getSelection().removeAllRanges();
				}
			} catch (err) {
			}
		},

		_dragStarted: function () {
			if (rootEl && dragEl) {
				var options = this.options;

				// Apply effect
				_toggleClass(dragEl, options.ghostClass, true);
				_toggleClass(dragEl, options.dragClass, false);

				Sortable.active = this;

				// Drag start event
				_dispatchEvent(this, rootEl, 'start', dragEl, rootEl, oldIndex);
			} else {
				this._nulling();
			}
		},

		_emulateDragOver: function () {
			if (touchEvt) {
				if (this._lastX === touchEvt.clientX && this._lastY === touchEvt.clientY) {
					return;
				}

				this._lastX = touchEvt.clientX;
				this._lastY = touchEvt.clientY;

				if (!supportCssPointerEvents) {
					_css(ghostEl, 'display', 'none');
				}

				var target = document.elementFromPoint(touchEvt.clientX, touchEvt.clientY),
					parent = target,
					i = touchDragOverListeners.length;

				if (parent) {
					do {
						if (parent[expando]) {
							while (i--) {
								touchDragOverListeners[i]({
									clientX: touchEvt.clientX,
									clientY: touchEvt.clientY,
									target: target,
									rootEl: parent
								});
							}

							break;
						}

						target = parent; // store last element
					}
					/* jshint boss:true */
					while (parent = parent.parentNode);
				}

				if (!supportCssPointerEvents) {
					_css(ghostEl, 'display', '');
				}
			}
		},


		_onTouchMove: function (/**TouchEvent*/evt) {
			if (tapEvt) {
				var	options = this.options,
					fallbackTolerance = options.fallbackTolerance,
					fallbackOffset = options.fallbackOffset,
					touch = evt.touches ? evt.touches[0] : evt,
					dx = (touch.clientX - tapEvt.clientX) + fallbackOffset.x,
					dy = (touch.clientY - tapEvt.clientY) + fallbackOffset.y,
					translate3d = evt.touches ? 'translate3d(' + dx + 'px,' + dy + 'px,0)' : 'translate(' + dx + 'px,' + dy + 'px)';

				// only set the status to dragging, when we are actually dragging
				if (!Sortable.active) {
					if (fallbackTolerance &&
						min(abs(touch.clientX - this._lastX), abs(touch.clientY - this._lastY)) < fallbackTolerance
					) {
						return;
					}

					this._dragStarted();
				}

				// as well as creating the ghost element on the document body
				this._appendGhost();

				moved = true;
				touchEvt = touch;

				_css(ghostEl, 'webkitTransform', translate3d);
				_css(ghostEl, 'mozTransform', translate3d);
				_css(ghostEl, 'msTransform', translate3d);
				_css(ghostEl, 'transform', translate3d);

				evt.preventDefault();
			}
		},

		_appendGhost: function () {
			if (!ghostEl) {
				var rect = dragEl.getBoundingClientRect(),
					css = _css(dragEl),
					options = this.options,
					ghostRect;

				ghostEl = dragEl.cloneNode(true);

				_toggleClass(ghostEl, options.ghostClass, false);
				_toggleClass(ghostEl, options.fallbackClass, true);
				_toggleClass(ghostEl, options.dragClass, true);

				_css(ghostEl, 'top', rect.top - parseInt(css.marginTop, 10));
				_css(ghostEl, 'left', rect.left - parseInt(css.marginLeft, 10));
				_css(ghostEl, 'width', rect.width);
				_css(ghostEl, 'height', rect.height);
				_css(ghostEl, 'opacity', '0.8');
				_css(ghostEl, 'position', 'fixed');
				_css(ghostEl, 'zIndex', '100000');
				_css(ghostEl, 'pointerEvents', 'none');

				options.fallbackOnBody && document.body.appendChild(ghostEl) || rootEl.appendChild(ghostEl);

				// Fixing dimensions.
				ghostRect = ghostEl.getBoundingClientRect();
				_css(ghostEl, 'width', rect.width * 2 - ghostRect.width);
				_css(ghostEl, 'height', rect.height * 2 - ghostRect.height);
			}
		},

		_onDragStart: function (/**Event*/evt, /**boolean*/useFallback) {
			var dataTransfer = evt.dataTransfer,
				options = this.options;

			this._offUpEvents();

			if (activeGroup.checkPull(this, this, dragEl, evt)) {
				cloneEl = _clone(dragEl);

				cloneEl.draggable = false;
				cloneEl.style['will-change'] = '';

				_css(cloneEl, 'display', 'none');
				_toggleClass(cloneEl, this.options.chosenClass, false);

				rootEl.insertBefore(cloneEl, dragEl);
				_dispatchEvent(this, rootEl, 'clone', dragEl);
			}

			_toggleClass(dragEl, options.dragClass, true);

			if (useFallback) {
				if (useFallback === 'touch') {
					// Bind touch events
					_on(document, 'touchmove', this._onTouchMove);
					_on(document, 'touchend', this._onDrop);
					_on(document, 'touchcancel', this._onDrop);
					_on(document, 'pointermove', this._onTouchMove);
					_on(document, 'pointerup', this._onDrop);
				} else {
					// Old brwoser
					_on(document, 'mousemove', this._onTouchMove);
					_on(document, 'mouseup', this._onDrop);
				}

				this._loopId = setInterval(this._emulateDragOver, 50);
			}
			else {
				if (dataTransfer) {
					dataTransfer.effectAllowed = 'move';
					options.setData && options.setData.call(this, dataTransfer, dragEl);
				}

				_on(document, 'drop', this);
				setTimeout(this._dragStarted, 0);
			}
		},

		_onDragOver: function (/**Event*/evt) {
			var el = this.el,
				target,
				dragRect,
				targetRect,
				revert,
				options = this.options,
				group = options.group,
				activeSortable = Sortable.active,
				isOwner = (activeGroup === group),
				isMovingBetweenSortable = false,
				canSort = options.sort;

			if (evt.preventDefault !== void 0) {
				evt.preventDefault();
				!options.dragoverBubble && evt.stopPropagation();
			}

			if (dragEl.animated) {
				return;
			}

			moved = true;

			if (activeSortable && !options.disabled &&
				(isOwner
					? canSort || (revert = !rootEl.contains(dragEl)) // Reverting item into the original list
					: (
						putSortable === this ||
						(
							(activeSortable.lastPullMode = activeGroup.checkPull(this, activeSortable, dragEl, evt)) &&
							group.checkPut(this, activeSortable, dragEl, evt)
						)
					)
				) &&
				(evt.rootEl === void 0 || evt.rootEl === this.el) // touch fallback
			) {
				// Smart auto-scrolling
				_autoScroll(evt, options, this.el);

				if (_silent) {
					return;
				}

				target = _closest(evt.target, options.draggable, el);
				dragRect = dragEl.getBoundingClientRect();

				if (putSortable !== this) {
					putSortable = this;
					isMovingBetweenSortable = true;
				}

				if (revert) {
					_cloneHide(activeSortable, true);
					parentEl = rootEl; // actualization

					if (cloneEl || nextEl) {
						rootEl.insertBefore(dragEl, cloneEl || nextEl);
					}
					else if (!canSort) {
						rootEl.appendChild(dragEl);
					}

					return;
				}


				if ((el.children.length === 0) || (el.children[0] === ghostEl) ||
					(el === evt.target) && (target = _ghostIsLast(el, evt))
				) {
					if (target) {
						if (target.animated) {
							return;
						}

						targetRect = target.getBoundingClientRect();
					}

					_cloneHide(activeSortable, isOwner);

					if (_onMove(rootEl, el, dragEl, dragRect, target, targetRect, evt) !== false) {
						if (!dragEl.contains(el)) {
							el.appendChild(dragEl);
							parentEl = el; // actualization
						}

						this._animate(dragRect, dragEl);
						target && this._animate(targetRect, target);
					}
				}
				else if (target && !target.animated && target !== dragEl && (target.parentNode[expando] !== void 0)) {
					if (lastEl !== target) {
						lastEl = target;
						lastCSS = _css(target);
						lastParentCSS = _css(target.parentNode);
					}

					targetRect = target.getBoundingClientRect();

					var width = targetRect.right - targetRect.left,
						height = targetRect.bottom - targetRect.top,
						floating = R_FLOAT.test(lastCSS.cssFloat + lastCSS.display)
							|| (lastParentCSS.display == 'flex' && lastParentCSS['flex-direction'].indexOf('row') === 0),
						isWide = (target.offsetWidth > dragEl.offsetWidth),
						isLong = (target.offsetHeight > dragEl.offsetHeight),
						halfway = (floating ? (evt.clientX - targetRect.left) / width : (evt.clientY - targetRect.top) / height) > 0.5,
						nextSibling = target.nextElementSibling,
						moveVector = _onMove(rootEl, el, dragEl, dragRect, target, targetRect, evt),
						after = false
					;

					if (moveVector !== false) {
						_silent = true;
						setTimeout(_unsilent, 30);

						_cloneHide(activeSortable, isOwner);

						if (moveVector === 1 || moveVector === -1) {
							after = (moveVector === 1);
						}
						else if (floating) {
							var elTop = dragEl.offsetTop,
								tgTop = target.offsetTop;

							if (elTop === tgTop) {
								after = (target.previousElementSibling === dragEl) && !isWide || halfway && isWide;
							}
							else if (target.previousElementSibling === dragEl || dragEl.previousElementSibling === target) {
								after = (evt.clientY - targetRect.top) / height > 0.5;
							} else {
								after = tgTop > elTop;
							}
						} else if (!isMovingBetweenSortable) {
							after = (nextSibling !== dragEl) && !isLong || halfway && isLong;
						}

						if (!dragEl.contains(el)) {
							if (after && !nextSibling) {
								el.appendChild(dragEl);
							} else {
								target.parentNode.insertBefore(dragEl, after ? nextSibling : target);
							}
						}

						parentEl = dragEl.parentNode; // actualization

						this._animate(dragRect, dragEl);
						this._animate(targetRect, target);
					}
				}
			}
		},

		_animate: function (prevRect, target) {
			var ms = this.options.animation;

			if (ms) {
				var currentRect = target.getBoundingClientRect();

				if (prevRect.nodeType === 1) {
					prevRect = prevRect.getBoundingClientRect();
				}

				_css(target, 'transition', 'none');
				_css(target, 'transform', 'translate3d('
					+ (prevRect.left - currentRect.left) + 'px,'
					+ (prevRect.top - currentRect.top) + 'px,0)'
				);

				target.offsetWidth; // repaint

				_css(target, 'transition', 'all ' + ms + 'ms');
				_css(target, 'transform', 'translate3d(0,0,0)');

				clearTimeout(target.animated);
				target.animated = setTimeout(function () {
					_css(target, 'transition', '');
					_css(target, 'transform', '');
					target.animated = false;
				}, ms);
			}
		},

		_offUpEvents: function () {
			var ownerDocument = this.el.ownerDocument;

			_off(document, 'touchmove', this._onTouchMove);
			_off(document, 'pointermove', this._onTouchMove);
			_off(ownerDocument, 'mouseup', this._onDrop);
			_off(ownerDocument, 'touchend', this._onDrop);
			_off(ownerDocument, 'pointerup', this._onDrop);
			_off(ownerDocument, 'touchcancel', this._onDrop);
			_off(ownerDocument, 'selectstart', this);
		},

		_onDrop: function (/**Event*/evt) {
			var el = this.el,
				options = this.options;

			clearInterval(this._loopId);
			clearInterval(autoScroll.pid);
			clearTimeout(this._dragStartTimer);

			// Unbind events
			_off(document, 'mousemove', this._onTouchMove);

			if (this.nativeDraggable) {
				_off(document, 'drop', this);
				_off(el, 'dragstart', this._onDragStart);
			}

			this._offUpEvents();

			if (evt) {
				if (moved) {
					evt.preventDefault();
					!options.dropBubble && evt.stopPropagation();
				}

				ghostEl && ghostEl.parentNode.removeChild(ghostEl);

				if (rootEl === parentEl || Sortable.active.lastPullMode !== 'clone') {
					// Remove clone
					cloneEl && cloneEl.parentNode.removeChild(cloneEl);
				}

				if (dragEl) {
					if (this.nativeDraggable) {
						_off(dragEl, 'dragend', this);
					}

					_disableDraggable(dragEl);
					dragEl.style['will-change'] = '';

					// Remove class's
					_toggleClass(dragEl, this.options.ghostClass, false);
					_toggleClass(dragEl, this.options.chosenClass, false);

					if (rootEl !== parentEl) {
						newIndex = _index(dragEl, options.draggable);

						if (newIndex >= 0) {
							// Add event
							_dispatchEvent(null, parentEl, 'add', dragEl, rootEl, oldIndex, newIndex);

							// Remove event
							_dispatchEvent(this, rootEl, 'remove', dragEl, rootEl, oldIndex, newIndex);

							// drag from one list and drop into another
							_dispatchEvent(null, parentEl, 'sort', dragEl, rootEl, oldIndex, newIndex);
							_dispatchEvent(this, rootEl, 'sort', dragEl, rootEl, oldIndex, newIndex);
						}
					}
					else {
						if (dragEl.nextSibling !== nextEl) {
							// Get the index of the dragged element within its parent
							newIndex = _index(dragEl, options.draggable);

							if (newIndex >= 0) {
								// drag & drop within the same list
								_dispatchEvent(this, rootEl, 'update', dragEl, rootEl, oldIndex, newIndex);
								_dispatchEvent(this, rootEl, 'sort', dragEl, rootEl, oldIndex, newIndex);
							}
						}
					}

					if (Sortable.active) {
						/* jshint eqnull:true */
						if (newIndex == null || newIndex === -1) {
							newIndex = oldIndex;
						}

						_dispatchEvent(this, rootEl, 'end', dragEl, rootEl, oldIndex, newIndex);

						// Save sorting
						this.save();
					}
				}

			}

			this._nulling();
		},

		_nulling: function() {
			rootEl =
			dragEl =
			parentEl =
			ghostEl =
			nextEl =
			cloneEl =
			lastDownEl =

			scrollEl =
			scrollParentEl =

			tapEvt =
			touchEvt =

			moved =
			newIndex =

			lastEl =
			lastCSS =

			putSortable =
			activeGroup =
			Sortable.active = null;

			savedInputChecked.forEach(function (el) {
				el.checked = true;
			});
			savedInputChecked.length = 0;
		},

		handleEvent: function (/**Event*/evt) {
			switch (evt.type) {
				case 'drop':
				case 'dragend':
					this._onDrop(evt);
					break;

				case 'dragover':
				case 'dragenter':
					if (dragEl) {
						this._onDragOver(evt);
						_globalDragOver(evt);
					}
					break;

				case 'selectstart':
					evt.preventDefault();
					break;
			}
		},


		/**
		 * Serializes the item into an array of string.
		 * @returns {String[]}
		 */
		toArray: function () {
			var order = [],
				el,
				children = this.el.children,
				i = 0,
				n = children.length,
				options = this.options;

			for (; i < n; i++) {
				el = children[i];
				if (_closest(el, options.draggable, this.el)) {
					order.push(el.getAttribute(options.dataIdAttr) || _generateId(el));
				}
			}

			return order;
		},


		/**
		 * Sorts the elements according to the array.
		 * @param  {String[]}  order  order of the items
		 */
		sort: function (order) {
			var items = {}, rootEl = this.el;

			this.toArray().forEach(function (id, i) {
				var el = rootEl.children[i];

				if (_closest(el, this.options.draggable, rootEl)) {
					items[id] = el;
				}
			}, this);

			order.forEach(function (id) {
				if (items[id]) {
					rootEl.removeChild(items[id]);
					rootEl.appendChild(items[id]);
				}
			});
		},


		/**
		 * Save the current sorting
		 */
		save: function () {
			var store = this.options.store;
			store && store.set(this);
		},


		/**
		 * For each element in the set, get the first element that matches the selector by testing the element itself and traversing up through its ancestors in the DOM tree.
		 * @param   {HTMLElement}  el
		 * @param   {String}       [selector]  default: `options.draggable`
		 * @returns {HTMLElement|null}
		 */
		closest: function (el, selector) {
			return _closest(el, selector || this.options.draggable, this.el);
		},


		/**
		 * Set/get option
		 * @param   {string} name
		 * @param   {*}      [value]
		 * @returns {*}
		 */
		option: function (name, value) {
			var options = this.options;

			if (value === void 0) {
				return options[name];
			} else {
				options[name] = value;

				if (name === 'group') {
					_prepareGroup(options);
				}
			}
		},


		/**
		 * Destroy
		 */
		destroy: function () {
			var el = this.el;

			el[expando] = null;

			_off(el, 'mousedown', this._onTapStart);
			_off(el, 'touchstart', this._onTapStart);
			_off(el, 'pointerdown', this._onTapStart);

			if (this.nativeDraggable) {
				_off(el, 'dragover', this);
				_off(el, 'dragenter', this);
			}

			// Remove draggable attributes
			Array.prototype.forEach.call(el.querySelectorAll('[draggable]'), function (el) {
				el.removeAttribute('draggable');
			});

			touchDragOverListeners.splice(touchDragOverListeners.indexOf(this._onDragOver), 1);

			this._onDrop();

			this.el = el = null;
		}
	};


	function _cloneHide(sortable, state) {
		if (sortable.lastPullMode !== 'clone') {
			state = true;
		}

		if (cloneEl && (cloneEl.state !== state)) {
			_css(cloneEl, 'display', state ? 'none' : '');

			if (!state) {
				if (cloneEl.state) {
					if (sortable.options.group.revertClone) {
						rootEl.insertBefore(cloneEl, nextEl);
						sortable._animate(dragEl, cloneEl);
					} else {
						rootEl.insertBefore(cloneEl, dragEl);
					}
				}
			}

			cloneEl.state = state;
		}
	}


	function _closest(/**HTMLElement*/el, /**String*/selector, /**HTMLElement*/ctx) {
		if (el) {
			ctx = ctx || document;

			do {
				if ((selector === '>*' && el.parentNode === ctx) || _matches(el, selector)) {
					return el;
				}
				/* jshint boss:true */
			} while (el = _getParentOrHost(el));
		}

		return null;
	}


	function _getParentOrHost(el) {
		var parent = el.host;

		return (parent && parent.nodeType) ? parent : el.parentNode;
	}


	function _globalDragOver(/**Event*/evt) {
		if (evt.dataTransfer) {
			evt.dataTransfer.dropEffect = 'move';
		}
		evt.preventDefault();
	}


	function _on(el, event, fn) {
		el.addEventListener(event, fn, captureMode);
	}


	function _off(el, event, fn) {
		el.removeEventListener(event, fn, captureMode);
	}


	function _toggleClass(el, name, state) {
		if (el) {
			if (el.classList) {
				el.classList[state ? 'add' : 'remove'](name);
			}
			else {
				var className = (' ' + el.className + ' ').replace(R_SPACE, ' ').replace(' ' + name + ' ', ' ');
				el.className = (className + (state ? ' ' + name : '')).replace(R_SPACE, ' ');
			}
		}
	}


	function _css(el, prop, val) {
		var style = el && el.style;

		if (style) {
			if (val === void 0) {
				if (document.defaultView && document.defaultView.getComputedStyle) {
					val = document.defaultView.getComputedStyle(el, '');
				}
				else if (el.currentStyle) {
					val = el.currentStyle;
				}

				return prop === void 0 ? val : val[prop];
			}
			else {
				if (!(prop in style)) {
					prop = '-webkit-' + prop;
				}

				style[prop] = val + (typeof val === 'string' ? '' : 'px');
			}
		}
	}


	function _find(ctx, tagName, iterator) {
		if (ctx) {
			var list = ctx.getElementsByTagName(tagName), i = 0, n = list.length;

			if (iterator) {
				for (; i < n; i++) {
					iterator(list[i], i);
				}
			}

			return list;
		}

		return [];
	}



	function _dispatchEvent(sortable, rootEl, name, targetEl, fromEl, startIndex, newIndex) {
		sortable = (sortable || rootEl[expando]);

		var evt = document.createEvent('Event'),
			options = sortable.options,
			onName = 'on' + name.charAt(0).toUpperCase() + name.substr(1);

		evt.initEvent(name, true, true);

		evt.to = rootEl;
		evt.from = fromEl || rootEl;
		evt.item = targetEl || rootEl;
		evt.clone = cloneEl;

		evt.oldIndex = startIndex;
		evt.newIndex = newIndex;

		rootEl.dispatchEvent(evt);

		if (options[onName]) {
			options[onName].call(sortable, evt);
		}
	}


	function _onMove(fromEl, toEl, dragEl, dragRect, targetEl, targetRect, originalEvt) {
		var evt,
			sortable = fromEl[expando],
			onMoveFn = sortable.options.onMove,
			retVal;

		evt = document.createEvent('Event');
		evt.initEvent('move', true, true);

		evt.to = toEl;
		evt.from = fromEl;
		evt.dragged = dragEl;
		evt.draggedRect = dragRect;
		evt.related = targetEl || toEl;
		evt.relatedRect = targetRect || toEl.getBoundingClientRect();

		fromEl.dispatchEvent(evt);

		if (onMoveFn) {
			retVal = onMoveFn.call(sortable, evt, originalEvt);
		}

		return retVal;
	}


	function _disableDraggable(el) {
		el.draggable = false;
	}


	function _unsilent() {
		_silent = false;
	}


	/** @returns {HTMLElement|false} */
	function _ghostIsLast(el, evt) {
		var lastEl = el.lastElementChild,
			rect = lastEl.getBoundingClientRect();

		// 5 — min delta
		// abs — нельзя добавлять, а то глюки при наведении сверху
		return (
			(evt.clientY - (rect.top + rect.height) > 5) ||
			(evt.clientX - (rect.right + rect.width) > 5)
		) && lastEl;
	}


	/**
	 * Generate id
	 * @param   {HTMLElement} el
	 * @returns {String}
	 * @private
	 */
	function _generateId(el) {
		var str = el.tagName + el.className + el.src + el.href + el.textContent,
			i = str.length,
			sum = 0;

		while (i--) {
			sum += str.charCodeAt(i);
		}

		return sum.toString(36);
	}

	/**
	 * Returns the index of an element within its parent for a selected set of
	 * elements
	 * @param  {HTMLElement} el
	 * @param  {selector} selector
	 * @return {number}
	 */
	function _index(el, selector) {
		var index = 0;

		if (!el || !el.parentNode) {
			return -1;
		}

		while (el && (el = el.previousElementSibling)) {
			if ((el.nodeName.toUpperCase() !== 'TEMPLATE') && (selector === '>*' || _matches(el, selector))) {
				index++;
			}
		}

		return index;
	}

	function _matches(/**HTMLElement*/el, /**String*/selector) {
		if (el) {
			selector = selector.split('.');

			var tag = selector.shift().toUpperCase(),
				re = new RegExp('\\s(' + selector.join('|') + ')(?=\\s)', 'g');

			return (
				(tag === '' || el.nodeName.toUpperCase() == tag) &&
				(!selector.length || ((' ' + el.className + ' ').match(re) || []).length == selector.length)
			);
		}

		return false;
	}

	function _throttle(callback, ms) {
		var args, _this;

		return function () {
			if (args === void 0) {
				args = arguments;
				_this = this;

				setTimeout(function () {
					if (args.length === 1) {
						callback.call(_this, args[0]);
					} else {
						callback.apply(_this, args);
					}

					args = void 0;
				}, ms);
			}
		};
	}

	function _extend(dst, src) {
		if (dst && src) {
			for (var key in src) {
				if (src.hasOwnProperty(key)) {
					dst[key] = src[key];
				}
			}
		}

		return dst;
	}

	function _clone(el) {
		return $
			? $(el).clone(true)[0]
			: (Polymer && Polymer.dom
				? Polymer.dom(el).cloneNode(true)
				: el.cloneNode(true)
			);
	}

	function _saveInputCheckedState(root) {
		var inputs = root.getElementsByTagName('input');
		var idx = inputs.length;

		while (idx--) {
			var el = inputs[idx];
			el.checked && savedInputChecked.push(el);
		}
	}

	// Fixed #973: 
	_on(document, 'touchmove', function (evt) {
		if (Sortable.active) {
			evt.preventDefault();
		}
	});

	try {
		window.addEventListener('test', null, Object.defineProperty({}, 'passive', {
			get: function () {
				captureMode = {
					capture: false,
					passive: false
				};
			}
		}));
	} catch (err) {}

	// Export utils
	Sortable.utils = {
		on: _on,
		off: _off,
		css: _css,
		find: _find,
		is: function (el, selector) {
			return !!_closest(el, selector, el);
		},
		extend: _extend,
		throttle: _throttle,
		closest: _closest,
		toggleClass: _toggleClass,
		clone: _clone,
		index: _index
	};


	/**
	 * Create sortable instance
	 * @param {HTMLElement}  el
	 * @param {Object}      [options]
	 */
	Sortable.create = function (el, options) {
		return new Sortable(el, options);
	};


	// Export
	Sortable.version = '1.5.1';
	return Sortable;
});


/***/ }),

/***/ 492:
/***/ (function(module, exports, __webpack_require__) {


/* styles */
__webpack_require__(557)

var Component = __webpack_require__(3)(
  /* script */
  __webpack_require__(417),
  /* template */
  __webpack_require__(523),
  /* scopeId */
  "data-v-be9e26c6",
  /* cssModules */
  null
)
Component.options.__file = "D:\\IDEAWorkDir\\CCOD\\BLB\\ems\\WebRoot\\vue-static\\src\\list-field-config\\field-info-item.vue"
if (Component.esModule && Object.keys(Component.esModule).some(function (key) {return key !== "default" && key !== "__esModule"})) {console.error("named exports are not supported in *.vue files.")}
if (Component.options.functional) {console.error("[vue-loader] field-info-item.vue: functional components are not supported with templates, they should use render functions.")}

/* hot reload */
if (false) {(function () {
  var hotAPI = require("vue-hot-reload-api")
  hotAPI.install(require("vue"), false)
  if (!hotAPI.compatible) return
  module.hot.accept()
  if (!module.hot.data) {
    hotAPI.createRecord("data-v-be9e26c6", Component.options)
  } else {
    hotAPI.reload("data-v-be9e26c6", Component.options)
  }
})()}

module.exports = Component.exports


/***/ }),

/***/ 501:
/***/ (function(module, exports, __webpack_require__) {

module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
  return _c('div', {
    staticClass: "list-field-config__root"
  }, [_c('page-header', [_c('ul', {
    staticClass: "list-field-config__breadcrumbs",
    slot: "topContent"
  }, [_c('li', {
    staticClass: "list-field-config__breadcrumbs-item"
  }, [_c('router-link', {
    attrs: {
      "to": "/list-field-config",
      "active-class": "list-field-config__router-link-active"
    }
  }, [_vm._v(_vm._s(_vm.topTitle))])], 1)])]), _vm._v(" "), _c('div', {
    staticClass: "container-fluid list-field-config__main"
  }, [_c('div', {
    staticClass: "panel list-field-config__section-contain"
  }, [_c('div', {
    staticClass: "list-field-config__section-box"
  }, [_c('header', {
    staticClass: "list-field-config__section-header list-field-config__header__reset list-field-config__clear"
  }, [_c('h5', {
    staticClass: "list-field-config__section-title active list-field-config__h5__reset"
  }, [_vm._v("启用的字段（" + _vm._s(_vm.activeList.length) + "）")]), _vm._v(" "), _c('a', {
    staticClass: "list-field-config__section-btn fr success",
    staticStyle: {
      "margin-right": "23px"
    },
    attrs: {
      "href": "#/list-field-config/select-custom-field"
    }
  }, [_vm._v("添加自定义字段")])]), _vm._v(" "), _c('draggable', {
    staticClass: "list-field-config__field-list list-field-config__ul__set",
    attrs: {
      "list": _vm.activeList,
      "element": "ul"
    },
    on: {
      "end": _vm.dragSort
    }
  }, [_vm._l((_vm.activeList), function(fieldInfo) {
    return [_c('field-info-item', {
      attrs: {
        "field-info": fieldInfo,
        "is-active": true,
        "type-desc": "名单字段"
      },
      on: {
        "delete-field": function($event) {
          _vm.changeField('delete', arguments[0])
        },
        "unactive-field": function($event) {
          _vm.changeField('deactive', arguments[0])
        },
        "active-field": function($event) {
          _vm.changeField('active', arguments[0])
        },
        "edit-field": function($event) {
          _vm.editField(arguments[0])
        }
      }
    })]
  })], 2)], 1), _vm._v(" "), _c('div', {
    staticClass: "list-field-config__section-box"
  }, [_c('header', {
    staticClass: "list-field-config__section-header list-field-config__header__reset list-field-config__clear"
  }, [_c('h5', {
    staticClass: "list-field-config__section-title unactive list-field-config__h5__reset"
  }, [_vm._v("未启用的字段（" + _vm._s(_vm.deactiveNameList.length) + "）")])]), _vm._v(" "), _c('ul', {
    staticClass: "list-field-config__field-list list-field-config__ul__set"
  }, [_vm._l((_vm.deactiveNameList), function(fieldInfo) {
    return [_c('field-info-item', {
      attrs: {
        "field-info": fieldInfo,
        "is-active": false,
        "type-desc": "名单字段"
      },
      on: {
        "delete-field": function($event) {
          _vm.changeField('delete', arguments[0])
        },
        "unactive-field": function($event) {
          _vm.changeField('deactive', arguments[0])
        },
        "active-field": function($event) {
          _vm.changeField('active', arguments[0])
        },
        "edit-field": function($event) {
          _vm.editField(arguments[0])
        }
      }
    })]
  })], 2)])])])], 1)
},staticRenderFns: []}
module.exports.render._withStripped = true
if (false) {
  module.hot.accept()
  if (module.hot.data) {
     require("vue-hot-reload-api").rerender("data-v-1788c522", module.exports)
  }
}

/***/ }),

/***/ 506:
/***/ (function(module, exports, __webpack_require__) {

module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
  return _c('div', {
    staticClass: "edit-custom-field__root"
  }, [_c('page-header', [_c('ul', {
    staticClass: "list-field-config__breadcrumbs",
    slot: "topContent"
  }, [_c('li', {
    staticClass: "list-field-config__breadcrumbs-item"
  }, [_c('a', {
    staticClass: "list-field-config__router-link-active",
    attrs: {
      "href": "#/list-field-config"
    }
  }, [_vm._v(_vm._s(_vm.topTitle))])]), _vm._v(" "), (_vm.changeType === 'add') ? [_c('li', {
    staticClass: "list-field-config__breadcrumbs-item"
  }, [_c('a', {
    staticClass: "list-field-config__router-link-active",
    attrs: {
      "href": "#/list-field-config/select-custom-field"
    }
  }, [_vm._v("选择字段类型")])])] : _vm._e(), _vm._v(" "), _c('li', {
    staticClass: "list-field-config__breadcrumbs-item"
  }, [_c('a', {
    staticClass: "list-field-config__router-link-active",
    attrs: {
      "href": "javascript:void(0);"
    }
  }, [_vm._v(_vm._s(_vm.changeType === 'add' ? '添加' : '编辑') + ":[" + _vm._s(_vm.fieldTypeName) + "]")])])], 2)]), _vm._v(" "), _c('div', {
    staticClass: "edit-custom-field__main container-fluid"
  }, [_c('div', {
    staticClass: "panel"
  }, [_c('div', {
    staticClass: "edit-custom-field__content"
  }, [_c('div', {
    staticClass: "edit-custom-field__section-common"
  }, [_c('h4', {
    staticClass: "edit-custom-field__section-common-title"
  }, [_vm._v("显示标题")]), _vm._v(" "), _c('input', {
    directives: [{
      name: "model",
      rawName: "v-model.trim",
      value: (_vm.commonField.name),
      expression: "commonField.name",
      modifiers: {
        "trim": true
      }
    }],
    staticClass: "edit-custom-field__section-common-input field__focus",
    attrs: {
      "type": "text"
    },
    domProps: {
      "value": (_vm.commonField.name)
    },
    on: {
      "input": function($event) {
        if ($event.target.composing) { return; }
        _vm.commonField.name = $event.target.value.trim()
      },
      "blur": function($event) {
        _vm.$forceUpdate()
      }
    }
  }), _vm._v(" "), _c('p', {
    staticClass: "edit-custom-field__des"
  }, [_vm._v("在客户信息页上显示的标题")]), _vm._v(" "), _c('label', {
    staticClass: "edit-custom-field__section-common-checkbox"
  }, [_c('input', {
    directives: [{
      name: "model",
      rawName: "v-model",
      value: (_vm.commonField.isRequired),
      expression: "commonField.isRequired"
    }],
    attrs: {
      "type": "checkbox"
    },
    domProps: {
      "checked": Array.isArray(_vm.commonField.isRequired) ? _vm._i(_vm.commonField.isRequired, null) > -1 : (_vm.commonField.isRequired)
    },
    on: {
      "__c": function($event) {
        var $$a = _vm.commonField.isRequired,
          $$el = $event.target,
          $$c = $$el.checked ? (true) : (false);
        if (Array.isArray($$a)) {
          var $$v = null,
            $$i = _vm._i($$a, $$v);
          if ($$c) {
            $$i < 0 && (_vm.commonField.isRequired = $$a.concat($$v))
          } else {
            $$i > -1 && (_vm.commonField.isRequired = $$a.slice(0, $$i).concat($$a.slice($$i + 1)))
          }
        } else {
          _vm.commonField.isRequired = $$c
        }
      }
    }
  }), _vm._v(" 是否必填")]), _vm._v(" "), _c('h4', {
    staticClass: "edit-custom-field__section-common-title"
  }, [_vm._v("描述（可选）")]), _vm._v(" "), _c('textarea', {
    directives: [{
      name: "model",
      rawName: "v-model.trim",
      value: (_vm.commonField.remark),
      expression: "commonField.remark",
      modifiers: {
        "trim": true
      }
    }],
    staticClass: "edit-custom-field__section-common-textarea edit-custom-field__field__focus",
    domProps: {
      "value": (_vm.commonField.remark)
    },
    on: {
      "input": function($event) {
        if ($event.target.composing) { return; }
        _vm.commonField.remark = $event.target.value.trim()
      },
      "blur": function($event) {
        _vm.$forceUpdate()
      }
    }
  }), _vm._v(" "), _c('p', {
    staticClass: "edit-custom-field__des"
  }, [_vm._v("该字段在客户信息页上的描述信息")])]), _vm._v(" "), (_vm.fieldTypeDesc === 'select' || _vm.fieldTypeDesc === 'checkbox') ? _c('div', {
    staticClass: "edit-custom-field__panel-section"
  }, [_c('h4', {
    staticClass: "edit-custom-field__panel-section-title"
  }, [_vm._v(_vm._s(_vm.fieldTypeDesc === 'select' ? '下拉菜单选项' : '复选框选项'))]), _vm._v(" "), _c('div', {
    staticClass: "edit-custom-field__panel-section-content"
  }, [_c('ul', {
    staticClass: "edit-custom-field__panel-section-lists"
  }, _vm._l((_vm.fieldItemArr), function(item, $index) {
    return _c('li', {
      staticClass: "edit-custom-field__panel-section-lists-item"
    }, [_c('input', {
      staticClass: "edit-custom-field__panel-section-input edit-custom-field__field__focus",
      attrs: {
        "type": "text",
        "placeholder": "请输入选项内容"
      },
      domProps: {
        "value": item
      },
      on: {
        "input": function($event) {
          if (!('button' in $event) && _vm._k($event.keyCode, "lazy")) { return null; }
          _vm.fieldItemArr[$index] = $event.target.value
        }
      }
    }), _vm._v(" "), _c('a', {
      staticClass: "edit-custom-field__panel-section-remove",
      attrs: {
        "href": "javascript:void(0);"
      },
      on: {
        "click": function($event) {
          _vm.fieldItemArr.splice($index, 1)
        }
      }
    }, [_vm._v("-")])])
  })), _vm._v(" "), _c('a', {
    staticClass: "edit-custom-field__panel-section-add",
    attrs: {
      "href": "javascript:void(0);"
    },
    on: {
      "click": function($event) {
        _vm.fieldItemArr.push('')
      }
    }
  }, [_c('span', {
    staticClass: "edit-custom-field__panel-section-addicon"
  }, [_vm._v("+")]), _vm._v(" 添加下拉菜单选项")])])]) : (_vm.fieldTypeDesc === 'regexp') ? _c('div', {
    staticClass: "edit-custom-field__panel-section"
  }, [_c('h4', {
    staticClass: "edit-custom-field__panel-section-title"
  }, [_vm._v("正则匹配字段")]), _vm._v(" "), _c('div', {
    staticClass: "edit-custom-field__panel-section-content"
  }, [_c('h4', {
    staticClass: "edit-custom-field__section-common-title"
  }, [_vm._v("请在这里输入正则表达式的规则")]), _vm._v(" "), _c('input', {
    staticClass: "edit-custom-field__panel-section-input edit-custom-field__field__focus",
    attrs: {
      "type": "text"
    },
    domProps: {
      "value": _vm.fieldItemArr[0]
    },
    on: {
      "input": function($event) {
        if (!('button' in $event) && _vm._k($event.keyCode, "lazy")) { return null; }
        _vm.fieldItemArr.splice(0, 1, $event.target.value)
      }
    }
  }), _vm._v(" "), _c('p', {
    staticClass: "edit-custom-field__des"
  }, [_vm._v("例如qq号码：^[1-9]\\d{4,9}$ "), _c('a', {
    attrs: {
      "href": "javascript:void(0)"
    },
    on: {
      "click": _vm.searchRegexp
    }
  }, [_vm._v("查看更多常用正则表达式范例")])])])]) : (_vm.fieldTypeDesc === 'datetime') ? _c('div', {
    staticClass: "edit-custom-field__panel-section"
  }, [_c('h4', {
    staticClass: "edit-custom-field__panel-section-title"
  }, [_vm._v("日期时间格式")]), _vm._v(" "), _c('div', {
    staticClass: "edit-custom-field__panel-section-content"
  }, [_c('select', {
    staticClass: "edit-custom-field__panel-section-select edit-custom-field__field__focus",
    domProps: {
      "value": _vm.fieldItemArr[0]
    },
    on: {
      "input": function($event) {
        if (!('button' in $event) && _vm._k($event.keyCode, "lazy")) { return null; }
        _vm.fieldItemArr.splice(0, 1, $event.target.value)
      }
    }
  }, [_c('option', {
    attrs: {
      "value": "yyyy/MM/dd hh:mm:ss"
    }
  }, [_vm._v("年/月/日  时:分:秒")]), _vm._v(" "), _c('option', {
    attrs: {
      "value": "yyyy-MM-dd hh:mm:ss"
    }
  }, [_vm._v("年-月-日  时:分:秒")]), _vm._v(" "), _c('option', {
    attrs: {
      "value": "yyyy/MM/dd"
    }
  }, [_vm._v("年/月/日")]), _vm._v(" "), _c('option', {
    attrs: {
      "value": "yyyy-MM-dd"
    }
  }, [_vm._v("年-月-日")])])])]) : _vm._e(), _vm._v(" "), _c('div', {
    staticClass: "edit-custom-field__panel-section-operation"
  }, [_c('a', {
    staticClass: "btn btn-sm btn-raised",
    attrs: {
      "href": _vm.cancelHref
    }
  }, [_vm._v("取消")]), _vm._v(" "), _c('a', {
    staticClass: "btn btn-sm btn-raised btn-primary",
    attrs: {
      "href": "javascript:void(0)"
    },
    on: {
      "click": _vm.submitField
    }
  }, [_vm._v("提交")])])])])])], 1)
},staticRenderFns: []}
module.exports.render._withStripped = true
if (false) {
  module.hot.accept()
  if (module.hot.data) {
     require("vue-hot-reload-api").rerender("data-v-28e6d8df", module.exports)
  }
}

/***/ }),

/***/ 523:
/***/ (function(module, exports, __webpack_require__) {

module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
  return _c('li', {
    staticClass: "list-field-config__clear field-info-item__root"
  }, [_c('div', {
    class: [{
      'field-info-item__text-unactive': !_vm.isActive
    }, 'col-sm-2'],
    attrs: {
      "id": "userName"
    }
  }, [_vm._v(_vm._s(_vm.fieldInfo.name))]), _vm._v(" "), _c('div', {
    staticClass: "col-md-2 field-info-item__text-unactive"
  }, [_vm._v(_vm._s(_vm.fieldInfo.componentTypeStr))]), _vm._v(" "), _c('div', {
    staticClass: "col-md-2 field-info-item__text-unactive"
  }, [_vm._v(_vm._s(_vm.fieldInfo.defineType))]), _vm._v(" "), _c('div', {
    staticClass: "col-md-1 field-info-item__text-unactive"
  }, [_vm._v(_vm._s(_vm.fieldInfo.isRequiredStr))]), _vm._v(" "), _c('div', {
    staticClass: "col-md-2 field-info-item__text-unactive"
  }, [_vm._v(_vm._s(_vm.typeDesc) + "\n")]), _vm._v(" "), _c('div', {
    staticClass: "col-md-3",
    staticStyle: {
      "text-align": "right"
    }
  }, [(_vm.fieldInfo.isDefault || _vm.typeDesc === '客户字段') ? [_c('a', {
    staticClass: "list-field-config__section-btn",
    attrs: {
      "href": "javascript:void(0);",
      "disabled": ""
    }
  }, [_vm._v("无法编辑")])] : [(_vm.isActive) ? [_c('a', {
    staticClass: "list-field-config__section-btn danger",
    attrs: {
      "href": ""
    },
    on: {
      "click": function($event) {
        $event.preventDefault();
        _vm.changeField('unactive-field')
      }
    }
  }, [_vm._v("停用")]), _vm._v(" "), _c('a', {
    staticClass: "list-field-config__section-btn",
    attrs: {
      "href": ""
    },
    on: {
      "click": function($event) {
        $event.preventDefault();
        _vm.editField($event)
      }
    }
  }, [_vm._v("编辑")])] : [_c('a', {
    staticClass: "list-field-config__section-btn danger",
    attrs: {
      "href": ""
    },
    on: {
      "click": function($event) {
        $event.preventDefault();
        _vm.changeField('delete-field')
      }
    }
  }, [_vm._v("删除")]), _vm._v(" "), _c('a', {
    staticClass: "list-field-config__section-btn success",
    attrs: {
      "href": ""
    },
    on: {
      "click": function($event) {
        $event.preventDefault();
        _vm.changeField('active-field')
      }
    }
  }, [_vm._v("启用")]), _vm._v(" "), _c('a', {
    staticClass: "list-field-config__section-btn",
    attrs: {
      "href": ""
    },
    on: {
      "click": function($event) {
        $event.preventDefault();
        _vm.editField($event)
      }
    }
  }, [_vm._v("编辑")])]]], 2)])
},staticRenderFns: []}
module.exports.render._withStripped = true
if (false) {
  module.hot.accept()
  if (module.hot.data) {
     require("vue-hot-reload-api").rerender("data-v-be9e26c6", module.exports)
  }
}

/***/ }),

/***/ 526:
/***/ (function(module, exports, __webpack_require__) {

module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
  return _c('div', {
    staticClass: "select-custom-field__root"
  }, [_c('page-header', [_c('ul', {
    staticClass: "list-field-config__breadcrumbs",
    slot: "topContent"
  }, [_c('li', {
    staticClass: "list-field-config__breadcrumbs-item"
  }, [_c('router-link', {
    attrs: {
      "to": "/list-field-config",
      "active-class": "list-field-config__router-link-active"
    }
  }, [_vm._v(_vm._s(_vm.topTitle))])], 1), _vm._v(" "), _c('li', {
    staticClass: "list-field-config__breadcrumbs-item"
  }, [_c('router-link', {
    attrs: {
      "to": "/list-field-config/select-custom-field",
      "active-class": "list-field-config__router-link-active"
    }
  }, [_vm._v("选择字段类型")])], 1)])]), _vm._v(" "), _c('div', {
    staticClass: "select-custom-field__main container-fluid"
  }, [_c('div', {
    staticClass: "panel"
  }, [_c('div', {
    staticClass: "select-custom-field__panel-box"
  }, [_c('div', {
    staticClass: "select-custom-field__panel-section"
  }, [_c('h4', {
    staticClass: "select-custom-field__panel-section-title"
  }, [_vm._v("文本框")]), _vm._v(" "), _c('div', {
    staticClass: "select-custom-field__panel-section-content"
  }, [_c('a', {
    staticClass: "btn btn-sm btn-raised btn-primary pull-right",
    attrs: {
      "href": ""
    },
    on: {
      "click": function($event) {
        $event.preventDefault();
        _vm.selectType('1')
      }
    }
  }, [_vm._v("选择此字段")]), _vm._v(" "), _c('input', {
    staticClass: "select-custom-field__panel-section-input select-custom-field__panel-section__focus",
    attrs: {
      "value": "文本框里的文字",
      "type": "text"
    }
  }), _vm._v(" "), _c('p', {
    staticClass: "select-custom-field__panel-section-des"
  }, [_vm._v("\n                            文本框字段可以填写少量的文字\n                        ")])])]), _vm._v(" "), _c('div', {
    staticClass: "select-custom-field__panel-section"
  }, [_c('h4', {
    staticClass: "select-custom-field__panel-section-title"
  }, [_vm._v("文本区域")]), _vm._v(" "), _c('div', {
    staticClass: "select-custom-field__panel-section-content"
  }, [_c('a', {
    staticClass: "btn btn-sm btn-raised btn-primary pull-right",
    attrs: {
      "href": ""
    },
    on: {
      "click": function($event) {
        $event.preventDefault();
        _vm.selectType('2')
      }
    }
  }, [_vm._v("选择此字段")]), _vm._v(" "), _c('textarea', {
    staticClass: "select-custom-field__panel-section-textarea select-custom-field__panel-section__focus"
  }, [_vm._v("文本区域里的文字")]), _vm._v(" "), _c('p', {
    staticClass: "select-custom-field__panel-section-des"
  }, [_vm._v("\n                            文本区域字段可以填写多行文字及说明\n                        ")])])]), _vm._v(" "), _c('div', {
    staticClass: "select-custom-field__panel-section"
  }, [_c('h4', {
    staticClass: "select-custom-field__panel-section-title"
  }, [_vm._v("下拉菜单")]), _vm._v(" "), _c('div', {
    staticClass: "select-custom-field__panel-section-content"
  }, [_c('a', {
    staticClass: "btn btn-sm btn-raised btn-primary pull-right",
    attrs: {
      "href": ""
    },
    on: {
      "click": function($event) {
        $event.preventDefault();
        _vm.selectType('3')
      }
    }
  }, [_vm._v("选择此字段")]), _vm._v(" "), _vm._m(0), _vm._v(" "), _c('p', {
    staticClass: "select-custom-field__panel-section-des"
  }, [_vm._v("\n                            基本的下拉菜单字段，可以设置多个下拉选项\n                        ")])])]), _vm._v(" "), _c('div', {
    staticClass: "select-custom-field__panel-section"
  }, [_c('h4', {
    staticClass: "select-custom-field__panel-section-title"
  }, [_vm._v("复选框")]), _vm._v(" "), _c('div', {
    staticClass: "select-custom-field__panel-section-content"
  }, [_c('a', {
    staticClass: "btn btn-sm btn-raised btn-primary pull-right",
    attrs: {
      "href": ""
    },
    on: {
      "click": function($event) {
        $event.preventDefault();
        _vm.selectType('4')
      }
    }
  }, [_vm._v("选择此字段")]), _vm._v(" "), _vm._m(1), _vm._v(" "), _vm._m(2), _vm._v(" "), _vm._m(3), _vm._v(" "), _vm._m(4), _vm._v(" "), _c('p', {
    staticClass: "select-custom-field__panel-section-des"
  }, [_vm._v("复选框字段可以设置多个能同时选中的选项")])])]), _vm._v(" "), _c('div', {
    staticClass: "select-custom-field__panel-section"
  }, [_c('h4', {
    staticClass: "select-custom-field__panel-section-title"
  }, [_vm._v("数字")]), _vm._v(" "), _c('div', {
    staticClass: "select-custom-field__panel-section-content"
  }, [_c('a', {
    staticClass: "btn btn-sm btn-raised btn-primary pull-right",
    attrs: {
      "href": ""
    },
    on: {
      "click": function($event) {
        $event.preventDefault();
        _vm.selectType('6')
      }
    }
  }, [_vm._v("选择此字段")]), _vm._v(" "), _c('input', {
    staticClass: "select-custom-field__panel-section-input select-custom-field__panel-section__focus",
    attrs: {
      "value": "123456",
      "type": "number"
    }
  }), _vm._v(" "), _c('p', {
    staticClass: "select-custom-field__panel-section-des"
  }, [_vm._v("这里仅可以填写数字")])])]), _vm._v(" "), _c('div', {
    staticClass: "select-custom-field__panel-section"
  }, [_c('h4', {
    staticClass: "select-custom-field__panel-section-title"
  }, [_vm._v("小数")]), _vm._v(" "), _c('div', {
    staticClass: "select-custom-field__panel-section-content"
  }, [_c('a', {
    staticClass: "btn btn-sm btn-raised btn-primary pull-right",
    attrs: {
      "href": ""
    },
    on: {
      "click": function($event) {
        $event.preventDefault();
        _vm.selectType('7')
      }
    }
  }, [_vm._v("选择此字段")]), _vm._v(" "), _c('input', {
    staticClass: "select-custom-field__panel-section-input select-custom-field__panel-section__focus",
    attrs: {
      "value": "34.56",
      "type": "number"
    }
  }), _vm._v(" "), _c('p', {
    staticClass: "select-custom-field__panel-section-des"
  }, [_vm._v("这里仅可以填写小数")])])]), _vm._v(" "), _c('div', {
    staticClass: "select-custom-field__panel-section"
  }, [_c('h4', {
    staticClass: "select-custom-field__panel-section-title"
  }, [_vm._v("正则匹配字段")]), _vm._v(" "), _c('div', {
    staticClass: "select-custom-field__panel-section-content"
  }, [_c('a', {
    staticClass: "btn btn-sm btn-raised btn-primary pull-right",
    attrs: {
      "href": ""
    },
    on: {
      "click": function($event) {
        $event.preventDefault();
        _vm.selectType('8')
      }
    }
  }, [_vm._v("选择此字段")]), _vm._v(" "), _c('input', {
    staticClass: "select-custom-field__panel-section-input select-custom-field__panel-section__focus",
    attrs: {
      "value": "A-Za-z[1234567890]",
      "type": "text"
    }
  }), _vm._v(" "), _c('p', {
    staticClass: "select-custom-field__panel-section-des"
  }, [_vm._v("\n                            这里可以设置固定的正则匹配规则来限定文本框填写的内容\n                        ")])])]), _vm._v(" "), _c('div', {
    staticClass: "select-custom-field__panel-section"
  }, [_c('h4', {
    staticClass: "select-custom-field__panel-section-title"
  }, [_vm._v("电话号码")]), _vm._v(" "), _c('div', {
    staticClass: "select-custom-field__panel-section-content"
  }, [_c('a', {
    staticClass: "btn btn-sm btn-raised btn-primary pull-right",
    attrs: {
      "href": ""
    },
    on: {
      "click": function($event) {
        $event.preventDefault();
        _vm.selectType('9')
      }
    }
  }, [_vm._v("选择此字段")]), _vm._v(" "), _c('input', {
    staticClass: "select-custom-field__panel-section-input select-custom-field__panel-section__focus",
    attrs: {
      "type": "number",
      "value": ""
    }
  }), _vm._v(" "), _c('p', {
    staticClass: "select-custom-field__panel-section-des"
  }, [_vm._v("\n                            这里可以设置手机号和座机号(只要是数字，且位数为7,8,11,12位其中一个都可以)")])])]), _vm._v(" "), _c('div', {
    staticClass: "select-custom-field__panel-section"
  }, [_c('h4', {
    staticClass: "select-custom-field__panel-section-title"
  }, [_vm._v("时间输入框")]), _vm._v(" "), _c('div', {
    staticClass: "select-custom-field__panel-section-content"
  }, [_c('a', {
    staticClass: "z1 btn btn-sm btn-raised btn-primary pull-right",
    attrs: {
      "href": ""
    },
    on: {
      "click": function($event) {
        $event.preventDefault();
        _vm.selectType('10')
      }
    }
  }, [_vm._v("选择此字段")]), _vm._v(" "), _c('input', {
    staticClass: "select-custom-field__panel-section-datetime select-custom-field__panel-section__focus select-custom-field__panel-section-input",
    attrs: {
      "type": "text",
      "id": "datetimepicker"
    }
  }), _vm._v(" "), _c('p', {
    staticClass: "select-custom-field__panel-section-des"
  }, [_vm._v("\n                            这里可以日期时间\n                        ")])])]), _vm._v(" "), _c('div', {
    staticClass: "select-custom-field__panel-section"
  }, [_c('h4', {
    staticClass: "select-custom-field__panel-section-title"
  }, [_vm._v("省市区")]), _vm._v(" "), _c('div', {
    staticClass: "select-custom-field__panel-section-content"
  }, [_c('a', {
    staticClass: "btn btn-sm btn-raised btn-primary pull-right",
    attrs: {
      "href": ""
    },
    on: {
      "click": function($event) {
        $event.preventDefault();
        _vm.selectType('11')
      }
    }
  }, [_vm._v("选择此字段")]), _vm._v(" "), _c('select', {
    staticClass: "select-custom-field__panel-section-pcas select-custom-field__panel-section__focus",
    attrs: {
      "name": "province_s",
      "id": "Company_province"
    }
  }), _vm._v(" "), _c('select', {
    staticClass: "select-custom-field__panel-section-pcas select-custom-field__panel-section__focus",
    attrs: {
      "name": "city_s",
      "id": "Company_city"
    }
  }), _vm._v(" "), _c('select', {
    staticClass: "select-custom-field__panel-section-pcas select-custom-field__panel-section__focus",
    attrs: {
      "name": "area_s",
      "id": "Company_area"
    }
  }), _vm._v(" "), _c('p', {
    staticClass: "select-custom-field__panel-section-des"
  }, [_vm._v("可以设置省市地区信息")])])])])])])], 1)
},staticRenderFns: [function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
  return _c('select', {
    staticClass: "select-custom-field__panel-section-select select-custom-field__panel-section__focus"
  }, [_c('option', [_vm._v("男")]), _vm._v(" "), _c('option', [_vm._v("女")])])
},function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
  return _c('label', {
    staticClass: "select-custom-field__panel-section-checkbox"
  }, [_c('input', {
    attrs: {
      "type": "checkbox"
    }
  }), _vm._v("\n                            产品设计\n                        ")])
},function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
  return _c('label', {
    staticClass: "select-custom-field__panel-section-checkbox"
  }, [_c('input', {
    attrs: {
      "type": "checkbox"
    }
  }), _vm._v("\n                            产品交互\n                        ")])
},function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
  return _c('label', {
    staticClass: "select-custom-field__panel-section-checkbox"
  }, [_c('input', {
    attrs: {
      "type": "checkbox"
    }
  }), _vm._v("\n                            产品技术\n                        ")])
},function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
  return _c('label', {
    staticClass: "select-custom-field__panel-section-checkbox"
  }, [_c('input', {
    attrs: {
      "type": "checkbox"
    }
  }), _vm._v("\n                            产品战略\n                        ")])
}]}
module.exports.render._withStripped = true
if (false) {
  module.hot.accept()
  if (module.hot.data) {
     require("vue-hot-reload-api").rerender("data-v-f05ecaa6", module.exports)
  }
}

/***/ }),

/***/ 533:
/***/ (function(module, exports, __webpack_require__) {

// style-loader: Adds some css to the DOM by adding a <style> tag

// load the styles
var content = __webpack_require__(451);
if(typeof content === 'string') content = [[module.i, content, '']];
if(content.locals) module.exports = content.locals;
// add the styles to the DOM
var update = __webpack_require__(15)("22f5cea2", content, false);
// Hot Module Replacement
if(false) {
 // When the styles change, update the <style> tags
 if(!content.locals) {
   module.hot.accept("!!./../../node_modules/css-loader/index.js?sourceMap!./../../node_modules/vue-loader/lib/style-rewriter.js?id=data-v-1788c522!./../../node_modules/less-loader/index.js!./../../node_modules/vue-loader/lib/selector.js?type=styles&index=0!./list-field-config.vue", function() {
     var newContent = require("!!./../../node_modules/css-loader/index.js?sourceMap!./../../node_modules/vue-loader/lib/style-rewriter.js?id=data-v-1788c522!./../../node_modules/less-loader/index.js!./../../node_modules/vue-loader/lib/selector.js?type=styles&index=0!./list-field-config.vue");
     if(typeof newContent === 'string') newContent = [[module.id, newContent, '']];
     update(newContent);
   });
 }
 // When the module is disposed, remove the <style> tags
 module.hot.dispose(function() { update(); });
}

/***/ }),

/***/ 539:
/***/ (function(module, exports, __webpack_require__) {

// style-loader: Adds some css to the DOM by adding a <style> tag

// load the styles
var content = __webpack_require__(457);
if(typeof content === 'string') content = [[module.i, content, '']];
if(content.locals) module.exports = content.locals;
// add the styles to the DOM
var update = __webpack_require__(15)("09808e7b", content, false);
// Hot Module Replacement
if(false) {
 // When the styles change, update the <style> tags
 if(!content.locals) {
   module.hot.accept("!!./../../node_modules/css-loader/index.js?sourceMap!./../../node_modules/vue-loader/lib/style-rewriter.js?id=data-v-28e6d8df&scoped=true!./../../node_modules/less-loader/index.js!./../../node_modules/vue-loader/lib/selector.js?type=styles&index=0!./edit-custom-field.vue", function() {
     var newContent = require("!!./../../node_modules/css-loader/index.js?sourceMap!./../../node_modules/vue-loader/lib/style-rewriter.js?id=data-v-28e6d8df&scoped=true!./../../node_modules/less-loader/index.js!./../../node_modules/vue-loader/lib/selector.js?type=styles&index=0!./edit-custom-field.vue");
     if(typeof newContent === 'string') newContent = [[module.id, newContent, '']];
     update(newContent);
   });
 }
 // When the module is disposed, remove the <style> tags
 module.hot.dispose(function() { update(); });
}

/***/ }),

/***/ 557:
/***/ (function(module, exports, __webpack_require__) {

// style-loader: Adds some css to the DOM by adding a <style> tag

// load the styles
var content = __webpack_require__(475);
if(typeof content === 'string') content = [[module.i, content, '']];
if(content.locals) module.exports = content.locals;
// add the styles to the DOM
var update = __webpack_require__(15)("479ceb38", content, false);
// Hot Module Replacement
if(false) {
 // When the styles change, update the <style> tags
 if(!content.locals) {
   module.hot.accept("!!./../../node_modules/css-loader/index.js?sourceMap!./../../node_modules/vue-loader/lib/style-rewriter.js?id=data-v-be9e26c6&scoped=true!./../../node_modules/less-loader/index.js!./../../node_modules/vue-loader/lib/selector.js?type=styles&index=0!./field-info-item.vue", function() {
     var newContent = require("!!./../../node_modules/css-loader/index.js?sourceMap!./../../node_modules/vue-loader/lib/style-rewriter.js?id=data-v-be9e26c6&scoped=true!./../../node_modules/less-loader/index.js!./../../node_modules/vue-loader/lib/selector.js?type=styles&index=0!./field-info-item.vue");
     if(typeof newContent === 'string') newContent = [[module.id, newContent, '']];
     update(newContent);
   });
 }
 // When the module is disposed, remove the <style> tags
 module.hot.dispose(function() { update(); });
}

/***/ }),

/***/ 560:
/***/ (function(module, exports, __webpack_require__) {

// style-loader: Adds some css to the DOM by adding a <style> tag

// load the styles
var content = __webpack_require__(478);
if(typeof content === 'string') content = [[module.i, content, '']];
if(content.locals) module.exports = content.locals;
// add the styles to the DOM
var update = __webpack_require__(15)("7f6c78fc", content, false);
// Hot Module Replacement
if(false) {
 // When the styles change, update the <style> tags
 if(!content.locals) {
   module.hot.accept("!!./../../node_modules/css-loader/index.js?sourceMap!./../../node_modules/vue-loader/lib/style-rewriter.js?id=data-v-f05ecaa6!./../../node_modules/less-loader/index.js!./../../node_modules/vue-loader/lib/selector.js?type=styles&index=0!./select-custom-field.vue", function() {
     var newContent = require("!!./../../node_modules/css-loader/index.js?sourceMap!./../../node_modules/vue-loader/lib/style-rewriter.js?id=data-v-f05ecaa6!./../../node_modules/less-loader/index.js!./../../node_modules/vue-loader/lib/selector.js?type=styles&index=0!./select-custom-field.vue");
     if(typeof newContent === 'string') newContent = [[module.id, newContent, '']];
     update(newContent);
   });
 }
 // When the module is disposed, remove the <style> tags
 module.hot.dispose(function() { update(); });
}

/***/ }),

/***/ 563:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

function _toConsumableArray(arr) { if (Array.isArray(arr)) { for (var i = 0, arr2 = Array(arr.length); i < arr.length; i++) { arr2[i] = arr[i]; } return arr2; } else { return Array.from(arr); } }

(function () {
  "use strict";

  function buildDraggable(Sortable) {
    function removeNode(node) {
      node.parentElement.removeChild(node);
    }

    function insertNodeAt(fatherNode, node, position) {
      if (position < fatherNode.children.length) {
        fatherNode.insertBefore(node, fatherNode.children[position]);
      } else {
        fatherNode.appendChild(node);
      }
    }

    function computeVmIndex(vnodes, element) {
      return vnodes.map(function (elt) {
        return elt.elm;
      }).indexOf(element);
    }

    function _computeIndexes(slots, children) {
      return !slots ? [] : Array.prototype.map.call(children, function (elt) {
        return computeVmIndex(slots, elt);
      });
    }

    function emit(evtName, evtData) {
      this.$emit(evtName.toLowerCase(), evtData);
    }

    function delegateAndEmit(evtName) {
      var _this = this;

      return function (evtData) {
        if (_this.realList !== null) {
          _this['onDrag' + evtName](evtData);
        }
        emit.call(_this, evtName, evtData);
      };
    }

    var eventsListened = ['Start', 'Add', 'Remove', 'Update', 'End'];
    var eventsToEmit = ['Choose', 'Sort', 'Filter', 'Clone'];
    var readonlyProperties = ['Move'].concat(eventsListened, eventsToEmit).map(function (evt) {
      return 'on' + evt;
    });
    var draggingElement = null;

    var props = {
      options: Object,
      list: {
        type: Array,
        required: false,
        default: null
      },
      value: {
        type: Array,
        required: false,
        default: null
      },
      clone: {
        type: Function,
        default: function _default(original) {
          return original;
        }
      },
      element: {
        type: String,
        default: 'div'
      },
      move: {
        type: Function,
        default: null
      }
    };

    var draggableComponent = {
      props: props,

      data: function data() {
        return {
          transitionMode: false
        };
      },
      render: function render(h) {
        if (this.$slots.default && this.$slots.default.length === 1) {
          var child = this.$slots.default[0];
          if (child.componentOptions && child.componentOptions.tag === "transition-group") {
            this.transitionMode = true;
          }
        }
        return h(this.element, null, this.$slots.default);
      },
      mounted: function mounted() {
        var _this2 = this;

        var optionsAdded = {};
        eventsListened.forEach(function (elt) {
          optionsAdded['on' + elt] = delegateAndEmit.call(_this2, elt);
        });

        eventsToEmit.forEach(function (elt) {
          optionsAdded['on' + elt] = emit.bind(_this2, elt);
        });

        var options = _extends({}, this.options, optionsAdded, { onMove: function onMove(evt) {
            return _this2.onDragMove(evt);
          } });
        this._sortable = new Sortable(this.rootContainer, options);
        this.computeIndexes();
      },
      beforeDestroy: function beforeDestroy() {
        this._sortable.destroy();
      },


      computed: {
        rootContainer: function rootContainer() {
          return this.transitionMode ? this.$el.children[0] : this.$el;
        },
        isCloning: function isCloning() {
          return !!this.options && !!this.options.group && this.options.group.pull === 'clone';
        },
        realList: function realList() {
          return !!this.list ? this.list : this.value;
        }
      },

      watch: {
        options: function options(newOptionValue) {
          for (var property in newOptionValue) {
            if (readonlyProperties.indexOf(property) == -1) {
              this._sortable.option(property, newOptionValue[property]);
            }
          }
        },
        realList: function realList() {
          this.computeIndexes();
        }
      },

      methods: {
        getChildrenNodes: function getChildrenNodes() {
          var rawNodes = this.$slots.default;
          return this.transitionMode ? rawNodes[0].child.$slots.default : rawNodes;
        },
        computeIndexes: function computeIndexes() {
          var _this3 = this;

          this.$nextTick(function () {
            _this3.visibleIndexes = _computeIndexes(_this3.getChildrenNodes(), _this3.rootContainer.children);
          });
        },
        getUnderlyingVm: function getUnderlyingVm(htmlElt) {
          var index = computeVmIndex(this.getChildrenNodes(), htmlElt);
          var element = this.realList[index];
          return { index: index, element: element };
        },
        getUnderlyingPotencialDraggableComponent: function getUnderlyingPotencialDraggableComponent(_ref) {
          var __vue__ = _ref.__vue__;

          if (!__vue__ || !__vue__.$options || __vue__.$options._componentTag !== "transition-group") {
            return __vue__;
          }
          return __vue__.$parent;
        },
        emitChanges: function emitChanges(evt) {
          var _this4 = this;

          this.$nextTick(function () {
            _this4.$emit('change', evt);
          });
        },
        alterList: function alterList(onList) {
          if (!!this.list) {
            onList(this.list);
          } else {
            var newList = [].concat(_toConsumableArray(this.value));
            onList(newList);
            this.$emit('input', newList);
          }
        },
        spliceList: function spliceList() {
          var _arguments = arguments;

          var spliceList = function spliceList(list) {
            return list.splice.apply(list, _arguments);
          };
          this.alterList(spliceList);
        },
        updatePosition: function updatePosition(oldIndex, newIndex) {
          var updatePosition = function updatePosition(list) {
            return list.splice(newIndex, 0, list.splice(oldIndex, 1)[0]);
          };
          this.alterList(updatePosition);
        },
        getRelatedContextFromMoveEvent: function getRelatedContextFromMoveEvent(_ref2) {
          var to = _ref2.to;
          var related = _ref2.related;

          var component = this.getUnderlyingPotencialDraggableComponent(to);
          if (!component) {
            return { component: component };
          }
          var list = component.realList;
          var context = { list: list, component: component };
          if (to !== related && list && component.getUnderlyingVm) {
            var destination = component.getUnderlyingVm(related);
            return _extends(destination, context);
          }

          return context;
        },
        getVmIndex: function getVmIndex(domIndex) {
          var indexes = this.visibleIndexes;
          var numberIndexes = indexes.length;
          return domIndex > numberIndexes - 1 ? numberIndexes : indexes[domIndex];
        },
        onDragStart: function onDragStart(evt) {
          this.context = this.getUnderlyingVm(evt.item);
          evt.item._underlying_vm_ = this.clone(this.context.element);
          draggingElement = evt.item;
        },
        onDragAdd: function onDragAdd(evt) {
          var element = evt.item._underlying_vm_;
          if (element === undefined) {
            return;
          }
          removeNode(evt.item);
          var newIndex = this.getVmIndex(evt.newIndex);
          this.spliceList(newIndex, 0, element);
          this.computeIndexes();
          var added = { element: element, newIndex: newIndex };
          this.emitChanges({ added: added });
        },
        onDragRemove: function onDragRemove(evt) {
          insertNodeAt(this.rootContainer, evt.item, evt.oldIndex);
          if (this.isCloning) {
            removeNode(evt.clone);
            return;
          }
          var oldIndex = this.context.index;
          this.spliceList(oldIndex, 1);
          var removed = { element: this.context.element, oldIndex: oldIndex };
          this.emitChanges({ removed: removed });
        },
        onDragUpdate: function onDragUpdate(evt) {
          removeNode(evt.item);
          insertNodeAt(evt.from, evt.item, evt.oldIndex);
          var oldIndex = this.context.index;
          var newIndex = this.getVmIndex(evt.newIndex);
          this.updatePosition(oldIndex, newIndex);
          var moved = { element: this.context.element, oldIndex: oldIndex, newIndex: newIndex };
          this.emitChanges({ moved: moved });
        },
        computeFutureIndex: function computeFutureIndex(relatedContext, evt) {
          if (!relatedContext.element) {
            return 0;
          }
          var domChildren = [].concat(_toConsumableArray(evt.to.children));
          var currentDOMIndex = domChildren.indexOf(evt.related);
          var currentIndex = relatedContext.component.getVmIndex(currentDOMIndex);
          var draggedInList = domChildren.indexOf(draggingElement) != -1;
          return draggedInList ? currentIndex : currentIndex + 1;
        },
        onDragMove: function onDragMove(evt) {
          var onMove = this.move;
          if (!onMove || !this.realList) {
            return true;
          }

          var relatedContext = this.getRelatedContextFromMoveEvent(evt);
          var draggedContext = this.context;
          var futureIndex = this.computeFutureIndex(relatedContext, evt);
          _extends(draggedContext, { futureIndex: futureIndex });
          _extends(evt, { relatedContext: relatedContext, draggedContext: draggedContext });
          return onMove(evt);
        },
        onDragEnd: function onDragEnd(evt) {
          this.computeIndexes();
          draggingElement = null;
        }
      }
    };
    return draggableComponent;
  }

  if (true) {
    var Sortable = __webpack_require__(481);
    module.exports = buildDraggable(Sortable);
  } else if (typeof define == "function" && define.amd) {
    define(['sortablejs'], function (Sortable) {
      return buildDraggable(Sortable);
    });
  } else if (window && window.Vue && window.Sortable) {
    var draggable = buildDraggable(window.Sortable);
    Vue.component('draggable', draggable);
  }
})();

/***/ }),

/***/ 98:
/***/ (function(module, exports) {

/**
 * Translates the list format produced by css-loader into something
 * easier to manipulate.
 */
module.exports = function listToStyles (parentId, list) {
  var styles = []
  var newStyles = {}
  for (var i = 0; i < list.length; i++) {
    var item = list[i]
    var id = item[0]
    var css = item[1]
    var media = item[2]
    var sourceMap = item[3]
    var part = {
      id: parentId + ':' + i,
      css: css,
      media: media,
      sourceMap: sourceMap
    }
    if (!newStyles[id]) {
      styles.push(newStyles[id] = { id: id, parts: [part] })
    } else {
      newStyles[id].parts.push(part)
    }
  }
  return styles
}


/***/ })

});
//# sourceMappingURL=list-field-config.js.map