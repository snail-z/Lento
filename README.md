# DownJacketSearchBar
* 仿微信多选页面的搜索条样式，多张可以滚动，并可以利用系统删除键删掉选择的头像
* 导入方法:
    * 方法一：[CocoaPods][1]：pod 'DownJacketSearchBar', '~> 0.0.1'
    * 方法二：直接把 DownJacketSearchBar 文件夹（在 Demo 中）拖拽到你的项目中

* example:
    * 初始化不设置frame，默认高度50
    
      ```object-c
      
      DownJacketSearchBar *searchBar = [DownJacketSearchBar new];
      searchBar.delegate = self;
      searchBar.placeholder = @" 搜索昵称/姓名";
      searchBar.leftImage = [UIImage imageNamed:@"downJacket_search"];;
      [self.view addSubview:searchBar];
      
      ```
   



[1]: https://cocoapods.org "CocoaPods" 
