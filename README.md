# Jongdari (云雀)

<p align="center">
  <a href="https://github.com/spirit-jsb/Jongdari"><img src="https://img.shields.io/github/v/release/spirit-jsb/Jongdari?display_name=tag"/></a>
  <a href="https://swift.org/package-manager/"><img src="https://img.shields.io/badge/SPM-compatible-orange"></a> 
  <a href="https://github.com/spirit-jsb/Jongdari/blob/master/LICENSE"><img src="https://img.shields.io/github/license/spirit-jsb/Jongdari"/></a>
  <a href="https://github.com/spirit-jsb/Jongdari"><img src="https://img.shields.io/cocoapods/p/ios"/></a>
</p>

<p align="center">
<img src="https://raw.githubusercontent.com/spirit-jsb/Jongdari/main/images/open-drawer-from-left-using-default-animation.gif" height="358"/>
<img src="https://raw.githubusercontent.com/spirit-jsb/Jongdari/main/images/open-drawer-from-left-using-zoom-animation.gif" height="358"/>
<img src="https://raw.githubusercontent.com/spirit-jsb/Jongdari/main/images/open-drawer-from-left-using-mask-animation.gif" height="358"/>
<img src="https://raw.githubusercontent.com/spirit-jsb/Jongdari/main/images/open-drawer-from-right-using-default-animation.gif" height="358"/>
<img src="https://raw.githubusercontent.com/spirit-jsb/Jongdari/main/images/open-drawer-from-right-using-zoom-animation.gif" height="358"/>
<img src="https://raw.githubusercontent.com/spirit-jsb/Jongdari/main/images/open-drawer-from-right-using-mask-animation.gif" height="358"/>
<img src="https://raw.githubusercontent.com/spirit-jsb/Jongdari/main/images/register-open-drawer-gesture.gif" height="358"/>
</p>

`Jongdari` 是一个自定义抽屉效果转场动画框架。

## 基本属性及方法

### AnimationConfiguration 属性
* direction
* animationType
* openDuration
* closeDuration
* distanceMultiplier
* maximumDraggingPercent
* scaleFactor
* maskOpacity

### UIViewController 拓展方法
* open(_:animationConfigurationBuilder:)
* registerOpenDrawerGesture(_:maximumDraggingPercent:transitionHandler:)
* pushViewControllerFromDrawer(_:animated:)
* presentFromDrawer(_:animated:closeDrawer:completion:)

## 使用方法
```swift
let viewController = UIViewController()

self.vm.open(viewController) { (animationConfiguration) in
    /// update animation configuration
    
    return animationConfiguration
}

self.vm.registerOpenDrawerGesture(.edge) { (direction) in
    switch direction {
    case .left:
        /// do somethings
    case .right:
        /// do somethings
    }
}

self.vm.presentFromDrawer(viewController, animated: true, closeDrawer: true, completion: nil)

self.vm.pushViewControllerFromDrawer(viewController, animated: true)
```

## 限制条件
- iOS 10.0+
- Swift 5.0+    

## 安装

### **Swift Package Manager**
```
https://github.com/spirit-jsb/Jongdari.git
```

## 作者
spirit-jsb, sibo_jian_29903549@163.com

## 许可文件
`Jongdari` 可在 `MIT` 许可下使用，更多详情请参阅许可文件。