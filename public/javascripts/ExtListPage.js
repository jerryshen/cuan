var ExtListPage = function(options){	
	Ext.BLANK_IMAGE_URL = "/javascripts/ext-2.2.1/resources/images/default/s.gif";
    var thisObj = this;
    var genRandom = function(){
        return Math.random().toString().substr(2)
    };
    //-------------------处理option--------------------------->
    //载入视图的base url
    var $BASE_URL = options.baseUrl;
    //表格标题
    var $GRID_TITLE = options.gridTitle || "Listing";
    //搜索按钮id
    var $SEARCH_BUTTON = options.btnSearch || "btnSearch";
    //新建按钮id
    var $NEW_ITEM_LINK = options.newItem || "newItem";
    
    //要显示的字段
    var $COLUMNS = options.columns;
    
    //为指定类型linkButton绑定点击响应方法
    var $BINDLINKS = options.bindlinks || {};
    var $DISABLE_DESTROY = options.disableDestroyButton || false;
    var $DISABLE_SHOW = options.disableShowButton || false;
    var $DISABLE_EDIT = options.disableEditButton || false;
    var $MOCK_DESTROY = typeof(options.mockDestroy) == "undefined" ? false : options.mockDestroy;
    
    //均为包含相关视图的div的id,一般保持默认
    var $SEARCH_FORM = options.searchForm || "search_form";
    var $LIST_VIEW = options.listView || "list-view";
    var $GRID_RENDER_TO = options.gridRenderTo || "grid-wrap";
    
    
    //-------------------------页导航------------------------------------------>
    var itemText = [];
    var $PAGE_ROWS_COUNT = "page_rows_count" + "_" + genRandom();
    var $PAGE_COUNT = "page_count" + "_" + genRandom();
    var $PAGE_LINKS = "pageLinks" + "_" + genRandom();
    /*itemText.push('<span class="textItemTitle">总记录数：</span><span id="' + $PAGE_ROWS_COUNT + '" class="textItemValue">0</span>')*/
    itemText.push('<span class="textItemTitle">总页数：</span><span id="' + $PAGE_COUNT + '" class="textItemValue">0</span>');
    itemText.push('<span style="margin-left:20px" class="pageLinks" id="' + $PAGE_LINKS + '" ></span>');
    
    //更新总页数
    var updatePageCount = function(value){
        document.getElementById($PAGE_COUNT).innerHTML = value;
    }
    
    //更新总记录数
    var updatePageRowCount = function(value){
      /*document.getElementById($PAGE_ROWS_COUNT).innerHTML = value;*/
    }
    
    //为页导航链接绑定响应方法
    var bindPageLinkClickHandler = function(link, pageIndex){
        link.onclick = function(){
            thisObj.loadGridData(pageIndex, getPageSize(), getSearchParams())
            return false;
        }
    }
    
    //生成页导航链接
    var makePageLinks = function(pageIndex, pageSize, pageCount, startPageIndex, linksCount){
        var links = [];
        var i = 0;
        var _createLink = function(text, index, pageSize){
            var link = document.createElement("span");
            var href = "?page=" + index + "&page_size=" + pageSize;
            link.setAttribute('href', href);
            link.style.cursor = "pointer";
            link.appendChild(document.createTextNode(text));
            bindPageLinkClickHandler(link, index);
            return link;
        }
        
        if (startPageIndex != 1) {
            var link = _createLink("Prev", pageIndex - 1, pageSize);
            links.push(link);
            links.push(document.createTextNode("..."));
        }
        
        while (i < linksCount && startPageIndex + i <= pageCount) {
            var index = startPageIndex + i;
            var link = _createLink(index, index, pageSize);
            if (index == pageIndex) 
                link.style.color = "red";
            links.push(link);
            i++;
        }
        
        if ((startPageIndex + linksCount - 1) < pageCount) {
            links.push(document.createTextNode("..."));
            var link = _createLink("Next", pageIndex + 3, pageSize);
            links.push(link);
        }
        return links;
    }
    
    //更新页导航链接
    var updatePageLinks = function(rowsCount, pageSize, pageIndex){
        var pages_count = Math.ceil(rowsCount / pageSize);
        var startPageIndex = 1;
        var linksCount = 5; //生成的链接数          
        var maxStartPageIndex = pages_count - linksCount + 1;
        if (pages_count > linksCount) {
            startPageIndex = pageIndex;
            if (startPageIndex > maxStartPageIndex) {
                startPageIndex = maxStartPageIndex;
            }
            else {
                var halfLinksCount = Math.floor(linksCount / 2);
                while (startPageIndex > 1 && (pageIndex - startPageIndex) < halfLinksCount) {
                    startPageIndex--;
                }
            }
        }
        var links = makePageLinks(pageIndex, pageSize, pages_count, startPageIndex, linksCount);
        var pageLinksContainer = document.getElementById($PAGE_LINKS);
        pageLinksContainer.innerHTML = "";
        for (var i = 0, l = links.length; i < l; i++) {
            pageLinksContainer.appendChild(links[i]);
        }
    }
    
      
    //---------------------初始化工具条----------------------->
    //［页大小］下拉框
    var $PAGE_SIZE_CMP = "page_size" + "_" + genRandom();
    var comboPageSize = new Ext.form.ComboBox({
        store: [[5, 5], [10, 10], [15, 15], [20, 20]],
        mode: 'local',
        triggerAction: 'all',
        editable: false,
        width: 60,
        value: 10,
        readOnly: true,
        fieldLabel: "Per-Size",
        selectOnFocus: false,
        id: $PAGE_SIZE_CMP
    });
    
    //响应［页大小］下拉框改变值
    comboPageSize.on("change", function(combo, newValue, oldValue){
        setPageIndex(1);
        thisObj.loadGridData(getPageIndex(), newValue, getSearchParams());
    });
    
    //[跳转到]输入框
    var $JUMP_TO_CMP = "jump_to" + "_" + genRandom();
    var numberInput = new Ext.form.NumberField({
        selectOnFocus: true,
        width: 40,
        id: $JUMP_TO_CMP
    });
    
    //响应［跳转到］输入框改变值
    numberInput.on("change", function(numInput, newValue, oldValue){
        thisObj.loadGridData(newValue, getPageSize(), getSearchParams());
    });
    
    //响应［跳转到］输入框回车
    numberInput.on("keypress", function(cmp, extEvent){
        if (extEvent.getKey() == Ext.EventObject.ENTER) 
            thisObj.loadGridData(cmp.getValue(), getPageSize(), getSearchParams());
    })
    
    //［刷新］按钮
    var refreshBtn = new Ext.Button({
        text: "刷新表格",
        iconCls: "icon-refresh",
        width: 50,
        style: "marginLeft:15px"
    });
    refreshBtn.on("click", function(){refreshGridData();});
    
    
    var okBtn = new Ext.Button({
        text: "确定",
        width: 50
    });

    var bbBar = new Ext.Toolbar({
        items: [{
            xtype: 'tbtext',
            text: itemText.join('')
        }, {
            xtype: 'tbtext',
            text: '<label style="margin-left:15px"  for="' + $PAGE_SIZE_CMP + '" >每页条数：</label>'
        }, comboPageSize, {
            xtype: 'tbtext',
            text: '<label  style="margin-left:15px"  for="' + $JUMP_TO_CMP + '" >跳转</label>'
        }, numberInput, okBtn, refreshBtn],
        height: 30
    });
    
    
  //---------------------初始化数据仓库----------------------------->
    //数据连接
    var conn = new Ext.data.Connection({
        url: $BASE_URL + ".json",
        method: "GET"
    })
    
    //生成数据仓库字段描述
    var makeStoreFields = function(columns){
        var fields = [];
        for (var i = 0, l = columns.length; i < l; i++) {
            var column = columns[i];
            var field = {}
            if (column.type) {
                field.type = column.type;
                delete field["type"];
            }
            field.name = column.dataIndex;
            fields.push(field);
        }
        return fields;
    }
    
    //客户端数据仓库
    var store = new Ext.data.JsonStore({
        root: 'rows',
        totalProperty: 'count',
        idProperty: 'id',
        fields: makeStoreFields($COLUMNS),
        proxy: new Ext.data.HttpProxy(conn)
    });
    
  //------------------------初始化表--------------------------->
    var eachColumns = function(columns, funs){
        for (var i = 0, l = columns.length; i < l; i++) {
            var column = columns[i];
            for (var j = 0, k = funs.length; j < k; j++) {
                funs[j](column);
            }
        }
    }
    
    //设置表的列标题(仅对英文版有用)
    var setColumnHeader = function(column){
        if (!column.header) {
            var field = column.dataIndex;
            column.header = field.replace(/^./, field.substr(0, 1).toUpperCase()).replace(/_id$/, '');
        }
    }
    
    //关闭表的列菜单
    var disableMenu = function(column){
        if (!column.menuDisabled) 
            column.menuDisabled = true;
    }
    
    //增加一个操作列：包含编辑、查看、删除按钮
    var mackBasicButtons = function(value, p, record){
		var show=edit=destroy = '';
		var htmls = [];
        if (!$DISABLE_DESTROY) {
			var action = $MOCK_DESTROY ? "hide" : "destroy";
            var destroy = '<img url="' + $BASE_URL + '/' + action + '/{0}.json" action="destroy" title="删除" style="margin-left:10px;" class="gridButton"  src="/images/icons/delete.png" />';
			htmls.push(destroy);
        }
        
        if (!$DISABLE_SHOW) {
            var show = '<img url="' + $BASE_URL + '/show/{0}?layout=none" action="show" title="查看" style="margin-left:10px;" class="gridButton" src="/images/icons/show.png" />';
			htmls.push(show);
        }
        
        if (!$DISABLE_EDIT) {
            var edit = '<img url="' + $BASE_URL + '/edit/{0}?layout=none" action="edit" title="编辑" style="margin-left:10px;" class="gridButton" src="/images/icons/edit.png" />';
			htmls.push(edit);
        }
		
		var default_buttons = String.format(htmls.join(''), value);
		var customer_buttons = []
		if(options.oprateBarButtons){
			var btns = options.oprateBarButtons;
			for(var i=0, l=btns.length; i<l; i++){
				var btn = btns[i];
				if(typeof(btn)=="function"){
					customer_buttons.push(btn(value, p, record));
				}
			}
		}
        return default_buttons + customer_buttons.join('');
    }
    
    if(!options.disableOprateColumn){
      var operateColumn = {
          header: "操作栏",
          dataIndex: 'id',
          width: 130,
          sortable: false,
          menuDisabled: false,
          renderer: mackBasicButtons
      }
    }
    
    var gridWidth = 0;
    //计算表的宽度
    var cal_grid_width = function(column){
      if(column.hidden !== true){
        if (column.width ) {
            gridWidth += column.width;
        }
        else {
            gridWidth += 100;
        }
      }
    }
    
    eachColumns($COLUMNS, [disableMenu, cal_grid_width]);
    $COLUMNS[0].menuDisabled = false; //为第一列开启menu

    if(!options.disableOprateColumn){
      gridWidth += operateColumn.width; //add operate column width
      $COLUMNS.push(operateColumn);
    }

    if (gridWidth < 600) {
      var o = gridWidth;
      gridWidth = 600;
      if(!options.disableOprateColumn)operateColumn.width = 600 - o + 100;
    }
    
    var grid = new Ext.grid.GridPanel({
        el: $GRID_RENDER_TO,
        width: gridWidth,
        autoHeight: true,
        title: $GRID_TITLE,
        store: store,
        trackMouseOver: false,
        disableSelection: false,
        loadMask: true,
        bbar: bbBar,
        columns: $COLUMNS,
        iconCls: "icon-grid"
    })

    var columnModel = grid.getColumnModel();
    columnModel.on("hiddenChange",function(model,columnIndex,hidden){
      var grid_width = grid.getSize().width;
      var column_width = model.getColumnWidth(columnIndex);
      if(hidden){
        grid.setWidth(grid_width - column_width);
      }else{
        grid.setWidth(grid_width + column_width);
      }
    })

    
  //---------------搜索并载入数据----------------------->
    //当前页序号        
    var _pageIndex = 1;
    var getPageIndex = function(){
        return _pageIndex;
    }
    var setPageIndex = function(value){
        _pageIndex = value;
    }
    
    //获取每页记录数
    var getPageSize = function(){
        return Ext.get($PAGE_SIZE_CMP).getValue();
    }
    
    var controls = Ext.query("#" + $SEARCH_FORM + " input[type=text]," 
                               + "#" + $SEARCH_FORM + " select"); 
    //获取搜索条件
    var getSearchParams = function(){
        var params = {};
        for(var i = 0, l = controls.length; i < l; i++) {
          var acontrol = controls[i];
          params[acontrol.name] = acontrol.value;
        }
        return params;
    }
    
    //校验数据请求参数
    var validate_pageSize = function(pageSize){
        pageSize = parseInt(pageSize);
        if (isNaN(pageSize)) 
            return false;
        return pageSize > 0
    }
    
    var validate_pageIndex = function(pageIndex){
        pageIndex = parseInt(pageIndex);
        if (isNaN(pageIndex)) 
            return false;
        return pageIndex == 1 || (pageIndex > 0 && pageIndex <= Math.ceil(store.getTotalCount() / getPageSize()))
    }
    
    //载入数据
    this.loadGridData = function(pageIndex, pageSize, searchParams){
        if (validate_pageIndex(pageIndex) && validate_pageSize(pageSize)) {
            setPageIndex(parseInt(pageIndex));
            searchParams["page"] = parseInt(pageIndex);
            searchParams["page_size"] = parseInt(pageSize);
            if (searchParams) {
                store.load({
                    params: searchParams
                });
            }
            else {
                window.location.reload();
            }
        }
    }
    
	//刷新表格数据
  var refreshGridData = function(){
        thisObj.loadGridData(getPageIndex(), getPageSize(), getSearchParams());
    }
	this.refreshGridData = refreshGridData;
    
    //为所有link button组件绑定事件
    var bind_destroyLink_Click = function(alink){
        var url = alink.getAttribute("url");
        Ext.get(alink).on("click", function(){
            Ext.MessageBox.confirm("删除数据","确定要删除该记录？",function(clickedBtn){
				if (clickedBtn == "yes") {
					Ext.Ajax.request({
						url: url,
						success: function(rq, rqOpt){
                            var response = Ext.util.JSON.decode(rq.responseText);
                            if(response.status && response.status == "success"){
								refreshGridData();
							}
							else {
								Ext.MessageBox.alert("删除数据","删除记录失败！");
							}
						},
						failure: function(rq,rqOpt){
							Ext.MessageBox.alert("删除数据","删除记录失败,连接状态：" + rq.status);
						}
					});
				}			
			}) 
        })
    }
    
    var bind_editLink_Click = function(alink){
        var url = alink.getAttribute("url");
        Ext.get(alink).on("click", function(){
            switchViewMode("edit", url);
        })
    }
    
    var bind_showLink_Click = function(alink){
        var url = alink.getAttribute("url");
        Ext.get(alink).on("click", function(){
            switchViewMode("show", url);
        })
    }
    
    var bind_links_click = function(){
        var buttons = Ext.select(".gridButton",true,$GRID_RENDER_TO)
		buttons.each(function(btn){
			var btnEl = btn.dom;
			btnEl.style.cursor = "pointer";
			var action = btnEl.getAttribute("action");
 			switch (action) {
                case "destroy":
                    bind_destroyLink_Click(btnEl);
                    break;
                case "edit":
                    bind_editLink_Click(btnEl);
                    break;
                case "show":
                    bind_showLink_Click(btnEl);
                    break;
				default:
					var bindHandler = $BINDLINKS[action];
					if (bindHandler) {
		                bindHandler(btnEl,thisObj);
		            }						
            }            		
		})
    }
    
    store.on("load", function(store, rows, options){
        var rowsCount = store.getTotalCount();
        updatePageLinks(rowsCount, getPageSize(), getPageIndex());
        updatePageRowCount(rowsCount);
        updatePageCount(Math.ceil(rowsCount / getPageSize()));
        bind_links_click();
    })
    grid.addListener("sortchange", bind_links_click);
	
    //渲染表格并载入第一页数据
    grid.render();
    var first_load_params = getSearchParams();
    first_load_params.page = "1";
    first_load_params.page_size = "10";
    store.load({params:first_load_params});
    
    
    //------------------------为外部定义控件绑定事件响应方法---------------------------------->
    //响应点击［搜索］按钮
    var searchBtn = Ext.get($SEARCH_BUTTON);
    if (searchBtn) 
        searchBtn.on("click", function(event){
            refreshGridData();
        });
    
    //-------------------视图切换--------------------------->
    //创建视图
    var $SHOW_VIEW = "show-view";
    var $EDIT_VIEW = "edit-view";
    var $NEW_VIEW = "new-view";
    var createView = function(id){
        var div = document.createElement("div");
        div.id = id;
        document.body.appendChild(div);
    }
    createView($SHOW_VIEW);
    createView($EDIT_VIEW);
    createView($NEW_VIEW);
    
    //显示某个视图
    var currViewId = $LIST_VIEW;
    this.getCurrViewId = function(){return currViewId};

    var _fun = function(showViewId, data){
      var currView = document.getElementById(currViewId);
      currView.style.display = "none";
      if (currViewId != $LIST_VIEW) 
      currView.innerHTML = '';

      var toView = document.getElementById(showViewId);
      if (data){ 
        Ext.get(toView).update(data,true); //load script
        /*toView.innerHTML = data;*/
      }
      toView.style.display = "block";

      currViewId = showViewId;
    }

    var showView = function(showViewId, url, callback){
        if (url) {
            Ext.Ajax.request({
                url: url,
                method: "GET",
                success: function(rq, rqopt){
                    _fun(showViewId, rq.responseText);
                    initAjaxForm();
                    if (callback) 
                        callback();
                }
            });
        }
        else {
            _fun(showViewId);
        }
    }
    
    //切换页面视图
    var switchViewMode = function(mode, url){
        switch (mode) {
            case "new":
                showView($NEW_VIEW, url);
                break;
            case "edit":
                showView($EDIT_VIEW, url);
                break;
            case "show":
                showView($SHOW_VIEW, url);
                break;
            case "list":
                showView($LIST_VIEW);
                refreshGridData();
                break;
        }
    }

    this.showListView = function(reLoadData){
      showView($LIST_VIEW);
      if(reLoadData)refreshGridData();
    }

    this.showNewView = function(){
      showView($NEW_VIEW,$BASE_URL + '/new?layout=none');
    }

    this.showEditView = function(data){
      _fun($EDIT_VIEW, data)
    }
}

function changeSkin(value){
  Ext.util.CSS.swapStyleSheet('theme', '/javascripts/ext-2.2.1/resources/css/' + value + '.css');
};

/*Ext.onReady(function(){*/
  /*alert(window.parent.$CURR_STYLE);*/
  /*changeSkin(window.parent.$CURR_STYLE);*/
  /*})*/
