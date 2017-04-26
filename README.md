# iOS接入指南 

注：本文为C-Life iOS终端SDK的新手使用教程，只涉及教授SDK的使用方法，默认读者已经熟悉XCode开发工具的基本使用方法，以及具有一定的编程知识基础等。

## 1.相关名词定义

### 1. 小循环

  智能硬件与手机通过连接同一个路由器实现局域网内部的通信，我们称之为小循环。

### 2. 大循环

   智能设备通过路由器或直接接入互联网以实现用户的远程监测与控制，我们称为大循环。
   
### 3. productId
   
   设备产品号，设备在开放平台管理系统录入设备的时候，系统会根据设备录入的设备大类、设备小类、客户代码、DeviceKey、设备编码生成一个productId，可在开放平台管理系统上看到。
   
   
### 4. deviceId

   设备号，当一个设备通过设备绑定的接口初次接入开放平台时，开放平台会自动根据productId以及设备的mac地址为此设备注册一个deviceId，此deviceId全网唯一，用于通过开放平台进行设备的操作。


## 2 集成准备

### 2.1 C-Life开放平台账户注册
进入[C-Life开放平台官网](http://open.clife.net/#/home)，注册开发者账号，此部分请参考[C-Life平台接入流程](http://open.clife.net/#/developerdocument)。
  
  
### 2.2 新建设备接入
此部分请参考[C-Life平台接入流程](http://open.clife.net/#/developerdocument)。

### 2.3 向C-Life注册你的应用程序AppID和AppSecret
   请到**应用中心**页面创建移动应用，填写资料(必须填写应用包名BundleId)后，将获得AppID和AppSecret，可立即用于开发。但应用登记完成后还需要提交审核，只有审核通过的应用才能正式发布使用。此部分请参考[C-Life平台接入流程](http://open.clife.net/#/developerdocument)。
                                
                    
## 3.下载C-Life终端SDK文件并配置工程

### 3.1 确认本机安装的cocoapods能正常工作

     pod --help
     

### 3.2 编辑工程对应的Podfile文件
     
     platform :ios, '7.0'

     target :"HETOpenSDKDemo" do

     pod 'HETOpenSDK','0.1.1'

     end
     inhibit_all_warnings!

### 3.3 安装
   以下两种方式任选一种就可以：
    
    1.pod install --verbose --no-repo-update 
    2.pod update --verbose --no-repo-update

### 3.4 允许Xcode7支持Http传输方法
允许XCode7以上版本支持Http传输方法,如果用的是Xcode7以上版本时，需要在App项目的plist手动加入以下key和值以支持http传输:

    
    <key>NSAppTransportSecurity</key> 
      <dict> 
    <key>NSAllowsArbitraryLoads</key> 
        <true/> 
    </dict>
    
	 
	                           
## 4.在代码中使用
### 4.1 在AppDelegate 中如下地方添加，注册使用SDK

   
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
		// Override point for customization after application launch.
		//注册H&T开放平台SDK
		[HETOpenSDK registerAppId:"yourAPPId" appSecret:"yourAPPSecret"];
		return YES;
	} 
  
   
 yourAPPId、yourAPPSecret的值是在“应用创建”时生成的AppID、AppSecret。 在如下图查看: 
 ![](https://github.com/C-Life/clife_open_ios_sdk/blob/master/image/AppID.png?raw=true)

   <font color=red>注意</font>:如果网络请求出现AppID不合法，请检查Xcode工程里面的BundleId和appId，必须跟在开放平台创建应用时填的BundleId和AppID保持一致。
   
   
### 4.2 授权登录
 参考HETAuthorize类里面方法,调用authorizeWithCompleted接口会弹出授权登录，注册，找回密码的界面，登录成功后接口返回当前用户HETAccount信息，HETAccount类里面的openId（授权用户唯一标识）可用于与自己平台的账户体系关联。
     
  
	/**
	*  是否授权认证
	*
	*  @return   YES为已经授权登录
	*/
	- (BOOL)isAuthenticated;
	/**
	*  授权认证
	*
	*  @param completedBlock 授权认证回调，可获取账号信息
	*/
    - (void)authorizeWithCompleted:(authenticationCompletedBlock)completedBlock;
  
    
使用如下：
  
 
   //检查SDK是否已经授权登录，否则不能使用
   HETAuthorize *auth = [[HETAuthorize alloc] init];
	self.auth = auth;
	if (![auth isAuthenticated]) {
	    [auth authorizeWithCompleted:^(HETAccount *account, NSError *error)    {
	
	
	    }];
	
	 }	

	
	
	
### 4.3 取消授权认证，退出当前账号


  
    /**
    *  取消授权认证
    */
    - (void)unauthorize; 
  
   
   
###4.4 获取用户基本信息

   参考HETAuthorize类里面方法
       

    /**
    *  获取用户信息
    *
    *  @param success
    *  @param failure
    */
    -(void)getUserInformationSuccess:(successBlock)success failure:(failureBlock)failure; 
 
    
接口返回的结果数据：

    {
     "code":0,
     "data":{
        "userId": "d09f572c60ffced144d6cfc55a6881b9",   
        "userName": "葫芦娃",
        "email":"",
        "phone":"",
        "sex": 1,
        "birthday": "2014-12-31",
        "weight": 48000,
        "height": 163,
        "avatar": "",
        "city": "深圳"
     }
    }
 
| 字段名称 | 字段类型 | 字段说明 |
|:-------:|:-------:|:-------:|
|userName|	string|用户名称|
|phone	  |string	   |   用户手机|
|email	|string	|用户邮箱|
|sex	|number	|性别（1-男，2-女）|
|birthday	|string	|生日（yyyy-MM-dd）|
|weight	|number	|体重（克）|
|height	|number	|身高（厘米）|
|avatar	|string	|头像URL|
|city	|string|	城市名|
    
    
    
      
##4.5 设备绑定

   <font color=red>注意</font>: deviceId参数来源于获取所有绑定的设备列表（fetchAllBindDeviceSuccess:）里设备的基本信息的deviceId字段
   
   
### 4.5.1 WiFi设备的绑定，设备配置连接上路由器的设备使用此接口进行设备绑定
   
   在此我们以WiFi设备为例,APP广播路由器ssid和密码，开启扫描设备服务将扫描到的设备进行绑定，获取绑定结果回调。
     
   我们并未在开放平台SDK里集成C-Life平台所有WiFi模组。每个单独的WiFi模组对应的smartlink方式Framework将独立提供，用户将根据自己的需求自行接入。
   
   使用如下：    
	
 
	//------------------第三方设备接入路由，厂家自己实现,例如汉枫WiFi模块-------------------------
	smtlk =[[HFSmartLink alloc]init];
	smtlk.isConfigOneDevice = false;
	smtlk.waitTimers = 30;
	[smtlk startWithKey:self.wifiPassword processblock:^(NSInteger process) {} successBlock:^(HFSmartLinkDeviceInfo *dev) {} failBlock:^(NSString *failmsg) {	} endBlock:^(NSDictionary *deviceDic) {}];
	//----------------------------------------------------------------
	//启动扫描设备服务并设置100秒的超时时间
	 [[HETWIFIBindBusiness sharedInstance] startBindDeviceWithProductId:self.productId withTimeOut:100 completionHandler:^(HETDevice *deviceObj, NSError *error) {
        NSLog(@"设备mac地址:%@,%@",deviceObj.device_mac,error);
        }
    }];
  
  
 这里的productId参数来源于以下方式：开放平台管理系统->应用菜单项->关联产品的产品ID: 
![产品ID](https://github.com/C-Life/clife_open_ios_sdk/blob/master/image/productId.png?raw=true)




### 4.5.2 其他方式的设备绑定（不需要配置入网的WiFi设备，非开放平台协议的蓝牙设备），使用此接口进行设备绑定
  
  
  
    /**
    *  设备绑定
    *
    *  @param macAddr         设备mac地址
    *  @param deviceProductId  设备型号标识
    *  @param deviceId         设备标识（更换MAC地址的时候才需要值，其他情况填nil就行)
    *  @param success         绑定成功的回调
    *  @param failure         绑定失败的回调
    */

    -(void)bindDeviceWithDeviceMAC:(NSString *)macAddr
                      deviceProductId:(NSInteger) deviceProductId
                      deviceId:(NSString *) deviceId
                       success:(successBlock)success
                     failure:(failureBlock)failure;
                     
                     
                     
##4.6 设备管理
 
### 4.6.1 获取已经绑定的设备列表
   
   绑定成功后，用户可以获取绑定成功的设备列表，获取到设备列表拿到设备的deviceId才可以控制设备
   
    
   
	 /**
    *  查询绑定的所有设备列表
    *
    *  @param success  设备列表返回HETDevice对象数组
    *  @param failure 失败的回调
    */
    - (void)fetchAllBindDeviceSuccess:(void (^)(NSArray<HETDevice *>* deviceArray))success failure:(failureBlock)failure;
   
   
  
  
### 4.6.2 修改设备信息
  
   修改设备信息，用户可以修改设备的名称
	   
 
    /**
    *  修改设备基础信息
    *
    *  @param deviceId   设备标识
    *  @param deviceName 设备名称
    *  @param roomId     房间标识（绑定者才可以修改房间位置）
    *  @param success    成功的回调
    *  @param failure    失败的回调
    */
    - (void)updateDeviceInfoWithDeviceId:(NSString *)deviceId  deviceName:(NSString *)deviceName roomId:(NSString *)roomId  success:(successBlock)success  failure:(failureBlock)failure;
  
     
     
     
     
	
	
### 4.6.3 解绑设备
   
   解除设备与服务器的绑定关系
	      
	
    /**
    *  解除设备绑定
    *
    *  @param deviceId 设备deviceId
    *  @param success  成功的回调
    *  @param failure  失败的回调
    */
    - (void)unbindDeviceWithDeviceId:(NSString *)deviceId success:(successBlock)success failure:(failureBlock)failure;
 

	
	
### 4.6.4 单次获取WiFi设备大循环模式下控制数据、七天之内的历史控制数据  
	
   参考HETDeviceRequestBusiness类
     
	/**
	*  查询设备控制数据信息（通过服务器单次查询）
	*
	*  @param deviceId 设备deviceId
	*  @param success  成功的回调
	*  @param failure  失败的回调
	*/
	- (void)fetchDeviceConfigDataWithDeviceId:(NSString *)deviceId success:(successBlock)success failure:(failureBlock)failure;

	/**
    *  获取设备控制数据列表（七天之内）（通过服务器单次查询）
    *
    *  @param deviceId  设备标识
    *  @param startDate 开始时间
    *  @param endDate   结束时间（默认为当天）
    *  @param pageRows  每页显示的行数，默认为20
    *  @param pageIndex 当前页，默认为1
    *  @param success   成功的回调
    *  @param failure   失败的回调
    */
    - (void)fetchDeviceConfigDataListWithDeviceId:(NSString *)deviceId
                                    startDate:(NSString *)startDate
                                      endDate:(NSString *)endDate
                                     pageRows:(NSString *)pageRows
                                    pageIndex:(NSString *)pageIndex
                                      success:(successBlock)success
                                      failure:(failureBlock)failure;

   
   
### 4.6.5 单次获取WiFi设备大循环模式下运行数据、七天之内的历史运行数据  
	
   参考HETDeviceRequestBusiness类
    
	/**
	*  查询设备运行数据信息（通过服务器单次查询）
	*
	*  @param deviceId 设备deviceId
	*  @param success  成功的回调
	*  @param failure  失败的回调
	*/
	- (void)fetchDeviceRunDataWithDeviceId:(NSString *)deviceId
	                         success:(successBlock)success
	                         failure:(failureBlock)failure;                           
    /**
    *  获取设备运行数据列表（七天之内）（通过服务器单次查询）
    *
    *  @param deviceId  设备标识
    *  @param startDate 开始时间
    *  @param endDate   结束时间（默认为当天）
    *  @param pageRows  每页显示的行数，默认为20
    *  @param pageIndex 当前页，默认为1
    *  @param success   成功的回调
    *  @param failure   失败的回调
    */
    - (void)fetchDeviceRundataListWithDeviceId:(NSString *)deviceId
                                 startDate:(NSString *)startDate
                                   endDate:(NSString *)endDate
                                  pageRows:(NSString *)pageRows
                                 pageIndex:(NSString *)pageIndex
                                   success:(successBlock)success
                                   failure:(failureBlock)failure;                     
 


### 4.6.6 单次获取WiFi设备大循环模式下故障数据、七天之内的历史故障数据
   
	
  
	/**
	*  查询设备配置数据信息（通过服务器单次查询）
	*
	*  @param deviceId 设备deviceId
	*  @param success  成功的回调
	*  @param failure  失败的回调
	*/
	- (void)fetchDeviceConfigDataWithDeviceId:(NSString *)deviceId
	                         success:(successBlock)success
	                         failure:(failureBlock)failure;                        
    /**
    *  获取设备故障数据列表（七天之内）（通过服务器单次查询）
    *
    *  @param deviceId  设备标识
    *  @param startDate 开始时间
    *  @param endDate   结束时间（默认为当天）
    *  @param pageRows  每页显示的行数，默认为20
    *  @param pageIndex 当前页，默认为1
    *  @param success   成功的回调
    *  @param failure   失败的回调
    */
    - (void)fetchDeviceErrorDataListWithDeviceId:(NSString *)deviceId
                                   startDate:(NSString *)startDate
                                     endDate:(NSString *)endDate
                                    pageRows:(NSString *)pageRows
                                   pageIndex:(NSString *)pageIndex
                                     success:(successBlock)success
                                     failure:(failureBlock)failure;
                                     
   

    
### 4.7 WiFi设备控制

   参考HETDeviceControlBusiness类，此类封装了WiFi设备的控制与数据的业务，会根据当前网络环境大小循环自动切换，如果当前设备处于大循环状态模式，5s会回调一次数据，如果设备当前处于小循环状态，数据会实时回调
    
   [1] 初始化参数，获取设备运行数据，控制数据，故障数据
   	
   
    /**
    *
    *
    *  @param device                设备的对象
    *  @param bsupport              是否需要支持小循环，默认为NO，如不需支持小循环设置为NO
    *  @param runDataBlock          设备运行数据block回调
    *  @param cfgDataBlock          设备配置数据block回调
    *  @param errorDataBlock        设备故障数据block回调
    */
    - (instancetype)initWithHetDeviceModel:(HETDevice *)device
                  isSupportLittleLoop:(BOOL)bsupport
                        deviceRunData:(void(^)(id responseObject))runDataBlock
                        deviceCfgData:(void(^)(id responseObject))cfgDataBlock
                      deviceErrorData:(void(^)(id responseObject))errorDataBlock;
 
  	
  	
  	
  	
   [2]启动服务,开始获取设备的数据
  
  
   
    //启动服务
    - (void)start;           
   
   [3]停止服务,停止获取设备的数据	
  
   
    //停止服务
    - (void)stop;             
  
   
   [4]下发设备控制
  
   关于updateflag

   这个修改标记位是为了做统计和配置下发的时候设备执行相应的功能。下发数据必须传递updateflag标志

   例如，空气净化器（广磊K180）配置信息协议：

   紫外线(1)、负离子(2)、臭氧(3)、儿童锁(4)、开关(5)、WiFi(6)、过滤网(7)、模式(8)、定时(9)、风量(10)
   上面一共上10个功能，那么updateFlag就2个字节，没超过8个功能为1个字节，超过8个为2个字节，超过16个为3个字节，以此类推。

   打开负离子，2个字节，每一个bit的值为下：

   0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0


  
   
	/**
	*  设备控制
	*
	*  @param jsonString   设备控制的json字符串,协议中的控制节点和对应值组成的字典经转换为json字符串
	*  @param successBlock 控制成功的回调
	*  @param failureBlock 控制失败的回调
	*/
	- (void)deviceControlRequestWithJson:(NSString *)jsonString withSuccessBlock:(void(^)(id responseObject))successBlock withFailBlock:(void(^)( NSError *error))failureBlock; 
   
   
   
	
### 4.8 WiFi设备升级
   
   WiFi设备升级流程:查询设备新老固件版本信息->确认升级->查询设备升级进度->升级成功确认
   
   [1]查询设备固件版本信息
   
    
  
    /**
    *  查询设备固件版本
    *
    *  @param deviceId 设备标识
    *  @param success  成功的回调
    *  @param failure  失败的回调
    */

     -(void)deviceUpgradeCheckWithDeviceId:(NSString *)deviceId
                              success:(successBlock)success
                              failure:(failureBlock)failure;
                              
       
                          
                              
                              
   [2]确认设备升级
   
    
   
    /**
     *  确认设备升级
     *
     *  @param deviceId 设备标识
     *  @param deviceVersionType 设备版本类型（1-WIFI，2-PCB（目前蓝牙设备、wifi设备都只升级pcb）,3-蓝牙模块升级）
     *  @param deviceVersionId   设备版本标示
     *  @param success  成功的回调
     *  @param failure  失败的回调
    */

    -(void)deviceUpgradeConfirmWithDeviceId:(NSString *)deviceId
                      deviceVersionType:(NSString *)deviceVersionType
                        deviceVersionId:(NSString *)deviceVersionId
                              success:(successBlock)success
                              failure:(failureBlock)failure;
                              
      
  
     
                              
   [3]查询升级进度
   
     
   
    /**
     *  查询升级进度
     *
     *  @param deviceId          设备标识
     *  @param deviceVersionId   设备版本标示
     *  @param success           成功的回调
     *  @param failure           失败的回调
    */

    -(void)fetchDeviceUpgradeProgress:(NSString *)deviceId
                        deviceVersionId:(NSString *)deviceVersionId
                                success:(successBlock)success
                                failure:(failureBlock)failure;                          
       
                          
                              
                              
    
                              
   [4]升级成功确认
   
     
 
    /**
    *  升级成功确认
    *
    *  @param deviceId        设备标识
    *  @param deviceVersionId 设备版本标示
    *  @param success           成功的回调
    *  @param failure           失败的回调
    */

    -(void)deviceUpgradeConfirmSuccessWithDeviceId:(NSString *)deviceId
                               deviceVersionId:(NSString *)deviceVersionId
                                       success:(successBlock)success
                                       failure:(failureBlock)failure;
                                                                             
 

  
  	
	
	

	
  


