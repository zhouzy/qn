webpackJsonp([4,15],{

/***/ 342:
/***/ (function(module, exports, __webpack_require__) {

var Component = __webpack_require__(3)(
  /* script */
  __webpack_require__(411),
  /* template */
  __webpack_require__(521),
  /* scopeId */
  null,
  /* cssModules */
  null
)
Component.options.__file = "D:\\WorkSpace\\cdesk\\ems\\WebRoot\\vue-static\\src\\customer-center\\components\\my-order\\commit-order.vue"
if (Component.esModule && Object.keys(Component.esModule).some(function (key) {return key !== "default" && key !== "__esModule"})) {console.error("named exports are not supported in *.vue files.")}
if (Component.options.functional) {console.error("[vue-loader] commit-order.vue: functional components are not supported with templates, they should use render functions.")}

/* hot reload */
if (false) {(function () {
  var hotAPI = require("vue-hot-reload-api")
  hotAPI.install(require("vue"), false)
  if (!hotAPI.compatible) return
  module.hot.accept()
  if (!module.hot.data) {
    hotAPI.createRecord("data-v-b4cda05a", Component.options)
  } else {
    hotAPI.reload("data-v-b4cda05a", Component.options)
  }
})()}

module.exports = Component.exports


/***/ }),

/***/ 343:
/***/ (function(module, exports, __webpack_require__) {


/* styles */
__webpack_require__(563)

var Component = __webpack_require__(3)(
  /* script */
  __webpack_require__(412),
  /* template */
  __webpack_require__(514),
  /* scopeId */
  "data-v-5bde3f88",
  /* cssModules */
  null
)
Component.options.__file = "D:\\WorkSpace\\cdesk\\ems\\WebRoot\\vue-static\\src\\customer-center\\components\\my-order\\my-order.vue"
if (Component.esModule && Object.keys(Component.esModule).some(function (key) {return key !== "default" && key !== "__esModule"})) {console.error("named exports are not supported in *.vue files.")}
if (Component.options.functional) {console.error("[vue-loader] my-order.vue: functional components are not supported with templates, they should use render functions.")}

/* hot reload */
if (false) {(function () {
  var hotAPI = require("vue-hot-reload-api")
  hotAPI.install(require("vue"), false)
  if (!hotAPI.compatible) return
  module.hot.accept()
  if (!module.hot.data) {
    hotAPI.createRecord("data-v-5bde3f88", Component.options)
  } else {
    hotAPI.reload("data-v-5bde3f88", Component.options)
  }
})()}

module.exports = Component.exports


/***/ }),

/***/ 411:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = {};

/***/ }),

/***/ 412:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
    value: true
});

var _promise = __webpack_require__(43);

var _promise2 = _interopRequireDefault(_promise);

var _querystring = __webpack_require__(52);

var _querystring2 = _interopRequireDefault(_querystring);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

exports.default = {
    name: 'MyOrder',
    created: function created() {
        this.debounceGetOrderList = _.debounce(this.getOrderList, 500, { maxWait: 2000 });
    },

    mounted: function mounted() {
        this.queryOrderList();
    },
    data: function data() {
        return {
            queryForm: {
                status: '-1'
            },

            getOrderListParamsCache: {},

            orderList: [],

            pager: {
                page: 1,
                size: 10,
                total: 0
            },

            isLoading: false,

            ORDER_STATUS_MAP: window.ACT_CONFIG.ORDER_STATUS_MAP
        };
    },
    methods: {
        queryOrderList: function queryOrderList() {
            this.debounceGetOrderList(this.queryForm);
        },

        resetForm: function resetForm() {
            this.queryForm.status = '-1';
        },

        getOrderList: function getOrderList(param) {
            var _this = this;

            this.getOrderListParamsCache = _.extend({}, param);

            this.isLoading = true;
            this.axios.get('/queryWorkOrderInfo/queryCreatorWorkOrder', {
                params: {
                    status: param.status,
                    page: this.pager.page,
                    rows: this.pager.size
                }
            }).then(function (res) {
                var data = res.data;
                if (!data.success) {
                    return _promise2.default.reject(new Error(data.msg));
                }

                _this.orderList = data.rows || [];

                _this.updatePager({
                    total: data.total
                });
            }).catch(function (error) {
                _this.$message({
                    showClose: true,
                    type: 'error',
                    message: error.message
                });
            }).finally(function () {
                setTimeout(function () {
                    _this.isLoading = false;
                }, 500);
            });
        },

        updatePager: function updatePager(pager) {
            _.extend(this.pager, pager);
        },

        handleSizeChange: function handleSizeChange(size) {
            this.updatePager({
                size: size
            });

            this.debounceGetOrderList(this.getOrderListParamsCache);
        },

        handlePageChange: function handlePageChange(page) {
            this.updatePager({
                page: page
            });

            this.debounceGetOrderList(this.getOrderListParamsCache);
        }
    }
};

