//
//  MacroDefinitions.h
//  KingProFrame
//
//  Created by JinLiang on 15/6/26.
//  Copyright (c) 2015年 king. All rights reserved.
//

//（上线前需要注释此行代码）
//#define API_URL [[NSUserDefaults standardUserDefaults] objectForKey:@"APINAME"]
//上线设置为0
#define SETNUMBER  0

//Api环境
//#define API_URL       @"http://api.eqbang.cn/api/"

//省钱口袋环境//api.maiyar.cn
#define API_URL         @"https://api.koudaishengqian.com/api/v1/"

//高德地图Key
#define LBS_Key       @"b5b1fb46e4ff975ee9076e216e2aad16"

//99$个推key
#define kAppId           @"FilIbJ6vV26FPAXj9e8B95"
#define kAppKey          @"0VDQGThzJc8jq11aRVql82"
#define kAppSecret       @"baOHu3swXp7lR1G6meRNw3"

//ShareSDK 的 key
#define ShareSDK_Key    @"43263bae2f25"
//微信分享的key
#define WeiXi_Key       @"wxe68819a570c073c8"
#define WeiXi_appSecret @"9fb81d14f4818630c6991f5061152bb1"
//新浪微博key
#define WeiBo_key       @"3623206292"
//新浪微博Secret
#define WeiBo_appSecret @"79969186ca41e92980478044653fc1a8"
//QQ分享的key
#define QQ_Key          @"1105961617"
//QQappSecret
#define QQ_appSecret    @"24cbR2xRNuKrAJN4"

//友盟key
#define UMENG_KEY @"53d9a79dfd98c57a9801724a"

//应用的内部版本号 对应的是build
#define APP_CLIENT_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
//上传到AppStore上面的版本号 对应的是version
#define AppStore_VERSION [[NSBundle mainBundle]   objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

//最终的url
#define CLOUD_API_URL     [NSString stringWithFormat:@"%@v%@/",API_URL,[APP_CLIENT_VERSION substringToIndex:3]]

#define viewWidth [UIScreen mainScreen].bounds.size.width
#define kViewHeight [UIScreen mainScreen].bounds.size.height


#define IOS7_OR_LATER ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0)

//定义RGBA 颜色快捷方法
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]

//本应用默认字体颜色 黄颜色
#define defaultColor [UIColor colorWithWhite:0.196 alpha:1.000]
//UITableviewCell 默认背景颜色
#define CELL_BG_COLLOR [UIColor colorWithRed:(255)/255.0f green:(255)/255.0f blue:(255)/255.0f \
alpha:(1)]
//设置图片
#define UIIMAGE(X) [UIImage imageNamed:(X)]
#define UIIMAGEORIGINAL(X) [[UIImage imageNamed:(X)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]

#define IOS7 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0)
#define IOS8 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0)
#define IOS9 ([[[UIDevice currentDevice]systemVersion] floatValue] >= 9.0)


#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Ps ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)


#define CART_TOTALPRICE       @"CART_TOTALPRICE"//购物车里面的总金额
#define CART_GOODSNUM         @"CART_GOODSNUM"//购物车里面的总金额
#define CART_CARTSHIPPING    @"CART_CARTSHIPPING" //满多少减运费
#define CART_REQUESTDIC       @"CART_REQUESDIC"//接口请求字典
#define CART_STANDARDFEE      @"CART_STANDARDFEE"    //配送费标准
#define CART_GOODSID          @"CART_GOODSID"  //商品ID
#define CART_GOODSID_TAG      @"CART_GOODSID_TAG"  //商品所在行的tag


//用户信息
#define LOGGED_USERNAME         @"LOGGED_USERNAME"//登录的用户名
#define LOGGED_USERINFO         @"LOGGED_USERINFO"//当前用户的信息
#define LOGGED_TOKEN            @"LOGGED_TOKEN"//用户的token
#define LOGGED_USERTYPE         @"LOGGED_USERTYPE"//用户类型
#define LOGGED_MARKIYPE         @"LOGGED_MARKIYPE"//配送员类型
#define LOCATIONINFO            @"LOCATIONINFO"//定位成功或失败存取KEY
#define CURRENTCITY             @"CURRENTCITY"//当前城市
#define CURRENTADDRESS          @"CURRENTADDRESS"//当前具体地址
#define EBEANRED            @"eBeanRed" // e豆红点标记
#define COUPONRED           @"couponRed"  //优惠券红点标记

