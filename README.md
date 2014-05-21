DaiNavigationTransition
=======================

Idea from <a href="http://nonomori.farbox.com/post/ios-7-jiao-hu-shi-guo-du">http://nonomori.farbox.com/post/ios-7-jiao-hu-shi-guo-du</a>, and convert this transition effect more easier to use.

![image](https://s3-ap-northeast-1.amazonaws.com/daidoujiminecraft/Daidouji/001.gif)
![image](https://s3-ap-northeast-1.amazonaws.com/daidoujiminecraft/Daidouji/DaiNavigationTransition20140516.gif)

DaidoujiChen

daidoujichen@gmail.com

總覽
=======================
這個想法起源于上面的那個網站, 但是如大家所見的, 網站中實現的方法需要額外的添加許多東西, 實作起來並不是這麼的直覺, 因此將這個想法轉化為較為簡單的實現方式, 總之也是懶惰下的成果.

支援
=======================
- ARC only
- ios6 / ios7 (io6 要繞好遠...才可以做到跟 7 一樣的效果)

簡易使用
=======================
ok, 非常的簡單, 首先

    #import "UINavigationController+Transition.h"
    
將這個檔案 import 到你想使用這個效果的地方, 然後, push view 時改變為 call

    [self.navigationController pushViewController:[SecondViewController new]
                                         fromView:^UIView *(UIViewController *viewcontroller) {
                                             MainViewController *main = (MainViewController*) viewcontroller;
                                             DefaultTableViewCell *cell = (DefaultTableViewCell*) [main.demoTableView cellForRowAtIndexPath:[main.demoTableView indexPathForSelectedRow]];
                                             return cell.redView;
                                         }
                                           toView:^UIView *(UIViewController *viewcontroller) {
                                               SecondViewController *second = (SecondViewController*) viewcontroller;
                                               return second.redView;
                                           }];
                                           
其中, fromView 為原先從哪個 view 開始, toView 為切換至下一個 controller 之後會變成哪個 view, 就這樣.
