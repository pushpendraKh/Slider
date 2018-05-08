//
//  ViewController.swift
//  SliderDemo
//
//  Created by Pushpendra Khandelwal on 09/05/18.
//  Copyright © 2018 Pushpendra Khandelwal. All rights reserved.
//

import UIKit

import UIKit

class ViewController: UIViewController {
    
    private let step: Float = 10
    @IBOutlet weak var slider: UISlider! {
        didSet {
            slider.addTarget(self, action: #selector(didValueChange), for: .valueChanged)
        }
    }
    
    @IBOutlet weak var outputLabel: UILabel!
    
    // MARK: -PROPERTIES OF BOTTOM LABEL W.R.T. Slider
    var stepY: CGFloat = 30
    var stepWidth: CGFloat = 10
    var stepHeight: CGFloat = 10
    var stepFont: UIFont = UIFont.systemFont(ofSize: 10)
    
    // MARK: -PROPERTIES OF step DESCRIPTION LABEL W.R.T. step
    var descriptionY: CGFloat = 10
    var descriptionX: CGFloat = 20
    var descriptionWidth: CGFloat = 50
    var descriptionHeight: CGFloat = 30
    var descriptionFont: UIFont = UIFont.systemFont(ofSize: 10)
    
    // MARK: - PROPERTIES OF INDICATOR VIEW W.R.T. SLIDER
    lazy var indicator: UILabel! = {
        let umbrellaLabel = UILabel()
        umbrellaLabel.text = "☂️"
        umbrellaLabel.textAlignment = .center
        return umbrellaLabel
    }()
    
    var indicatorY: CGFloat = 30
    
    // MARK: - PROPERTIES OF SLIDER
    var thumbWidth: CGFloat = 31
    lazy var sliderModel: SliderModel = {
        let model = SliderModel.init(minimum: 50,
                                     maximum: 5000,
                                     discretePoint: [50,1000,2500,4000,5000],
                                     steps: 10,
                                     defualtValue: 2500)
        return model
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSlider()
        addIndicatorView()
        setDefaultValue()
    }
    
    private func setupSlider() {
        slider.minimumValue = sliderModel.minimum
        slider.maximumValue = sliderModel.maximum
        createDiscretePoints(with: sliderModel.discretePoint)
    }
    
    func createDiscretePoints(with discretePoint: [Float]) {
        view.layoutIfNeeded()
        discretePoint.forEach { [unowned self] in
            self.setLabelForValue(Float($0))
        }
    }
    
    private func addIndicatorView() {
        view.addSubview(indicator)
    }
    
    private func setDefaultValue() {
        slider.value = sliderModel.defualtValue
        updateTopView()
    }
    
    private func setLabelForValue(_ value: Float) {
        self.slider.value = value
        createStepLabel()
    }
    
    private func createStepLabel() {
        let stepX = CGFloat(xPositionFromSliderValue())
        let yPos = stepY + self.slider.frame.origin.y
        
        let frame = CGRect.init(x: stepX,
                                y: yPos,
                                width: stepWidth,
                                height: stepHeight)
        
        let stepLabel = UILabel.init(frame: frame)
        stepLabel.font = stepFont
        stepLabel.text = "|"
        self.view.addSubview(stepLabel)
        
        let desFrame = CGRect.init(x: stepX - descriptionX,
                                   y: yPos + 10,
                                   width: descriptionWidth,
                                   height: descriptionHeight)
        createDesciptionLabel(desFrame)
        
    }
    
    private func createDesciptionLabel(_ frame: CGRect) {
        let descriptionLabel = UILabel.init(frame: frame)
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = descriptionFont
        descriptionLabel.text = sliderValueInString()
        self.view.addSubview(descriptionLabel)
    }
    
    func updateTopView() {
        let x = CGFloat(xPositionFromSliderValue()) - (thumbWidth / 2.0)
        let y = slider.frame.origin.y - indicatorY
        let indicatorFrame =  CGRect.init(x: x, y: y, width: thumbWidth, height: thumbWidth)
        indicator.frame = indicatorFrame
    }
    
    func xPositionFromSliderValue() -> Float {
        let sliderRange = slider.frame.size.width - thumbWidth;
        let sliderOrigin = slider.frame.origin.x + (thumbWidth / 2.0)
        
        let xPosFromSliderStart = (((slider.value - slider.minimumValue) / (slider.maximumValue - slider.minimumValue)) * Float(sliderRange)) + Float(sliderOrigin)
        return xPosFromSliderStart
    }
    
    // FIXME: - CHANGE IT
    private func sliderValueInString() -> String {
        return slider.value.description
    }
    
    @objc func didValueChange() {
        
        let roundedVal = round(slider.value / self.step) * self.step
        
        UIView.animate(withDuration: 0.10, animations: {
            self.slider.setValue(roundedVal, animated: true)
        }) { [unowned self] _ in
            self.updateTopView()
            self.outputLabel.text = roundedVal.description
        }
        
    }
}