#define CODE_LOGINFAIL  101  //登录失败错误code
#define CODE_ISLOGIN    @"CODE_ISLOGIN"        //是否单点登录

#define USERTYPE_AVERAGE        0 //用户
#define USERTYPE_SHOPOWNER      1 //店主

#define MARKITYPE_NO            0 //不是配送员
#define MARKITYPE_YES           1 //是配送员

#define HOMEINFO_CANCELLIST     @"HOMEINFO_CANCELLIST" //可选的取消订单原因列表


#define AddressLat          @"AddressLat"//经度
#define AddressLng          @"AddressLng"//纬度
/**定位成功后，用户所在位置信息*/
#define LocationAddress     @"locationAddress"
/**定位信息本地保存*/
#define AUTOLOCATIONADDRESS @"AUTOLOCATIONADDRESS"
/**自动定位通知*/
#define LOCATIONLATANDLNG @"LOCATIONLATANDLNG"
/**下单选择地址不是本市通知*/
#define CHANGELOCATIONLATANDLNG @"CHANGELOCATIONLATANDLNG"
//notification

#define NOTIFICATION_TIMEOUTORDER      @"NOTIFICATION_TIMEOUTORDER"     //顾客待抢单页面推送通知跳转
#define NOTIFICATION_GOTOORDERDETAIL  @"NOTIFICATION_GOTOORDERDETAIL" //顾客进入订单详情
#define NOTIFICATION_ENTERBACKGROUND  @"NOTIFICATION_ENTERBACKGROUND"//进入后台通知
#define NOTIFICATION_UPDATESHOPPINGCARTINFO  @"NOTIFICATION_UPDATESHOPPINGCARTINFO"//刷新购物车
#define NEWORDER_UPDATINFO              @"NEWORDER_UPDATINFO" //新订单通知
#define CANCELORDER_UPDATIONFO         @"CANCELORDER_UPDATIONFO"//取消订单通知
#define NOTIFICATION_RECEVIEDNOTIFICATION    @"NOTIFICATION_RECEVIEDNOTIFICATION" //接收推送通知
#define NOTIFICATION_LOGINCANCEL       @"NOTIFICATION_LOGINCANCEL"   //登录取消返回

//用户登录类型 1，自动登录，2，主动登录,0为未登录
#define KuserLoginType  @"userLoginType"
#define KUnLogin     @"0"
#define KAutoLogin   @"1"
#define KManualLogin @"2"

//取消登录类型
#define LOGIN_CANCELINDENTIFY @"LOGIN_CANCELINDENTIFY"
#define CANCELLOGIN_CONCANCEL       @"1" //主动取消登录
#define CANCELLOGIN_DEFAULT         @"0" //被动动取消登录 默认

#define kMessage_001    @"您是店主，仅能查看商品"
#define kMessage_002    @"您是配送员，仅能查看商品"

//信鸽推送跳转类型
#define XGTAG    1 //表示从消息进入view


