/*
 * Compressed by JSA(www.xidea.org)
 */
var ExtListPage=function(x){Ext.BLANK_IMAGE_URL="/javascripts/ext-2.2.1/resources/images/default/s.gif";var Q=this,g=function(){return Math.random().toString().substr(2)},i=x.baseUrl,K0=x.gridTitle||"Listing",e=x.btnSearch||"btnSearch",c=x.newItem||"newItem",b=x.columns,_0=x.bindlinks||{},A=x.disableDestroyButton||false,w=x.disableShowButton||false,u=x.disableEditButton||false,H=typeof(x.mockDestroy)=="undefined"?false:x.mockDestroy,X=x.searchForm||"search_form",y=x.listView||"list-view",F0=x.gridRenderTo||"grid-wrap",P=[],_="page_rows_count"+"_"+g(),E="page_count"+"_"+g(),J="pageLinks"+"_"+g();P.push("<span class=\"textItemTitle\">\u603b\u9875\u6570\uff1a</span><span id=\""+E+"\" class=\"textItemValue\">0</span>");P.push("<span style=\"margin-left:20px\" class=\"pageLinks\" id=\""+J+"\" ></span>");var f=function($){document.getElementById(E).innerHTML=$},J0=function($){},O=function($,_){$.onclick=function(){Q.loadGridData(_,a(),l());return false}},U=function(H,C,$,A,F){var E=[],G=0,D=function(_,$,B){var A=document.createElement("span"),C="?page="+$+"&page_size="+B;A.setAttribute("href",C);A.style.cursor="pointer";A.appendChild(document.createTextNode(_));O(A,$);return A};if(A!=1){var B=D("Prev",H-1,C);E.push(B);E.push(document.createTextNode("..."))}while(G<F&&A+G<=$){var _=A+G,B=D(_,_,C);if(_==H)B.style.color="red";E.push(B);G++}if((A+F-1)<$){E.push(document.createTextNode("..."));B=D("Next",H+3,C);E.push(B)}return E},E0=function($,D,H){var A=Math.ceil($/D),B=1,E=5,_=A-E+1;if(A>E){B=H;if(B>_)B=_;else{var K=Math.floor(E/2);while(B>1&&(H-B)<K)B--}}var F=U(H,D,A,B,E),C=document.getElementById(J);C.innerHTML="";for(var I=0,G=F.length;I<G;I++)C.appendChild(F[I])},F="page_size"+"_"+g(),D0=new Ext.form.ComboBox({store:[[5,5],[10,10],[15,15],[20,20]],mode:"local",triggerAction:"all",editable:false,width:60,value:10,readOnly:true,fieldLabel:"Per-Size",selectOnFocus:false,id:F});D0.on("change",function(A,$,_){G(1);Q.loadGridData(q(),$,l())});var t="jump_to"+"_"+g(),L0=new Ext.form.NumberField({selectOnFocus:true,width:40,id:t});L0.on("change",function(_,$,A){Q.loadGridData($,a(),l())});L0.on("keypress",function($,_){if(_.getKey()==Ext.EventObject.ENTER)Q.loadGridData($.getValue(),a(),l())});var z=new Ext.Button({text:"\u5237\u65b0\u8868\u683c",iconCls:"icon-refresh",width:50,style:"marginLeft:15px"});z.on("click",function(){k()});var h=new Ext.Button({text:"\u786e\u5b9a",width:50}),B=new Ext.Toolbar({items:[{xtype:"tbtext",text:P.join("")},{xtype:"tbtext",text:"<label style=\"margin-left:15px\"  for=\""+F+"\" >\u6bcf\u9875\u6761\u6570\uff1a</label>"},D0,{xtype:"tbtext",text:"<label  style=\"margin-left:15px\"  for=\""+t+"\" >\u8df3\u8f6c</label>"},L0,h,z],height:30}),j=new Ext.data.Connection({url:i+".json",method:"GET"}),Z=function(A){var D=[];for(var C=0,B=A.length;C<B;C++){var _=A[C],$={};if(_.type){$.type=_.type;delete $["type"]}$.name=_.dataIndex;D.push($)}return D},C=new Ext.data.JsonStore({root:"rows",totalProperty:"count",idProperty:"id",fields:Z(b),proxy:new Ext.data.HttpProxy(j)}),K=function(_,B){for(var E=0,A=_.length;E<A;E++){var $=_[E];for(var C=0,D=B.length;C<D;C++)B[C]($)}},H0=function(_){if(!_.header){var $=_.dataIndex;_.header=$.replace(/^./,$.substr(0,1).toUpperCase()).replace(/_id$/,"")}},R=function($){if(!$.menuDisabled)$.menuDisabled=true},s=function(L,K,G){var C=_=E="",$=[];if(!A){var M=H?"hide":"destroy",E="<img url=\""+i+"/"+M+"/{0}.json\" action=\"destroy\" title=\"\u5220\u9664\" style=\"margin-left:10px;\" class=\"gridButton\"  src=\"/images/icons/delete.png\" />";$.push(E)}if(!w){C="<img url=\""+i+"/show/{0}?layout=none\" action=\"show\" title=\"\u67e5\u770b\" style=\"margin-left:10px;\" class=\"gridButton\" src=\"/images/icons/show.png\" />";$.push(C)}if(!u){var _="<img url=\""+i+"/edit/{0}?layout=none\" action=\"edit\" title=\"\u7f16\u8f91\" style=\"margin-left:10px;\" class=\"gridButton\" src=\"/images/icons/edit.png\" />";$.push(_)}var F=String.format($.join(""),L),J=[];if(x.oprateBarButtons){var N=x.oprateBarButtons;for(var D=0,B=N.length;D<B;D++){var I=N[D];if(typeof(I)=="function")J.push(I(L,K,G))}}return F+J.join("")};if(!x.disableOprateColumn)var o={header:"\u64cd\u4f5c\u680f",dataIndex:"id",width:130,sortable:false,menuDisabled:false,renderer:s};var p=0,m=function($){if($.hidden!==true)if($.width)p+=$.width;else p+=100};K(b,[R,m]);b[0].menuDisabled=false;if(!x.disableOprateColumn){p+=o.width;b.push(o)}if(p<600){var B0=p;p=600;if(!x.disableOprateColumn)o.width=600-B0+100}var v=new Ext.grid.GridPanel({el:F0,width:p,autoHeight:true,title:K0,store:C,trackMouseOver:false,disableSelection:false,loadMask:true,bbar:B,columns:b,iconCls:"icon-grid"}),C0=v.getColumnModel();C0.on("hiddenChange",function($,B,A){var C=v.getSize().width,_=$.getColumnWidth(B);if(A)v.setWidth(C-_);else v.setWidth(C+_)});var I0=1,q=function(){return I0},G=function($){I0=$},a=function(){return Ext.get(F).getValue()},r=Ext.query("#"+X+" input[type=text],"+"#"+X+" select"),l=function(){var A={};for(var B=0,_=r.length;B<_;B++){var $=r[B];A[$.name]=$.value}return A},I=function($){$=parseInt($);if(isNaN($))return false;return $>0},Y=function($){$=parseInt($);if(isNaN($))return false;return $==1||($>0&&$<=Math.ceil(C.getTotalCount()/a()))};this.loadGridData=function(A,_,$){if(Y(A)&&I(_)){G(parseInt(A));$["page"]=parseInt(A);$["page_size"]=parseInt(_);if($)C.load({params:$});else window.location.reload()}};var k=function(){Q.loadGridData(q(),a(),l())};this.refreshGridData=k;var d=function($){var _=$.getAttribute("url");Ext.get($).on("click",function(){Ext.MessageBox.confirm("\u5220\u9664\u6570\u636e","\u786e\u5b9a\u8981\u5220\u9664\u8be5\u8bb0\u5f55\uff1f",function($){if($=="yes")Ext.Ajax.request({url:_,success:function(_,A){var $=Ext.util.JSON.decode(_.responseText);if($.status&&$.status=="success")k();else Ext.MessageBox.alert("\u5220\u9664\u6570\u636e","\u5220\u9664\u8bb0\u5f55\u5931\u8d25\uff01")},failure:function($,_){Ext.MessageBox.alert("\u5220\u9664\u6570\u636e","\u5220\u9664\u8bb0\u5f55\u5931\u8d25,\u8fde\u63a5\u72b6\u6001\uff1a"+$.status)}})})})},L=function($){var _=$.getAttribute("url");Ext.get($).on("click",function(){A0("edit",_)})},S=function($){var _=$.getAttribute("url");Ext.get($).on("click",function(){A0("show",_)})},$=function(){var $=Ext.select(".gridButton",true,F0);$.each(function(_){var $=_.dom;$.style.cursor="pointer";var A=$.getAttribute("action");switch(A){case"destroy":d($);break;case"edit":L($);break;case"show":S($);break;default:var B=_0[A];if(B)B($,Q)}})};C.on("load",function(A,C,B){var _=A.getTotalCount();E0(_,a(),q());J0(_);f(Math.ceil(_/a()));$()});v.addListener("sortchange",$);v.render();var N=l();N.page="1";N.page_size="10";C.load({params:N});var T=Ext.get(e);if(T)T.on("click",function($){k()});var V="show-view",G0="edit-view",W="new-view",D=function($){var _=document.createElement("div");_.id=$;document.body.appendChild(_)};D(V);D(G0);D(W);var n=y;this.getCurrViewId=function(){return n};var M=function(B,A){var $=document.getElementById(n);$.style.display="none";if(n!=y)$.innerHTML="";var _=document.getElementById(B);if(A)Ext.get(_).update(A,true);_.style.display="block";n=B},$0=function(_,A,$){if(A)Ext.Ajax.request({url:A,method:"GET",success:function(B,A){M(_,B.responseText);initAjaxForm();if($)$()}});else M(_)},A0=function(_,$){switch(_){case"new":$0(W,$);break;case"edit":$0(G0,$);break;case"show":$0(V,$);break;case"list":$0(y);k();break}};this.showListView=function($){$0(y);if($)k()};this.showNewView=function(){$0(W,i+"/new?layout=none")};this.showEditView=function($){M(G0,$)}};function changeSkin($){Ext.util.CSS.swapStyleSheet("theme","/javascripts/ext-2.2.1/resources/css/"+$+".css")}