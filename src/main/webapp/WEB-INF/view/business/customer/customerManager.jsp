<%--
  Created by IntelliJ IDEA.
  Customer: YQF
  Date: 2019/10/14
  Time: 18:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>客户管理</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta http-equiv="Access-Control-Allow-Origin" content="*">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="format-detection" content="telephone=no">
    <%--<link rel="icon" href="favicon.ico">--%>
    <link rel="stylesheet" href="${yeqifu}/static/layui/css/layui.css" media="all"/>
    <link rel="stylesheet" href="${yeqifu}/static/css/public.css" media="all"/>
    <link rel="stylesheet" href="${yeqifu}/static/layui_ext/dtree/dtree.css">
    <link rel="stylesheet" href="${yeqifu}/static/layui_ext/dtree/font/dtreefont.css">
</head>
<body class="childrenBody">

<!-- 搜索条件开始 -->

<form class="layui-form" action="">
    <div style="text-align: center">
        <%--        <label class="layui-form-label" style="width: 200px;text-align: center">BCC和FCC差异</label>--%>
        <div class="layui-input-block">
            BCC和FCC差异
            <input name="like1" title="" type="checkbox" checked="" lay-skin="primary">
        </div>
    </div>
</form>
<form class="layui-form" method="post" id="searchFrm">

    <%--        <div  style="text-align: center">--%>
    <%--       <input name="like1" title="BCC和FCC差异" type="checkbox" checked="" lay-skin="primary">--%>
    <%--        </div>--%>

    <div class="layui-form-item layui-form-text">

        <br>如果选中了BCC和FCC差异框，则在风险评估批准后，此选项卡中BCC / FCC分析的内容将通过牛顿生成的电子邮件提供给Capital Markets CTM专业服务。如果跨界的任何收件人具有不同的密件抄送和FCC，请明确指出这适用于哪些收件人，因此清除CTM以更新CCMS。
        如果借款人是资本市场帐户或全国客户组帐户在美国过境预订的贷款，请填写借款分类代码/设施划分代码分析。请参阅牛顿工作区中的Job Aid-BCC分析。</br>

        <hr width="100%" color=#333 size=12></hr>
        <div class="layui-form-item layui-form-text">
            <label class="layui-form-label"> 评论</label>
            <div class="layui-input-block">
                <textarea class="layui-textarea" placeholder=""></textarea>
            </div>
        </div>
    </div>
</form>
<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
</fieldset>
<form class="layui-form" method="post" id="searchFrm">
    <div class="layui-row">
        <div class="layui-col-md6">
            <div class="layui-inline">
                2018/10/09 12:16
            </div>
        </div>
        <div class="layui-col-md6">
            <div class="layui-inline">
                评估最后修改人 Worth，Robert
            </div>
        </div>
    </div>
</form>


