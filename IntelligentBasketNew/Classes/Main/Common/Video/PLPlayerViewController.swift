//
//  PLPLayerViewController.swift
//  IntelligentBasket
//
//  Created by 卢卓桓 on 2019/8/24.
//  Copyright © 2019 zhineng. All rights reserved.
//

import UIKit
import PLPlayerKit


class PLPlayerViewController: BaseViewController {
    
    // MARK: - 自定义属性
    var player: PLPlayer?
    var isDisapper = false
    private var playUrl: String? {
        didSet{
            if playUrl != oldValue {
                guard let player = player else { return }
                stop()
                setPlayer()
                player.play()
            }
        }
    }
    
    // MARK: - 懒加载属性
    private lazy var playBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.isHidden = true
        btn.setImage(UIImage(named: "play"), for: .normal)
        btn.addTarget(self, action: #selector(playBtnClick), for: .touchUpInside)
        btn.sizeToFit()
        return btn
    }()
    
    private lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "close"), for: .normal)
        btn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        btn.backgroundColor = UIColor(white: 0, alpha: 0.5)
        btn.layer.cornerRadius = 22
        btn.sizeToFit()
        return btn
    }()
    
    private lazy var singleTap: UITapGestureRecognizer = {
        let singleTab = UITapGestureRecognizer(target: self, action: #selector(singleTapAction))
        return singleTab
    }()
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setPlayer()
    }
    
    ///视图将要出现的时候调用
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    ///视图将要消失的时候
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    ///视图已经消失
    override func viewDidDisappear(_ animated: Bool) {
        isDisapper = true
        stop()
        super.viewDidDisappear(animated)
    }
    
    ///视图已经出现
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isDisapper = false
        guard let player = player else {
            return
        }
        if !player.isPlaying{
            player.play()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    init(playUrl: String?) {
        super.init(nibName: nil, bundle: nil)
        self.playUrl = playUrl
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 重写父类方法
    override func setUI() {
        /// 设置背景颜色
        view.backgroundColor = UIColor.white
        
        /// 加入单击屏幕手势
        view.addGestureRecognizer(singleTap)
    }
}

// MARK: - 设置player
extension PLPlayerViewController {
    
    private func setPlayer(){
        
        let option = PLPlayerOption.default()
        option.setOptionValue(15, forKey: PLPlayerOptionKeyTimeoutIntervalForMediaPackets)
        
        /// 初始化 PLPlayer
        guard let urlStr = playUrl else {
            view.showTip(tip: "百胜吊篮：视频地址无效！", position: .bottomCenter)
            return
        }
        let url = URL(string: urlStr)
        player = PLPlayer.init(url: url, option: option)
        player?.delegate = self
        player?.isBackgroundPlayEnable = true  //进入后台是否继续播放
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)//不知道干嘛
        
        /// 获取视频输出视图并添加为到当前 UIView 对象的 Subview
        view.addSubview((player?.playerView)!)
        player?.playerView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        /// 回调方法的调用队列
        player?.delegateQueue = DispatchQueue.main
        
        /// 设置内容缩放以适应固定方面。 余数是透明的（默认是填满整个画面）
        player?.playerView?.contentMode = UIView.ContentMode.scaleAspectFit
        
        player?.playerView?.addSubview(playBtn)
        playBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        player?.playerView?.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.bottom.right.equalToSuperview().offset(-10)
            make.height.width.equalTo(44)
        }
    }
}

// MARK: - player的代理方法
extension PLPlayerViewController: PLPlayerDelegate{
    
    /// 告知代理对象 PLPlayer 即将开始进入后台播放任务
    func playerWillBeginBackgroundTask(_ player: PLPlayer) {
        player.pause()
    }
    
    /// 告知代理对象 PLPlayer 即将结束后台播放状态任务
    func playerWillEndBackgroundTask(_ player: PLPlayer) {
        player.resume()
    }
    
    /// 播放状态回调
    func player(_ player: PLPlayer, statusDidChange state: PLPlayerStatus) {
        // TODO: 不同的播放状态下可以设置不同的UI等等
        if isDisapper{
            stop()
            hideWaiting()
            return
        }
        
        if state == PLPlayerStatus.statusPlaying ||
            state == PLPlayerStatus.statusPaused ||
            state == PLPlayerStatus.statusStopped ||
            state == PLPlayerStatus.statusError ||
            state == PLPlayerStatus.statusUnknow ||
            state == PLPlayerStatus.statusCompleted{
            
            hideWaiting()
            
        }else if state == PLPlayerStatus.statusPreparing ||
            state == PLPlayerStatus.statusReady ||
            state == PLPlayerStatus.statusCaching ||
            state == PLPlayerStatus.stateAutoReconnecting{
            
            showWaiting()
        }
    }
    
    /// 播放错误回调
    func player(_ player: PLPlayer, stoppedWithError error: Error?) {
        // TODO: 错误：尝试重连，失败需给出信息
        hideWaiting()
        view.showTip(tip: "百胜吊篮：连接失败！", position: .bottomCenter)
    }
    
    /// 回调将要渲染的帧数据
    func player(_ player: PLPlayer, willRenderFrame frame: CVPixelBuffer?, pts: Int64, sarNumerator: Int32, sarDenominator: Int32) {
        DispatchQueue.main.async {
            if !UIApplication.shared.isIdleTimerDisabled{
                UIApplication.shared.isIdleTimerDisabled = true  //设置屏幕常亮
            }
        }
    }
    
    /// 回调音频数据
    func player(_ player: PLPlayer, willAudioRenderBuffer audioBufferList: UnsafeMutablePointer<AudioBufferList>, asbd audioStreamDescription: AudioStreamBasicDescription, pts: Int64, sampleFormat: PLPlayerAVSampleFormat) -> UnsafeMutablePointer<AudioBufferList> {
        return audioBufferList
    }
    
    /// 第一帧出现时
    func player(_ player: PLPlayer, firstRender firstRenderType: PLPlayerFirstRenderType) {
        //thumbImageView.isHidden = true
    }
    
}


// MARK: - 事件监听函数
extension PLPlayerViewController{
    
    @objc private func playBtnClick(){
        guard let player = player else { return }
        player.resume()
    }
    
    @objc private func closeBtnClick(){
        dismiss(animated: false, completion: nil)
    }
    
    @objc private func singleTapAction(){
        guard let player = player else { return }
        if player.isPlaying {
            player.pause()
        }else{
            player.resume()
        }
    }
}


// MARK: - 其它控制函数
extension PLPlayerViewController{
    private func stop(){
        UIApplication.shared.isIdleTimerDisabled = false  //屏幕不常亮
        player?.stop()
    }
    
    private func showWaiting(){
        playBtn.isHidden = true
        guard let view = player?.playerView else { return }
        view.showFullLoading()
        view.bringSubviewToFront(closeBtn)
    }
    
    private func hideWaiting(){
        view.hideFullLoading()
        if player?.status != PLPlayerStatus.statusPlaying {
            playBtn.isHidden = false
            player?.playerView?.bringSubviewToFront(playBtn)
        }
    }
}