//友盟统计  埋点事件ID
/**点击登录*/
#define Clik_Login        @"Clik_Login"  
/**确认登录*/
#define Cfm_Login         @"Cfm_Login"     
/**登录成功*/
#define Login_Succes      @"Login_Succes"
//#define Get_SMSCode       @"Get_SMSCode"   //获取短信验证码
//#define SMSCode_CmfLogin  @"SMSCode_CmfLogin" //验证码确认登录
//#define SMSLogin_Succes   @"SMSLogin_Succes" //验证码登录成功
/**点击注册*/
#define Clik_Reg          @"Clik_Reg"
/**获取语音验证码*/
#define Get_VoiceCode     @"Get_VoiceCode"
/**确认注册*/
#define Cfm_Reg           @"Cfm_Reg"
/**注册成功*/
#define Reg_Succes        @"Reg_Succes"
//#define AddFrom_MainPg    @"AddFrom_MainPg"//从首页垂直下滑加购物车
/**今日推荐*/
#define Today_Recmd       @"Today_Recmd"
/**清纯水饮*/
#define Cat_Water         @"Cat_Water"
/**粮油调味*/
#define Cat_GrainOil      @"Cat_GrainOil"
/**洗护日用*/
#define Cat_WashProt      @"Cat_WashProt"
/**牛奶咖啡 */
#define Cat_MilkCoff      @"Cat_MilkCoff"
/**酣畅酒饮 */
#define Cat_Wine          @"Cat_Wine"
/**闲暇小食 */
#define Cat_Snacks        @"Cat_Snacks"
/**饼干速食 */
#define Cat_Cookie        @"Cat_Cookie"
/**缤纷酷饮 */
#define Cat_Drinks        @"Cat_Drinks"
/**代买香烟 */
#define Cat_Cigaret       @"Cat_Cigaret"
/**点击购物车 */
#define Clik_ShopingCart  @"Clik_ShopingCart"
/**购物车立即结算 */
#define Cfm_Shopping      @"Cfm_Shopping"
/**点击广告栏 */
#define Clik_AD           @"Clik_AD"
/**推荐好友 */
#define Recomd2Frds       @"Recomd2Frds"
/**退出登录 */
#define Logout            @"Logout"
/**查看详情 */
#define View_Order        @"View_Order"
/**点击提现规则 */
#define Clik_Cash_Rule    @"Clik_Cash_Rule"
/**点击优惠劵规则 */
#define Clik_Coupon_Rule  @"Clik_Coupon_Rule"
/**判断跳登录 */
#define LINKLOGIN          @"eqbang://login"
/**链接跳优惠券 */
#define COUPONLINK         @"eqbang://coupon_list"
/**链接跳商城 */
#define EBEANLINK          @"eqbang://ebean"
/**跳分类 */
#define CATEGORY           @"eqbang://category"
/**跳订单结算页面 */
#define SECKILL            @"eqbang://seckill"
/**跳转首页 */
#define HOME                @"eqbang://home"
/**跳转购物车 */
#define CART                @"eqbang://cart"
/**进入结算页面 */
#define SETTLEMENT        @"eqbang://settlement"
/**进入商品详情 */
#define GOODS               @"eqbang://goods"
/**进入邀请界面 */
#define INVITE             @"eqbang://invite"
/**商家家取消订单的弹窗提示 */
#define SHOPCANCELALERT   @"shopCancelAlert"

/** 清纯水饮分类下位置1的点击 */
#define Cat_Water_Pos1        @"Cat_Water_Pos1"
/** 清纯水饮分类下位置2的点击 */
#define Cat_Water_Pos2        @"Cat_Water_Pos2"
/** 清纯水饮分类下位置3的点击 */
#define Cat_Water_Pos3        @"Cat_Water_Pos3"
/** 清纯水饮分类下所有商品的累计点击量 */
#define Cat_Water_SKUClik     @"Cat_Water_SKUClik"
/** 清纯水饮分类下所有商品的加号累计点击量 */
#define Cat_Water_AddClik     @"Cat_Water_AddClik"

/** 粮油调味分类下位置1的点击 */
#define Cat_GrainOil_Pos1     @"Cat_GrainOil_Pos1"
/** 粮油调味分类下位置2的点击 */
#define Cat_GrainOil_Pos2     @"Cat_GrainOil_Pos2"
/** 粮油调味分类下位置3的点击 */
#define Cat_GrainOil_Pos3     @"Cat_GrainOil_Pos3"
/** 粮油调味分类下所有商品的累计点击量 */
#define Cat_GrainOil_SKUClik  @"Cat_GrainOil_SKUClik"
/** 粮油调味分类下所有商品的加号累计点击量 */
#define Cat_GrainOil_AddClik  @"Cat_GrainOil_AddClik"

/** 洗护日用分类下位置1的点击 */
#define Cat_WashProt_Pos1     @"Cat_WashProt_Pos1"
/** 洗护日用分类下位置2的点击 */
#define Cat_WashProt_Pos2     @"Cat_WashProt_Pos2"
/** 洗护日用分类下位置3的点击 */
#define Cat_WashProt_Pos3     @"Cat_WashProt_Pos3"
/** 洗护日用分类下所有商品的累计点击量 */
#define Cat_WashProt_SKUClik  @"Cat_WashProt_SKUClik"
/** 洗护日用分类下所有商品的加号累计点击量 */
#define Cat_WashProt_AddClik  @"Cat_WashProt_AddClik"

