# iOS-SplashView
关于 SplashView 详细接受可以参考 Android 版: [SplashView-一行代码解决闪屏页-广告页-Android-篇](http://jkyeo.com/2016/07/10/SplashView-一行代码解决闪屏页-广告页-Android-篇/)

<!-- more -->

iOS 效果：

![Default Splash Demo](http://ww3.sinaimg.cn/large/006tNc79gw1f5p7bukwkhg30b00k0b29.gif) ![Normal Splash Demo](http://ww3.sinaimg.cn/large/006tNc79gw1f5p7bp26p0g30aw0k0hdw.gif)

显示 SplashView 静态方法:

```swift
class func simpleShowSplashView()
```

也可以自定义超时时间、默认 Image、回到 Block：

```swift
class func showSplashView(duration: Int = 6,
                              defaultImage: UIImage?,
                              tapSplashImageBlock: ((actionUrl: String?) -> Void)?,
                              splashViewDismissBlock: ((initiativeDismiss: Bool) -> Void)?)
```

<div class='tip'> 需要注意的是：以上两个方法都需要至少在 UIViewController 的 View 显示之后 (即: override func viewDidAppear(animated: Bool)) 再调用才能达到显示 SplashView 的效果。</div>

可以在任何地方更新 SplashView data:

```swift
class func updateSplashData(imgUrl: String?, actUrl: String?)
```

详情见博文：[SplashView - 一行代码解决闪屏页(广告页) - Android 篇](http://jkyeo.com/2016/07/10/SplashView-一行代码解决闪屏页-广告页-Android-篇/)
