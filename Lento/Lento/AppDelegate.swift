//
//  AppDelegate.swift
//  Lento
//
//  Created by corgi on 2022/7/4.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let tabbarVC = LentoBaseTabBarController()
        window?.rootViewController = tabbarVC
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func configTabbarController() {
        
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


/*
 高中数学
 
 必修第一册
 第一章 集合与常用逻辑用语
 1.1集合的概念
 1.2集合间的基本关系
 1.3集合的基本运算
 1.4充分条件与必要条件
 1.5全称量词与存在量词
 第二章 一元二次函数、方程和不等式
 2.1等式性质与不等式性质
 2.2基本不等式
 2.3二次函数与一元二次方程、不等式
 第三章 函数概念与性质
 3.1函数的概念及其表示
 3.2函数的基本性质
 3.3幂函数
 3.4函数的应用（一）
 第四章 指数函数与对数函数
 4.1指数
 4.2指数函数
 4.3对数
 4.4对数函数
 4.5函数的应用（二）
 第五章 三角函数
 5.1任意角和弧度制
 5.2三角函数的概念
 5.3诱导公式
 5.4三角函数的图像与性质
 5.5三角恒等变换
 5.6函数y=Asin(wx+)的图像与性质
 5.7三角函数的应用

 必修第二册
 第六章 平面向量及其应用
 6.1平面向量的概念
 6.2平面向量的运算
 6.3平面向量基本定理及坐标表示
 6.4平面向量的应用
 第七章、复数
 7.1复数的概念
 7.2复数的四则运算
 7.3复数的三角表示
 第八章 立体几何初步
 8.1简单的立体图形
 8.2立体图形的直观图
 8.3简单几何体的表面积与体积
 8.4空间点、直线、平面之间的位置关系
 8.5空间直线、平面的平行
 8.6空间直线、平面的垂直
 第九章 统计
 9.1随机抽样
 9.2用样本估计总体
 9.3统计分析案例 公司员工的肥胖情况调查分析
 
 选择性必修第一册
 第一章 空间向量与立体几何
 1.1空间向量及其运算
 1.2空间向量基本定理
 1.3空间向量及其运算的坐标表示
 1.4空间向量的应用
 第二章 直线和圆的方程
 2.1直线的倾斜角与斜率
 2.2直线的方程
 2.3直线的交点坐标与距离公式
 2.4圆的方程
 2.5直线与圆、圆与圆的位置关系
 第三章 圆锥直线的方程
 3.1椭圆
 3.2抛物线
 3.3双曲线
 
 选择性必修第二册
 第四章 数列
 4.1数列的概念
 4.2等差数列
 4.3等比数列
 4.4数学归纳法
 第五章 一元函数的导数及其应用
 5.1导数的概念及其意义
 5.2导数的运算
 5.3导数在研究函数中的应用
 
 选择性必修第三册
 第六章 计数原理
 6.1分类加法计数原理与分步乘法计数原理
 6.2排列与组合
 6.3二项式定理
 数学探究
 杨辉三角的性质与应用
 第七章 随机变量及其分布
 7.1条件概率与全概率公式
 7.2离散型随机变量及其分布列
 7.3离散型随机变量的数字特征
 7.4二项分布与超几何分布
 7.5正态分布
 第八章 成对数据的统计分析
 8.1成对数据的相关关系
 8.2一元线性回归模型及其应用
 8.3分类变量与列联表
 数学建模
 建立统计模型进行预测
 */
