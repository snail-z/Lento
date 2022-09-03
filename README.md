# DownJacketSearchBar
* 仿微信多选页面的搜索条样式，多张可以滚动，并可以利
用系统删除键删掉选择的头像
* 导入方法:
    * 方法一：[CocoaPods][1]：pod 'DownJacketSearchBar', '~> 1.0.8'
    * 方法二：直接把 DownJacketSearchBar 文件夹（在 Demo 中）拖拽到你的项目中

* Example:
 *            1. 初始化不设置frame

 ``` objc
      DownJacketSearchBar *searchBar = [[DownJacketSearchBar alloc] init]; 
      searchBar.delegate = self;
      searchBar.placeholder = @"搜索";
      searchBar.presetImage = [UIImage imageNamed:@"downJacket_search"];
      searchBar.leftPadding = 10;
      searchBar.textInsetLeft = 15;
      [self.view addSubview:searchBar];
 ```
     
 *            2. 通过DownJackets来设置一个实例，并进行增删
 
 ``` objctextF
      - (void)addDownJackets:(DownJackets *)downJackets
      - (void)removeDownJackets:(DownJackets *)downJackets
 ```
 *            3. 更多详细使用方法请参见Demo

##### 最新完善：修改当删除textfield最后一个字符时会选中item的问题，增加简单的动画，增加属性textInsetLeft可设置textfield的文本内边距等
 
 ``` objc
- (void)downJacketdeleteBackward {
    if ([self.delegate respondsToSelector:@selector(textFieldDidDeleteBackward:)]) {
        id <DownJacketTextFieldDelegate> delegate  = (id<DownJacketTextFieldDelegate>)self.delegate;
        [delegate textFieldDidDeleteBackward:self];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:DownJacketTextFieldDidDeleteBackwardNotification object:self];
    /**
     1. 交换方法:runtime
     method_exchangeImplementations(deleteBackward, downJacketdeleteBackward);
     也就是外部调用downJacketdeleteBackward就相当于调用了deleteBackward，调用deleteBackward就相当于调用了downJacketdeleteBackward
     2. 此时调用的方法 'downJacketdeleteBackward' 相当于调用系统的 'deleteBackward' 方法,原因是在load方法中进行了方法交换.
     3. 此处并没有递归操作
     4. 在执行自定义方法'downJacketdeleteBackward'之后再去调用'deleteBackward'，可以防止多余删除操作！（可根据实际情况处理调用的先后顺序）
     */
    // Method Swizzling <http://nshipster.cn/method-swizzling/>
    [self downJacketdeleteBackward];
}
```

[1]: https://cocoapods.org "CocoaPods" 