/***/ }),

/***/ 514:
/***/ (function(module, exports, __webpack_require__) {

module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
  return _c('div', {
    staticClass: "my-order__root"
  }, [_c('div', {
    staticClass: "customer-center__right-part-header"
  }, [_c('el-row', [_c('el-col', {
    attrs: {
      "sm": 8
    }
  }, [_c('el-breadcrumb', {
    staticClass: "customer-center__breadcrumb",
    attrs: {
      "separator": "/"
    }
  }, [_c('el-breadcrumb-item', {
    attrs: {
      "to": {
        path: '/my-order'
      }
    }
  }, [_vm._v("我的工单")])], 1), _vm._v(" "), _c('el-button', {
    attrs: {
      "type": "primary",
      "size": "small"
    }
  }, [_c('i', {
    staticClass: "fa fa-plus",
    attrs: {
      "aria-hidden": "true"
    }
  }), _vm._v(" 提交新工单")])], 1)], 1)], 1), _vm._v(" "), _c('div', {
    staticClass: "my-order__main-content"
  }, [_c('div', {
    staticClass: "my-order__query-panel"
  }, [_c('el-form', {
    attrs: {
      "label-width": "100px"
    }
  }, [_c('el-row', {
    attrs: {
      "gutter": 8
    }
  }, [_c('el-col', {
    attrs: {
      "sm": 6
    }
  }, [_c('el-form-item', {
    attrs: {
      "label": "工单状态"
    }
  }, [_c('el-select', {
    directives: [{
      name: "model",
      rawName: "v-model",
      value: (_vm.queryForm.status),
      expression: "queryForm.status"
    }],
    attrs: {
      "size": "small",
      "placeholder": "请选择工单状态"
    },
    domProps: {
      "value": (_vm.queryForm.status)
    },
    on: {
      "input": function($event) {
        _vm.queryForm.status = $event
      }
    }
  }, [_c('el-option', {
    attrs: {
      "label": "全部",
      "value": "-1"
    }
  }), _vm._v(" "), _c('el-option', {
    attrs: {
      "label": "尚未受理",
      "value": "0"
    }
  }), _vm._v(" "), _c('el-option', {
    attrs: {
      "label": "受理中",
      "value": "1"
    }
  }), _vm._v(" "), _c('el-option', {
    attrs: {
      "label": "等待回复",
      "value": "2"
    }
  }), _vm._v(" "), _c('el-option', {
    attrs: {
      "label": "已解决",
      "value": "3"
    }
  }), _vm._v(" "), _c('el-option', {
    attrs: {
      "label": "已关闭",
      "value": "4"
    }
  })], 1)], 1)], 1), _vm._v(" "), _c('el-col', {
    attrs: {
      "sm": {
        span: 6,
        offset: 12
      }
    }
  }, [_c('el-form-item', {
    staticStyle: {
      "text-align": "right"
    }
  }, [_c('el-button', {
    attrs: {
      "type": "primary",
      "size": "small"
    },
    on: {
      "click": _vm.queryOrderList
    }
  }, [_vm._v("查询")]), _vm._v(" "), _c('el-button', {
    attrs: {
      "type": "warning",
      "size": "small"
    },
    on: {
      "click": _vm.resetForm
    }
  }, [_vm._v("重置")])], 1)], 1)], 1)], 1)], 1), _vm._v(" "), _c('div', {
    staticClass: "my-order__table-content"
  }, [_c('el-table', {
    directives: [{
      name: "loading",
      rawName: "v-loading",
      value: (_vm.isLoading),
      expression: "isLoading"
    }],
    attrs: {
      "data": _vm.orderList,
      "stripe": true,
      "border": true,
      "highlight-current-row": true,
      "element-loading-text": "努力获取数据中···",
      "height": "320"
    }
  }, [_c('el-table-column', {
    attrs: {
      "label": "编号",
      "prop": "workId"
    }
  }), _vm._v(" "), _c('el-table-column', {
    attrs: {
      "label": "标题",
      "prop": "title"
    }
  }), _vm._v(" "), _c('el-table-column', {
    attrs: {
      "label": "工单状态"
    },
    scopedSlots: {
      default: function(scope) {
        return [_c('el-tag', {
          attrs: {
            "type": _vm.ORDER_STATUS_MAP[scope.row.status].type,
            "color": _vm.ORDER_STATUS_MAP[scope.row.status].color
          }
        }, [_vm._v(_vm._s(_vm.ORDER_STATUS_MAP[scope.row.status].text))])]
      }
    }
  }), _vm._v(" "), _c('el-table-column', {
    attrs: {
      "label": "工单创建日期",
      "prop": "createDate"
    }
  }), _vm._v(" "), _c('el-table-column', {
    attrs: {
      "label": "受理组",
      "prop": "serviceGroupName"
    }
  }), _vm._v(" "), _c('el-table-column', {
    attrs: {
      "label": "受理人",
      "prop": "customServiceName"
    }
  })], 1), _vm._v(" "), _c('div', {
    staticClass: "my-order__pagination-box"
  }, [_c('el-pagination', {
    attrs: {
      "current-page": _vm.pager.page,
      "page-sizes": [5, 10, 15],
      "page-size": _vm.pager.size,
      "layout": "total, sizes, prev, pager, next, jumper",
      "total": _vm.pager.total
    },
    on: {
      "size-change": _vm.handleSizeChange,
      "current-change": _vm.handlePageChange
    }
  })], 1)], 1)])])
},staticRenderFns: []}
module.exports.render._withStripped = true
if (false) {
  module.hot.accept()
  if (module.hot.data) {
     require("vue-hot-reload-api").rerender("data-v-5bde3f88", module.exports)
  }
}