/** 牛奶咖啡分类下位置1的点击 */
#define Cat_MilkCoff_Pos1     @"Cat_MilkCoff_Pos1"
/** 牛奶咖啡分类下位置2的点击 */
#define Cat_MilkCoff_Pos2     @"Cat_MilkCoff_Pos2"
/** 牛奶咖啡分类下位置3的点击 */
#define Cat_MilkCoff_Pos3     @"Cat_MilkCoff_Pos3"
/** 牛奶咖啡分类下所有商品的累计点击量 */
#define Cat_MilkCoff_SKUClik  @"Cat_MilkCoff_SKUClik"
/** 牛奶咖啡分类下所有商品的加号累计点击量 */
#define Cat_MilkCoff_AddClik  @"Cat_MilkCoff_AddClik"

/** 酣畅酒饮分类下位置1的点击 */
#define Cat_Wine_Pos1         @"Cat_Wine_Pos1"
/** 酣畅酒饮分类下位置2的点击 */
#define Cat_Wine_Pos2         @"Cat_Wine_Pos2"
/** 酣畅酒饮分类下位置3的点击 */
#define Cat_Wine_Pos3         @"Cat_Wine_Pos3"
/** 酣畅酒饮分类下所有商品的累计点击量 */
#define Cat_Wine_SKUClik      @"Cat_Wine_SKUClik"
/** 酣畅酒饮分类下所有商品的加号累计点击量 */
#define Cat_Wine_AddClik      @"Cat_Wine_AddClik"

/** 闲暇小食分类下位置1的点击 */
#define Cat_Snacks_Pos1       @"Cat_Snacks_Pos1"
/** 闲暇小食类下位置2的点击 */
#define Cat_Snacks_Pos2       @"Cat_Snacks_Pos2"
/** 闲暇小食分类下位置3的点击 */
#define Cat_Snacks_Pos3       @"Cat_Snacks_Pos3"
/** 闲暇小食分类下所有商品的累计点击量 */
#define Cat_Snacks_SKUClik    @"Cat_Snacks_SKUClik"
/** 闲暇小食分类下所有商品的加号累计点击量 */
#define Cat_Snacks_AddClik    @"Cat_Snacks_AddClik"

/** 饼干速食分类下位置1的点击 */
#define Cat_Cookie_Pos1       @"Cat_Cookie_Pos1"
/** 饼干速食类下位置2的点击 */
#define Cat_Cookie_Pos2       @"Cat_Cookie_Pos2"
/** 饼干速食分类下位置3的点击 */
#define Cat_Cookie_Pos3       @"Cat_Cookie_Pos3"
/** 饼干速食分类下所有商品的累计点击量 */
#define Cat_Cookie_SKUClik    @"Cat_Cookie_SKUClik"
/** 饼干速食分类下所有商品的加号累计点击量 */
#define Cat_Cookie_AddClik    @"Cat_Cookie_AddClik"

/** 缤纷酷饮分类下位置1的点击 */
#define Cat_Drinks_Pos1  @"Cat_Drinks_Pos1"
/** 缤纷酷饮食类下位置2的点击 */
#define Cat_Drinks_Pos2  @"Cat_Drinks_Pos2"
/** 缤纷酷饮分类下位置3的点击 */
#define Cat_Drinks_Pos3  @"Cat_Drinks_Pos3"
/** 缤纷酷饮分类下所有商品的累计点击量 */
#define Cat_Drinks_SKUClik  @"Cat_Drinks_SKUClik"
/** 缤纷酷饮分类下所有商品的加号累计点击量 */
#define Cat_Drinks_AddClik  @"Cat_Drinks_AddClik"

/** 代买香烟分类下位置1的点击 */
#define Cat_Cigaret_Pos1  @"Cat_Cigaret_Pos1"
/** 代买香烟食类下位置2的点击 */
#define Cat_Cigaret_Pos2  @"Cat_Cigaret_Pos2"
/** 代买香烟分类下位置3的点击 */
#define Cat_Cigaret_Pos3  @"Cat_Cigaret_Pos3"
/** 代买香烟分类下所有商品的累计点击量 */
#define Cat_Cigaret_SKUClik  @"Cat_Cigaret_SKUClik"
/** 代买香烟分类下所有商品的加号累计点击量 */
#define Cat_Cigaret_AddClik  @"Cat_Cigaret_AddClik"

