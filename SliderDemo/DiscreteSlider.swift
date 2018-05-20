//
//  DiscreteSlider.swift
//  SliderDemo
//
//  Created by Pushpendra Khandelwal on 20/05/18.
//  Copyright © 2018 Pushpendra Khandelwal. All rights reserved.
//

import UIKit

class DiscreteSlider: UISlider {
    
    private let step: Float = 10
    
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
    
    var indicatorHeight: CGFloat = 30
    var sliderAnimationTime: TimeInterval = 0.10
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var intrinsicContentSize: CGSize {
        let height = stepY + stepHeight + descriptionY + descriptionHeight + thumbWidth
        return CGSize(width: bounds.width, height: height)
    }
    
    func setup() {
        addTarget(self, action: #selector(didValueChange), for: .valueChanged)
        setupSlider()
        addIndicatorView()
        
    }
    
    private func setDefaultValue() {
        value = sliderModel.defualtValue
        updateTopView()
    }
    
    private func setupSlider() {
        minimumValue = sliderModel.minimum
        maximumValue = sliderModel.maximum
        createDiscretePoints(with: sliderModel.discretePoint)
    }
    
    func createDiscretePoints(with discretePoint: [Float]) {
        layoutIfNeeded()
        discretePoint.forEach { [unowned self] in
            self.setLabelForValue(Float($0))
        }
        setDefaultValue()
    }
    
    private func addIndicatorView() {
        addSubview(indicator)
    }
    
    private func setLabelForValue(_ value: Float) {
        self.value = value
        createStepLabel()
    }
    
    private func createStepLabel() {
        let stepX = CGFloat(xPositionFromSliderValue())
        let yPosition: CGFloat = stepY + thumbWidth
        
        let frame = CGRect.init(x: stepX,
                                y: yPosition,
                                width: stepWidth,
                                height: stepHeight)
        
        let stepLabel = UILabel.init(frame: frame)
        stepLabel.font = stepFont
        stepLabel.text = "|"
        addSubview(stepLabel)
        
        let desFrame = CGRect.init(x: stepX - descriptionX,
                                   y: yPosition + descriptionY,
                                   width: descriptionWidth,
                                   height: descriptionHeight)
        createDesciptionLabel(desFrame)
        
    }
    
    private func createDesciptionLabel(_ frame: CGRect) {
        let descriptionLabel = UILabel.init(frame: frame)
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = descriptionFont
        descriptionLabel.text = sliderValueInString()
        addSubview(descriptionLabel)
    }
    
    func updateTopView() {
        let x = CGFloat(xPositionFromSliderValue()) - (thumbWidth / 2.0)
        let y = bounds.origin.y
        let indicatorFrame =  CGRect.init(x: x, y: y, width: thumbWidth, height: thumbWidth)
        indicator.frame = indicatorFrame
    }
    
    func xPositionFromSliderValue() -> Float {
        let sliderRange = frame.size.width - thumbWidth;
        let sliderOrigin = (thumbWidth / 2.0)
        
        let xPosFromSliderStart = (((value - minimumValue) / (maximumValue - minimumValue)) * Float(sliderRange)) + Float(sliderOrigin)
        return xPosFromSliderStart
    }
    
    // FIXME: - CHANGE IT
    private func sliderValueInString() -> String {
        return value.description
    }
    
    @objc func didValueChange() {
        
        let roundedVal = round(value / self.step) * self.step
        
        UIView.animate(withDuration: sliderAnimationTime, animations: { [unowned self] in
            self.setValue(roundedVal, animated: true)
        }) { [unowned self] _ in
            self.updateTopView()
        }
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let trackRect = super.trackRect(forBounds: bounds)
        return CGRect(x: trackRect.origin.x, y: indicatorHeight + thumbWidth/2, width: trackRect.width, height: trackRect.height)
    }
}