/***/ }),

/***/ 521:
/***/ (function(module, exports, __webpack_require__) {

module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
  return _c('div', [_vm._v("\n    提交工单\n")])
},staticRenderFns: []}
module.exports.render._withStripped = true
if (false) {
  module.hot.accept()
  if (module.hot.data) {
     require("vue-hot-reload-api").rerender("data-v-b4cda05a", module.exports)
  }
}

/***/ }),

/***/ 562:
/***/ (function(module, exports, __webpack_require__) {

exports = module.exports = __webpack_require__(10)();
// imports


// module
exports.push([module.i, "/**\n * 我的工单组件样式\n */\n.my-order__root[data-v-5bde3f88] {\n  height: 100%;\n  overflow: auto;\n}\n.my-order__main-content[data-v-5bde3f88] {\n  margin-top: 15px;\n  padding: 0 15px;\n}\n.my-order__query-panel[data-v-5bde3f88] {\n  padding: 20px 10px 0;\n  background-color: #fff;\n}\n.my-order__table-content[data-v-5bde3f88] {\n  margin-top: 10px;\n  padding: 10px;\n  background-color: #fff;\n}\n.my-order__pagination-box[data-v-5bde3f88] {\n  margin-top: 10px;\n}\n", "", {"version":3,"sources":["/./src/customer-center/components/my-order/my-order.vue"],"names":[],"mappings":"AAAA;;GAEG;AACH;EACE,aAAa;EACb,eAAe;CAChB;AACD;EACE,iBAAiB;EACjB,gBAAgB;CACjB;AACD;EACE,qBAAqB;EACrB,uBAAuB;CACxB;AACD;EACE,iBAAiB;EACjB,cAAc;EACd,uBAAuB;CACxB;AACD;EACE,iBAAiB;CAClB","file":"my-order.vue","sourcesContent":["/**\n * 我的工单组件样式\n */\n.my-order__root {\n  height: 100%;\n  overflow: auto;\n}\n.my-order__main-content {\n  margin-top: 15px;\n  padding: 0 15px;\n}\n.my-order__query-panel {\n  padding: 20px 10px 0;\n  background-color: #fff;\n}\n.my-order__table-content {\n  margin-top: 10px;\n  padding: 10px;\n  background-color: #fff;\n}\n.my-order__pagination-box {\n  margin-top: 10px;\n}\n"],"sourceRoot":"webpack://"}]);

// exports


/***/ }),

/***/ 563:
/***/ (function(module, exports, __webpack_require__) {

// style-loader: Adds some css to the DOM by adding a <style> tag

// load the styles
var content = __webpack_require__(562);
if(typeof content === 'string') content = [[module.i, content, '']];
if(content.locals) module.exports = content.locals;
// add the styles to the DOM
var update = __webpack_require__(15)("790b183f", content, false);
// Hot Module Replacement
if(false) {
 // When the styles change, update the <style> tags
 if(!content.locals) {
   module.hot.accept("!!./../../../../node_modules/css-loader/index.js?sourceMap!./../../../../node_modules/vue-loader/lib/style-rewriter.js?id=data-v-5bde3f88&scoped=true!./../../../../node_modules/less-loader/index.js!./../../../../node_modules/vue-loader/lib/selector.js?type=styles&index=0!./my-order.vue", function() {
     var newContent = require("!!./../../../../node_modules/css-loader/index.js?sourceMap!./../../../../node_modules/vue-loader/lib/style-rewriter.js?id=data-v-5bde3f88&scoped=true!./../../../../node_modules/less-loader/index.js!./../../../../node_modules/vue-loader/lib/selector.js?type=styles&index=0!./my-order.vue");
     if(typeof newContent === 'string') newContent = [[module.id, newContent, '']];
     update(newContent);
   });
 }
 // When the module is disposed, remove the <style> tags
 module.hot.dispose(function() { update(); });
}

/***/ })

});
//# sourceMappingURL=my-order.js.map