/** 商品详情页关联商品1 */
#define Commodity_Detail_C1  @"Commodity_Detail_C1"
/** 商品详情页关联商品2 */
#define Commodity_Detail_C2  @"Commodity_Detail_C2"

//商户
/**商户查看订单页面 （首页）*/
#define MyOrder           @"MyOrder"
/**商户确认抢单 */
#define Cfm_GetOrder      @"Cfm_GetOrder"
/**商户联系顾客 */
#define Contact_Customer   @"Contact_Customer"
/** 商户取消订单*/
#define CancelbyStore      @"CancelbyStore"
/**商户查看余额 */
#define Query_Balance      @"Query_Balance"
/** 商户查看余额*/
#define Clik_GetCash      @"Clik_GetCash"
/** 确认提现*/
#define Cfm_GetCash       @"Cfm_GetCash"
/** 新订单推送开*/
#define NO_PushSwitch_On   @"NO_PushSwitch_On"
/** 新订单推送关*/
#define NO_PushSwitch_Off  @"NO_PushSwitch_Off"
/**商户点击切换接单距离按钮 */
#define Swtich_Distance    @"Swtich_Distance"

//顾客
/** 点击e豆*/
#define Query_eBean       @"Query_eBean"
/**进入用户账户信息页 */
#define Edit_AcctInfo     @"Edit_AcctInfo"
/** 账户信息保存*/
#define Save_AccInfo      @"Save_AccInfo"
/**点击我的消息 */
#define Clik_Msg          @"Clik_Msg"
/**点击订单消息 */
#define Order_Msg         @"Order_Msg"
/** 点击系统消息*/
#define System_Msg        @"System_Msg"
/** 点击系统消息*/
#define eBean_Msg         @"eBean_Msg"
/** 点击系统消息*/
#define Coupon_Msg        @"Coupon_Msg"
/** 点击我的优惠券*/
#define Query_MyCoupon    @"Query_MyCoupon"
/** 商品详情页右下角选好了 */
#define SelectedOK        @"SelectedOK"
/** 再来一单*/
#define OneOrder_Again    @"OneOrder_Again"
/**确认收货 */
#define Cfm_Receiving     @"Cfm_Receiving"
/**用户催单 */
#define Reminder          @"Reminder"
/** 用户取消订单*/
#define Cancel_byUser     @"Cancel_byUser"
/** 点击进入用户评价商家*/
#define Comment_byUser    @"Comment_byUser"
/**用户确认评价 */
#define Confirm_Comment   @"Confirm_Comment"
/**用户发红包（非详情页） */
#define RedPackets        @"RedPackets"
/** 点击首页*/
#define Clik_MainPage     @"Clik_MainPage"
/** 点击分类*/
#define Clik_Category     @"Clik_Category"
/** 点击扫一扫*/
#define Clik_Scan         @"Clik_Scan"
/** 点击切换地址*/
#define Clik_SwitchAddr   @"Clik_SwitchAddr"
/** 点击助手*/
#define Clik_OrderAssit   @"Clik_OrderAssit"
/** 点击首页头像*/
#define Clik_User         @"Clik_User"
/** 切换城市*/
#define City_Switch       @"City_Switch"
/** 点击轮播图1*/
#define Clik_Banner1      @"Clik_Banner1"
/** 点击轮播图2*/
#define Clik_Banner2      @"Clik_Banner2"
/** 点击轮播图3*/
#define Clik_Banner3      @"Clik_Banner3"
/** 点击轮播图3*/
#define Clik_Banner4      @"Clik_Banner4"
/** 点击轮播图3*/
#define Clik_Banner5      @"Clik_Banner5"
/** 点击轮播图6*/
#define Clik_Banner6      @"Clik_Banner6"
/** 点击广告位1*/
#define Clik_AD1          @"Clik_AD1"
/** 点击广告位2*/
#define Clik_AD2          @"Clik_AD2"
/** 点击广告位3*/
#define Clik_AD3          @"Clik_AD3"
/** 点击广告位4*/
#define Clik_AD4          @"Clik_AD4"
/** 点击广告位5*/
#define Clik_AD5          @"Clik_AD5"
/** 点击广告位6*/
#define Clik_AD6          @"Clik_AD6"
/** 点击腰部广告1*/
#define Clik_MBanner1     @"Clik_MBanner1"
/** 点击腰部广告2*/
#define Clik_MBanner2     @"Clik_MBanner2"
/** 点击腰部广告3*/
#define Clik_MBanner3     @"Clik_MBanner3"
/** 首页分类1*/
#define Category1_inMP    @"Category1_inMP"
/** 首页分类2*/
#define Category2_inMP    @"Category2_inMP"
/** 首页分类3*/
#define Category3_inMP    @"Category3_inMP"
/** 更多分类*/
#define Category4_inMP     @"Category4_inMP"
/** 更多分类*/
#define Search            @"Search"
/** 首页点击+*/
#define Add_inMainPage    @"Add_inMainPage"
/** 首页点击-*/
#define Minus_inMainPage  @"Minus_inMainPage"
/**商品详情页点击+*/
#define Add_inDetailPage  @"Add_inDetailPage"

