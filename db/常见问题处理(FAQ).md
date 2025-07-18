 

 

 

 

 

 

东航典型问题

处理集



目录

[1. Gaussdb问题	](#_Toc724892029 )

[1.1. Dbever连接报错	](#_Toc585601972 )

[2. DRS问题	](#_Toc294789203 )

[2.1. 增量同步报错	](#_Toc277361192 )

[2.2. 全量迁移报错	](#_Toc1570039954 )

 



# 1. **Gaussdb问题**

## 1.1. **Dbever****连接报错**

***\*问题描述：\****使用UGO迁移完对象后，用Dbever和代码连接数据库，都报错误：ERROR: currently not support type geometry

***\*处理过程：\****

通过查看/app/cluster/var/lib/log/Ruby/gs_log/dn_6001日志，查看到具体SQL为：

SELECT t.oid,t.*,c.relkind,format_type(nullif(t.typbasetype, 0), t.typtypmod) as base_type_name, d.description

​    FROM pg_catalog.pg_type t

​    LEFT OUTER JOIN pg_catalog.pg_type et ON et.oid=t.typelem

​    LEFT OUTER JOIN pg_catalog.pg_class c ON c.oid=t.typrelid

​    LEFT OUTER JOIN pg_catalog.pg_description d ON t.oid=d.objoid

​    WHERE t.typname IS NOT NULL

​    AND (c.relkind IS NULL OR c.relkind = 'c') AND (et.typcategory IS NULL OR et.typcategory <> 'C')

 

***\*该SQL由DBEver工具下发执行\****

***\*解决方案：通过在DBEver新建gen\*******\*eric\*******\*类型驱动解决\****

***\*配置先点击“库”，将本地驱动导进去\****

![img](assets/wps10.jpg) 

 

![img](assets/wps11.jpg)

**
**

# 2. **DRS问题**

## 2.1. **增量同步报错**

问题描述：使用DRS迁移增量报错：An error occurred in the process INCREMENT, caused by: update opcr.opc_segmentid failed: tid: 2, seqno: 2, [*.*.*.113:53214/*.*.*.28:8000] ERROR: syntax error at end of input  Position: 146

处理过程：

![img](assets/wps12.jpg)	查看了源目的端的表数据，发现不一致

![img](assets/wps13.jpg) 

然后根据报错，查看了目的端gaussdb的日志，发现执行的语句where后面没有跟条件

![img](assets/wps14.jpg) 

报错后，清空目的端表数据后，重新进行了表同步，但目前目的端没有数据进来。已确认信息：源目的端均创建了主键，源端日志格式为ROW

![img](assets/wps15.jpg) 

![img](assets/wps16.jpg)![img](assets/wps17.jpg) 

解决方案：

在DRS界面-运维管理添加这两个参数（先添加第一个，添加第一个解决后，第二个可不添加）：

参数1：*.global.replicator.nameCaseTypePolicy = keep

参数2：*.increment.replicator.filterPlugins =objectFilter,expireRecordFilter,transformationFilter,tableMappingFilter,hiddenPrimaryKeyFilter,dbmsCaseSensitiveFilter,ddlParserFilter,mysqlGeometryFilt



## 2.2. **全量迁移报错**

使用DRS迁移全量报错：invalid byte sequence for encoding UTF8.0x00

![img](assets/wps18.jpg) 

解决方案：

在DRS界面-运维管理添加参数：sync.datamove.replicator.standardizeStringType=true
