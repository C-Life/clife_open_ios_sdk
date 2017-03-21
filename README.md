#iOS接入指南 

注：本文为C-Life iOS终端SDK的新手使用教程，只涉及教授SDK的使用方法，默认读者已经熟悉XCode开发工具的基本使用方法，以及具有一定的编程知识基础等。
                                  
##1.向C-Life注册你的应用程序
请到 应用中心 页面创建移动应用，填写资料(必须填写应用包名BundleId)后，将获得AppID和AppSecret，可立即用于开发。但应用登记完成后还需要提交审核，只有审核通过的应用才能正式发布使用。
                    
##2.下载C-Life终端SDK文件

```objc
   pod 'HETOpenSDK','0.1.1'
   
```
##3.搭建开发环境
1. 在XCode中建立你的工程。
2. 允许XCode7以上版本支持Http传输方法,如果用的是Xcode7以上版本时，需要在App项目的plist手动加入以下key和值以支持http传输:

	```objc
    <key>NSAppTransportSecurity</key> 
      <dict> 
    <key>NSAllowsArbitraryLoads</key> 
        <true/> 
    </dict>
	```
3. pod导入HETOpenSDK库

	```objc
   platform :ios, '7.0'
   pod 'HETOpenSDK','0.1.1'
   inhibit_all_warnings!
  ```
  
##4.在代码中使用
1.  注册AppID和AppSecret     

	```objc
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
		// Override point for customization after application launch.
		//注册H&T开放平台SDK
		[HETOpenSDK registerAppId:"yourAPPId" appSecret:"yourAPPSecret"];
		return YES;
	} 
	```	
	
2. 授权登录
   参考HETAuthorize类里面方法
     
	```objc
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
	```
	
   使用如下：
     
    ```objc
    //检查SDK是否已经授权登录，否则不能使用
	HETAuthorize *auth = [[HETAuthorize alloc] init];
	self.auth = auth;
	if (![auth isAuthenticated]) {
	    [auth authorizeWithCompleted:^(HETAccount *account, NSError *error)    {
	
	
	    }];
	
	}
	
	```
3. 获取用户基本信息

   参考HETAuthorize类里面方法
    
    ```objc
    
    /**
    *  获取用户信息
    *
    *  @param success
    *  @param failure
    */
    -(void)getUserInformationSuccess:(successBlock)success
                         failure:(failureBlock)failure;

  
    ```
4. 设备绑定

    设备绑定流程：广播路由器ssid和密码，开启扫描设备服务将扫描到的设备进行绑定，获取绑定结果回调
   
   
   使用如下：    
	
	```objc
	//------------------第三方设备接入路由，厂家自己实现,例如汉枫WiFi模块----------------------------
	smtlk =[[HFSmartLink alloc]init];
	smtlk.isConfigOneDevice = false;
	smtlk.waitTimers = 30;
	[smtlk startWithKey:self.wifiPassword processblock:^(NSInteger process) {
	
	} successBlock:^(HFSmartLinkDeviceInfo *dev) {
	    //[self  showAlertWithMsg:[NSString stringWithFormat:@"%@:%@",dev.mac,dev.ip] title:@"OK"];
	} failBlock:^(NSString *failmsg) {
	    //[self  showAlertWithMsg:failmsg title:@"error"];
	} endBlock:^(NSDictionary *deviceDic) {
	
	
	}];
	//----------------------------------------------------------------
	//启动扫描设备服务
	 [[HETWIFIBindBusiness sharedInstance] startBindDeviceWithProductId:self.productId withTimeOut:100 completionHandler:^(HETDevice *deviceObj, NSError *error) {
        NSLog(@"设备mac地址:%@,%@",deviceObj.device_mac,error);
        }
    }];
	```
    
    这里的productId参数来源于以下方式：
     开放平台管理系统-应用菜单项 关联产品的产品ID 