/** 点击首页顶部浮动订单状态提示条*/
#define Clik_MP_OrderStatus @"Clik_MP_OrderStatus"
/** 关闭首页顶部浮动订单状态提示条*/
#define Clos_MP_OrderStatus    @"Clos_MP_OrderStatus"
/** 点击首页分类1中商品1*/
#define Clik_MPCat1_Com1  @"Clik_MPCat1_Com1"
/**点击首页分类1中商品2*/
#define Clik_MPCat1_Com2  @"Clik_MPCat1_Com2"
/** 点击首页分类1中商品3*/
#define Clik_MPCat1_Com3  @"Clik_MPCat1_Com3"
/** 点击首页分类1中商品4*/
#define Clik_MPCat1_Com4  @"Clik_MPCat1_Com4"
/** 点击首页分类1中商品5*/
#define Clik_MPCat1_Com5  @"Clik_MPCat1_Com5"

/** 点击首页分类2中商品1*/
#define Clik_MPCat2_Com1  @"Clik_MPCat2_Com1"
/**点击首页分类2中商品2*/
#define Clik_MPCat2_Com2  @"Clik_MPCat2_Com2"
/** 点击首页分类2中商品3*/
#define Clik_MPCat2_Com3  @"Clik_MPCat2_Com3"
/** 点击首页分类2中商品4*/
#define Clik_MPCat2_Com4  @"Clik_MPCat2_Com4"
/** 点击首页分类2中商品5*/
#define Clik_MPCat2_Com5  @"Clik_MPCat2_Com5"

/** 点击首页分类3中商品1*/
#define Clik_MPCat3_Com1  @"Clik_MPCat3_Com1"
/**点击首页分类3中商品2*/
#define Clik_MPCat3_Com2  @"Clik_MPCat3_Com2"
/** 点击首页分类3中商品3*/
#define Clik_MPCat3_Com3  @"Clik_MPCat3_Com3"
/** 点击首页分类3中商品4*/
#define Clik_MPCat3_Com4  @"Clik_MPCat3_Com4"
/** 点击首页分类3中商品5*/
#define Clik_MPCat3_Com5  @"Clik_MPCat3_Com5"

/** 点击首页分类4中商品1*/
#define Clik_MPCat4_Com1  @"Clik_MPCat4_Com1"
/**点击首页分类4中商品2*/
#define Clik_MPCat4_Com2  @"Clik_MPCat4_Com2"
/** 点击首页分类4中商品3*/
#define Clik_MPCat4_Com3  @"Clik_MPCat4_Com3"
/** 点击首页分类4中商品4*/
#define Clik_MPCat4_Com4  @"Clik_MPCat4_Com4"
/** 点击首页分类4中商品5*/
#define Clik_MPCat4_Com5  @"Clik_MPCat4_Com5"

/** 点击首页分类5中商品1*/
#define Clik_MPCat5_Com1  @"Clik_MPCat5_Com1"
/**点击首页分类5中商品2*/
#define Clik_MPCat5_Com2  @"Clik_MPCat5_Com2"
/** 点击首页分类5中商品3*/
#define Clik_MPCat5_Com3  @"Clik_MPCat5_Com3"
/** 点击首页分类5中商品4*/
#define Clik_MPCat5_Com4  @"Clik_MPCat5_Com4"
/** 点击首页分类5中商品5*/
#define Clik_MPCat5_Com5  @"Clik_MPCat5_Com5"


