# DownJacketSearchBar
* 仿微信多选页面的搜索条样式，多张可以滚动，并可以利用系统删除键删掉选择的头像
* 导入方法:
    * 方法一：[CocoaPods][1]：pod 'DownJacketSearchBar'
    * 方法二：直接把 DownJacketSearchBar 文件夹（在 Demo 中）拖拽到你的项目中

* Example:
 *            1. 初始化不设置frame，默认50

 ``` objc
      DownJacketSearchBar *searchBar = [[DownJacketSearchBar alloc] init]; 
      searchBar.delegate = self;
      searchBar.placeholder = @" 搜索昵称/姓名";
      searchBar.leftImage = [UIImage imageNamed:@"downJacket_search"];;
      [self.view addSubview:searchBar];
 ```
     
 *            2. 通过DownJackets来设置一个实例，并进行增删
 
 ``` objc
      - (void)addDownJackets:(DownJackets *)downJackets
      - (void)removeDownJackets:(DownJackets *)downJackets
 ```
 *            3. 更多详细使用方法请参见Demo
    
* TODO list:
 *            1. 给textfield加上contentInset
 *            2. 使用autolayout适配布局
 *            3. 取消选中时的scoll动画
 *            4. 增加标题并根据文字长度来显示
 *            5. 当删除textfield最后一个字符时会选中item


[1]: https://cocoapods.org "CocoaPods" 