![产品ID](https://i.niupic.com/images/2016/09/21/NB8R71.png)
    	
	
	
	
5. 设备管理
 
    5.1 获取绑定设备列表
   
       绑定成功后，用户可以获取绑定成功的设备列表，获取到设备列表，才可以控制设备
    
    ```objc
	/**
 *  查询绑定的所有设备列表
 *
 *  @param success  设备列表返回HETDevice对象数组
 *  @param failure 失败的回调
 */
- (void)fetchAllBindDeviceSuccess:(void (^)(NSArray<HETDevice *>* deviceArray))success
                               failure:(failureBlock)failure;	                          
    ```
	
	5.2 修改设备信息
	    
	   修改设备信息，用户可以修改设备的名称
	   
	 ```objc
    /**
    *  修改设备基础信息
    *
    *  @param deviceId   设备标识
    *  @param deviceName 设备名称
    *  @param roomId     房间标识（绑定者才可以修改房间位置）
    *  @param success    成功的回调
    *  @param failure    失败的回调
    */
    - (void)updateDeviceInfoWithDeviceId:(NSString *)deviceId  deviceName:(NSString *)deviceName
  roomId:(NSString *)roomId  success：(successBlock)success
 failure:(failureBlock)failure;
     ```
	
 5.3 解绑设备
	    
	   解除设备绑定
	      
	```objc
    /**
    *  解除设备绑定
    *
    *  @param deviceId 设备deviceId
    *  @param success  成功的回调
    *  @param failure  失败的回调
    */
   - (void)unbindDeviceWithDeviceId:(NSString *)deviceId success:(successBlock)success failure:(failureBlock)failure;
   ```
   
   
    
 5.4 获取设备控制数据、七天之内的历史控制数据  
	
	参考HETDeviceRequestBusiness类
    
	```objc
	/**
	*  查询设备控制数据信息
	*
	*  @param deviceId 设备deviceId
	*  @param success  成功的回调
	*  @param failure  失败的回调
	*/
	- (void)fetchDeviceConfigDataWithDeviceId:(NSString *)deviceId success:(successBlock)success
failure:(failureBlock)failure;
	                         
	
	/**
    *  获取设备控制数据列表（七天之内）
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
   ```
   
	5.5 获取设备运行数据、七天之内的历史运行数据  
	
    参考HETDeviceRequestBusiness类
    
   ```objc
	/**
	*  查询设备运行数据信息
	*
	*  @param deviceId 设备deviceId
	*  @param success  成功的回调
	*  @param failure  失败的回调
	*/
	- (void)fetchDeviceRunDataWithDeviceId:(NSString *)deviceId
	                         success:(successBlock)success
	                         failure:(failureBlock)failure;	                         	                         	 
	 
	 
	                            
    /**
    *  获取设备运行数据列表（七天之内）
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
   ```


   
 5.6 获取设备故障数据、七天之内的历史故障数据  
	
    ```objc
	/**
	*  查询设备配置数据信息
	*
	*  @param deviceId 设备deviceId
	*  @param success  成功的回调
	*  @param failure  失败的回调
	*/
	- (void)fetchDeviceConfigDataWithDeviceId:(NSString *)deviceId
	                         success:(successBlock)success
	                         failure:(failureBlock)failure;
	                         
	                         
	                         
	                         
    /**
    *  获取设备故障数据列表（七天之内）
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
	```

    
6. WiFi设备控制

   参考HETDeviceControlBusiness类
    
   [1] 初始化参数，获取设备运行数据，控制数据，故障数据
   	
    ```objc
    /**
 *
 *
 *  @param device                设备的对象
 *  @param bsupport              是否需要支持小循环，默认为NO，如不需支持小循环，设置为NO
 *  @param deviceControlBusiness 设备控制业务类
 *  @param runDataBlock          设备运行数据block回调
 *  @param cfgDataBlock          设备配置数据block回调
 *  @param errorDataBlock        设备故障数据block回调
 */
- (instancetype)initWithHetDeviceModel:(HETDevice *)device
                  isSupportLittleLoop:(BOOL)bsupport
                        deviceRunData:(void(^)(id responseObject))runDataBlock
                        deviceCfgData:(void(^)(id responseObject))cfgDataBlock
                      deviceErrorData:(void(^)(id responseObject))errorDataBlock;        
  	```
  	
  [2]启动服务,开始获取设备的数据
  
  
   ```objc
    //启动服务
    - (void)start;
              
   ```
  [3]停止服务,停止获取设备的数据	
  
   ```objc
    //停止服务
    - (void)stop;
  	             
   ```
   
  [4]下发设备控制
  
   关于updateflag

   这个修改标记位是为了做统计和配置下发的时候设备执行相应的功能。下发数据必须传递updateflag标志

  例如，空气净化器（广磊K180）配置信息协议：

  紫外线(1)、负离子(2)、臭氧(3)、儿童锁(4)、开关(5)、WiFi(6)、过滤网(7)、模式(8)、定时(9)、风量(10)
  上面一共上10个功能，那么updateFlag就2个字节，没超过8个功能为1个字节，超过8个为2个字节，超过16个为3个字节，以此类推。

  打开负离子，2个字节，每一个bit的值为下：

  0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0


  
   ```objc
	/**
	*  设备控制
	*
	*  @param jsonString   设备控制的json字符串
	*  @param successBlock 控制成功的回调
	*  @param failureBlock 控制失败的回调
	*/
	- (void)deviceControlRequestWithJson:(NSString *)jsonString withSuccessBlock:(void(^)(id responseObject))successBlock withFailBlock:(void(^)( NSError *error))failureBlock;
	
	  
   ```
   
   
	
7. WiFi设备升级
   
   先查询设备新老固件版本信息，然后确认升级，查询设备升级进度，升级成功确认
   
   [1]查询设备固件版本信息
   
    
   ```objc
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
                              
       
   ```                        
                              
                              
   [2]确认设备升级
   
    
   ```objc
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
                              
      
   ```
     
                              
   [3]查询升级进度
   
     
   ```objc
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
                              
                              
       
   ```                        
                              
                              
    
                              
   [4]升级成功确认
   
     
   ```objc 
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
                              
                              
                              
                                                   
   ``` 

  
  	
	
	

	
       
#注意事项
*  如果网络请求出现appId不合法，请检查工程里面的BundleId和appId，必须跟在平台申请时候填的BundleId和appId一样才行
*  deviceId参数来源于获取所有绑定的设备列表（fetchAllBindDeviceSuccess:）里设备的基本信息的deviceId字段