<script src="${yeqifu}/static/layui/layui.js"></script>
<script type="text/javascript">
    var tableIns;
    layui.use(['jquery', 'layer', 'form', 'table'], function () {
        var $ = layui.jquery;
        var layer = layui.layer;
        var form = layui.form;
        var table = layui.table;
        var dtree = layui.dtree;
        //渲染数据表格
        tableIns = table.render({
            elem: '#customerTable'   //渲染的目标对象
            , url: '${yeqifu}/customer/loadAllCustomer.action' //数据接口
            , title: '客户数据表'//数据导出来的标题
            , toolbar: "#customerToolBar"   //表格的工具条
            , height: 'full-210'
            , cellMinWidth: 100 //设置列的最小默认宽度
            , page: true  //是否启用分页
            , cols: [[   //列表数据
                {type: 'checkbox', fixed: 'left'}
                , {field: 'identity', title: '身份证号', align: 'center', width: '200'}
                , {field: 'custname', title: '客户姓名', align: 'center', width: '125'}
                , {field: 'address', title: '客户地址', align: 'center', width: '125'}
                , {field: 'career', title: '客户职业', align: 'center', width: '150'}
                , {field: 'phone', title: '手机号码', align: 'center', width: '150'}

                , {
                    field: 'sex', title: '性别', align: 'center', width: '120', templet: function (d) {
                        return d.sex == '1' ? '<font color=blue>男</font>' : '<font color=red>女</font>';
                    }
                }
                , {field: 'createtime', title: '录入时间', align: 'center', width: '200'}
                , {fixed: 'right', title: '操作', toolbar: '#customerBar', align: 'center', width: '150'}
            ]],
            done:function (data, curr, count) {
                //不是第一页时，如果当前返回的数据为0那么就返回上一页
                if(data.data.length==0&&curr!=1){
                    tableIns.reload({
                        page:{
                            curr:curr-1
                        }
                    })
                }
            }
        });

        //模糊查询
        $("#doSearch").click(function () {
            var params = $("#searchFrm").serialize();
            tableIns.reload({
                url: "${yeqifu}/customer/loadAllCustomer.action?" + params,
                page: {curr: 1}
            })
        });

        //导出
        $("#doExport").click(function () {
            var params = $("#searchFrm").serialize();
            window.location.href="${yeqifu}/stat/exportCustomer.action?"+params;
        });

        //监听头部工具栏事件
        table.on("toolbar(customerTable)", function (obj) {
            switch (obj.event) {
                case 'add':
                    openAddCustomer();
                    break;
                case 'deleteBatch':
                    deleteBatch();
                    break;
            }
        });

        //监听行工具事件
        table.on('tool(customerTable)', function (obj) {
            var data = obj.data; //获得当前行数据
            var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
            if (layEvent === 'del') { //删除
                layer.confirm('真的删除【' + data.custname + '】这个客户么？', function (index) {
                    //向服务端发送删除指令
                    $.post("${yeqifu}/customer/deleteCustomer.action", {identity: data.identity}, function (res) {
                        layer.msg(res.msg);
                        //刷新数据表格
                        tableIns.reload();
                    })
                });
            } else if (layEvent === 'edit') { //编辑
                //编辑，打开修改界面
                openUpdateCustomer(data);
            }
        });

        var url;
        var mainIndex;

        //打开添加页面
        function openAddCustomer() {
            mainIndex = layer.open({
                type: 1,
                title: '添加客户',
                content: $("#saveOrUpdateDiv"),
                area: ['700px', '320px'],
                success: function (index) {
                    //清空表单数据
                    $("#dataFrm")[0].reset();
                    url = "${yeqifu}/customer/addCustomer.action";
                }
            });
        }

        //打开修改页面
        function openUpdateCustomer(data) {
            mainIndex = layer.open({
                type: 1,
                title: '修改客户',
                content: $("#saveOrUpdateDiv"),
                area: ['700px', '320px'],
                success: function (index) {
                    form.val("dataFrm", data);
                    url = "${yeqifu}/customer/updateCustomer.action";
                }
            });
        }

        //保存
        form.on("submit(doSubmit)", function (obj) {
            //序列化表单数据
            var params = $("#dataFrm").serialize();
            $.post(url, params, function (obj) {
                layer.msg(obj.msg);
                //关闭弹出层
                layer.close(mainIndex)
                //刷新数据 表格
                tableIns.reload();
            })
        });

        //批量删除
        function deleteBatch() {
            //得到选中的数据行
            var checkStatus = table.checkStatus('customerTable');
            var data = checkStatus.data;
            layer.alert(data.length);
            var params = "";
            $.each(data, function (i, item) {
                if (i == 0) {
                    params += "ids=" + item.identity;
                } else {
                    params += "&ids=" + item.identity;
                }
            });
            layer.confirm('真的要删除这些客户么？', function (index) {
                //向服务端发送删除指令
                $.post("${yeqifu}/customer/deleteBatchCustomer.action", params, function (res) {
                    layer.msg(res.msg);
                    //刷新数据表格
                    tableIns.reload();
                })
            });
        }

    });

</script>
</body>
</html>

