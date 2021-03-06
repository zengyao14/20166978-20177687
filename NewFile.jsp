<%@ page language="java" contentType="text/html; charset=UTF-8"

    pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html lang="en">

  <head>

    <meta charset="utf-8">


    <style>


    .node {

        cursor: pointer;

    }



    .node circle {

        stroke: '#f0f';

        stroke-width: 4px;

    }



    .node text {

      font: 12px sans-serif;

    }



    .link {

      fill: none;

      stroke: #ccc;

      stroke-width: 2px;

    }

  .fill_normal {

    fill: green;

  }

  .bling{ animation: alarm 0.4s  ease-in  infinite ; fill:yellow; font-weight: bold;}

  @keyframes alarm {

      0%{ fill:#FF9966;}

      50%{ fill:#FF3333;}

      100%{ fill:#FF9966;}

  }



    </style>

  </head>

  <body background="background1.jpg"style="height: 900px; width: 1000px; ">




    








  <!-- load the d3.js library -->

    <script src="http://d3js.org/d3.v3.min.js"></script>

	<script type="text/javascript">

	 var treeData = [{

         "name": "",

         "parent": "",

         "children": [{

             "name": "",

             "parent": "",

             "children": [{

                 "name": "",

                 "parent": ""

             }, {

                 "name": "",

                 "parent": "",

                 "children": [{

                     "name": "",

                     parent: ""

                 }]

             }, {

                 "name": "",

                 "parent": ""

             }, {

                 "name": "",

                 "parent": ""

             }]

         }, {

             "name": "",

             "parent": "",

             "children": [{

                 "name": "",

                 "parent": ""

             }, {

                 "name": "",

                 "parent": ""

             }, ]



         }, {

             "name": "",

             "parent": ""

         }, ]

     }];

     

     // ************** Generate the tree diagram  *****************

     /*------------------初始化函数开始--------------------*/

     function treeInit(tree_num) { //画第tree_num棵树

     	var margin = {top: 20, right: 120, bottom: 20, left: 120},

         width = 960 - margin.right - margin.left,

         height = 500 - margin.top - margin.bottom;



     var i = 0,

         duration = 750,//过渡延迟时间

         root;


     var tree = d3.layout.tree()//创建一个树布局

         .size([height, width]);


     var diagonal = d3.svg.diagonal()

         .projection(function(d) { return [d.y, d.x]; });//创建新的斜线生成器


     //声明与定义画布属性

     var svg = d3.select("body").append("svg")

         .attr("width", width + margin.right + margin.left)

         .attr("height", height + margin.top + margin.bottom)

       .append("g")

         .attr("transform", "translate(" + margin.left + "," + margin.top + ")");


     root = treeData[tree_num];//treeData为上边定义的节点属性

     root.x0 = height / 2;

     root.y0 = 0;


     update(root);


     d3.select(self.frameElement).style("height", "500px");


     function update(source) {


       // Compute the new tree layout.计算新树图的布局

       var nodes = tree.nodes(root).reverse(),

           links = tree.links(nodes);


       // Normalize for fixed-depth.设置y坐标点，每层占180px

       nodes.forEach(function(d) { d.y = d.depth * 180; });


       // Update the nodes…每个node对应一个group

       var node = svg.selectAll("g.node")

           .data(nodes, function(d) { return d.id || (d.id = ++i); });//data()：绑定一个数组到选择集上，数组的各项值分别与选择集的各元素绑定


       // Enter any new nodes at the parent's previous position.新增节点数据集，设置位置

       var nodeEnter = node.enter().append("g")  //在 svg 中添加一个g，g是 svg 中的一个属性，是 group 的意思，它表示一组什么东西，如一组 lines ， rects ，circles 其实坐标轴就是由这些东西构成的。

           .attr("class", "node") //attr设置html属性，style设置css属性

           .attr("transform", function(d) { return "translate(" + source.y0 + "," + source.x0 + ")"; })

           .on("click", click);


       //添加连接点---此处设置的是圆圈过渡时候的效果（颜色）

       // nodeEnter.append("circle")

         //   .attr("r", 1e-6);//d 代表数据，也就是与某元素绑定的数据。


       nodeEnter.append("path")

         .style("stroke-width", "2px")

         .style("stroke", "#4682b4")

         .style("fill", "white")

         .attr("d", d3.svg.symbol()

                      .size(function(d){ if

                         (d.value <= 9) { return "400"; } else if

                         (d.value >= 9) { return "400";}

                       })

                      .type(function(d) { if

                         (d.value <= 9) { return "triangle-up"; } else if

                         (d.value >= 9) { return "circle";}

                       }))

         .attr('class',function(d){

           if(d.value <= 9 ){

             return 'bling';

           }else{

             return 'fill_normal';

           }

         });


       //添加标签

       nodeEnter.append("text")

           .attr("x", function(d) { return d.children || d._children ? -13 : 13; })

           .attr("dy", ".35em")

           .attr("text-anchor", function(d) { return d.children || d._children ? "end" : "start"; })

           .text(function(d) { return d.name; })

           .style("fill-opacity", 1e-6);


       // Transition nodes to their new position.将节点过渡到一个新的位置-----主要是针对节点过渡过程中的过渡效果

       //node就是保留的数据集，为原来数据的图形添加过渡动画。首先是整个组的位置

       var nodeUpdate = node.transition()  //开始一个动画过渡

           .duration(duration)  //过渡延迟时间,此处主要设置的是圆圈节点随斜线的过渡延迟

           .attr("r", 10)

         .attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; });

       //更新连接点的填充色

       // nodeUpdate.select("circle")

       // .attr("r", 10)

       // .attr('class',function(d){

       //   if(d.value <= 9){

       //     return 'bling';

       //   }else{

       //     return 'fill_normal';

       //   }

       // });

       nodeUpdate.select("path")

         .style("stroke-width", "2px")

         .style("stroke", "#4682b4")

         .style("fill", "white")

         .attr("d", d3.svg.symbol()

                      .size(function(d){ if

                         (d.value <= 9) { return "400"; } else if

                         (d.value >= 9) { return "400";}

                       })

                      .type(function(d) { if

                         (d.value <= 9) { return "triangle-up"; } else if

                         (d.value >= 9) { return "circle";}

                       }))

         .attr('class',function(d){

           if(d.value <= 9 ){

             return 'bling';

           }else{

             return 'fill_normal';

           }

         });


       nodeUpdate.select("text")

           .style("fill-opacity", 1);


       // Transition exiting nodes to the parent's new position.过渡现有的节点到父母的新位置。

       //最后处理消失的数据，添加消失动画

       var nodeExit = node.exit().transition()

           .duration(duration)

           .attr("transform", function(d) { return "translate(" + source.y + "," + source.x + ")"; })

           .remove();


       nodeExit.select("circle")

           .attr("r", 1e-6);


       nodeExit.select("text")

           .style("fill-opacity", 1e-6);


       // Update the links…线操作相关

       //再处理连线集合

       var link = svg.selectAll("path.link")

           .data(links, function(d) { return d.target.id; });

       // Enter any new links at the parent's previous position.

       //添加新的连线

       link.enter().insert("path", "g")

           .attr("class", "link")

           .attr("d", function(d) {

             var o = {x: source.x0, y: source.y0};

             return diagonal({source: o, target: o});  //diagonal - 生成一个二维贝塞尔连接器, 用于节点连接图.

           })

         .style("stroke",function(d){

           //d包含当前的属性console.log(d)

           return '#ccc';

         });


       // Transition links to their new position.将斜线过渡到新的位置

       //保留的连线添加过渡动画

       link.transition()

           .duration(duration)

           .attr("d", diagonal);


       // Transition exiting nodes to the parent's new position.过渡现有的斜线到父母的新位置。

       //消失的连线添加过渡动画

       link.exit().transition()

           .duration(duration)

           .attr("d", function(d) {

             var o = {x: source.x, y: source.y};

             return diagonal({source: o, target: o});

           })

           .remove();


       // Stash the old positions for transition.将旧的斜线过渡效果隐藏

       nodes.forEach(function(d) {

         d.x0 = d.x;

         d.y0 = d.y;

       });

     }


     //定义一个将某节点折叠的函数

     // Toggle children on click.切换子节点事件

     function click(d) {

       if (d.children) {

         d._children = d.children;

         d.children = null;

       } else {

         d.children = d._children;

         d._children = null;

       }

       update(d);

     }

}

	 

     /*-----------------------初始化函数结束*------------------------*/


	     //自定义json长度查找函数 也就是找到除了导师那一行一共有几行的总长，就拿例子中的说除了导师张三那一行还剩四行所以为4 

	     function getJsonLength(jsonData) {

	         var jsonLength = 0;

	         for (var item in jsonData) {

	             //alert("Son is " + item);

	             jsonLength++;

	         }


	         return jsonLength;

	     }

	     /*

	    check函数来检查，遍历之前所有树的所有子节点，查找是否有导师的学生也是导师的情况

	     */

	     //@nodes 源json树

	     //@find_name 要找的导师名

	     //@may_need 可能需要添加的json树 

	     function check(nodes, find_name, may_need, keke) {

	         var fanhui1 = 0;

	         var fanhui2 = 1;

	         var length_now = getJsonLength(nodes.children);

	         // alert("chang = " + length_now)

	         for (var ll = 0; ll < length_now; ll++) {

	             //alert(nodes.children[ll].name);导师的学生的名字

	             if (nodes.children[ll].name == find_name) {//如果导师的学生也为导师

	               
	                 nodes.children[ll] = may_need;//这是该导师的学生为导师的那棵树的根节点

	                 //alert("add success");

	                 return fanhui2;//如果导师的学生也为导师返回1 

	

	             } else {//如果导师的学生不为导师则递归查找下一个学生 是否为导师

	                 check(nodes.children[ll], find_name, may_need, keke);

	                 //return;

	             }

	         }


	         return fanhui1;

	     }


	     //追逐函数

	     /*

	     分割传输过来的数据并构造json树结构

	     */

	       function build() {

			alert("欢迎使用");

			    var count = 0; //定义儿子节点的编号

		        var flag = 0; //定义标志是否为关联树值为1

	            var all_data = document.getElementById("user").value;

	            var sclice_data = [];

	            var model_data = [];

	            model_data = all_data.split("\n\n");


	            //document.write(model_data);

	            //document.write(model_data.lenth);

	            

	            //生成树型结构数据

	            for (var j = 0; j < model_data.length; ++j) {

	                count = 0;

	                flag = 0;

	                count_shu = 0;

	                sclice_data = model_data[j].split("\n");

	                //document.write(sclice_data.length);

	                for (var i = 0; i < sclice_data.length; ++i) {

	                	 var head_tmp = "";

	                     var body_tmp = "";

	                     var hb = sclice_data[i].split("："); //从冒号分割一层字符串

	                     head_tmp = hb[0];//冒号前的内容

	              //document.write(head_tmp);

	                     body_tmp = hb[1];//冒号后的内容

	              //document.write(body_tmp);

	              //alert(head_tmp == "导师");

	              //alert(i);

	                     

	                     //处理冒号前的部分

	                     if (head_tmp == "导师")

	                     {

	                    	 

	                         var daoshi2 =

	                         {	 

	                             "name": body_tmp,

	                             "parent": "null",

	                             "children": [{}]

	                         }

	                    

	                         //alert(daoshi2.name)//弹出导师名

	                         treeData[j] = daoshi2; //将导师嵌入节点

	                         //alert(treeData[j]);

	                       

	                        

	                     }else {

	                    	 var children = 

	                    	 {

	                                 "name": head_tmp,

	                                 "parent": "null",

	                                 "children": [{}]

	                         }

	                    	 treeData[j].children[count] = children; //将导师的学生的年级及职业嵌入节点

	                         //处理冒号后的部分

	                         var bodies = body_tmp.split("、");

	                         for (var kk = 0; kk < bodies.length; ++kk) {

	                        	 var children = {

	                                     "name": bodies[kk],

	                                     "parent": "null"

	                                 }

	                                 //treeData.push(children);

	                             treeData[j].children[count].children[kk] = children; //将导师的学生的姓名嵌入节点

	                         }

	                         count++; //第二子节点编号加一，生成下一个第二子节点

	                     }  

	                     

	                }

	                //和前面所有的树比较，判断是否为关联树

	                var tree_tmp = treeData[j];

	                var name_tmp = treeData[j].name;

	                for (num_tmp = 0; num_tmp < j; num_tmp++) {

	                    

	                    //alert("flag = " + flag);

	                	flag = check(treeData[num_tmp], name_tmp, tree_tmp, num_tmp);

	                }

	                if (!flag) count_shu++;

	            

	            }

	            for (var i = 0; i <= count_shu; i++) {

	            	

	                treeInit(i)

	            }

	                   

		}

	</script>

		    <textarea id="user" rows="10" cols="30"></textarea>

    		<button onClick="build()">确认</button>

</body>

</html>