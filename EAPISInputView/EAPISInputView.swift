//
//  EAPISInputView.swift
//  EAPIS
//
//  Created by Kumar, Sravan on 15/03/18.
//  Copyright © 2018 Mirajkar, Sripad. All rights reserved.
//

//MARK:- Example Code
/*
 inputView1.fieldState = .notEditable
 inputView1.titleLblText = "Departure"
 inputView1.fieldType = .noImage
 inputView1.fieldErrorType = .error
 //inputView1.errorMessage = "Enter Departure skdnfaskhdf ksndfk asjf sdklfhaslkdjfks;djfklashjd flkasndklfjnlskdjn"
 */

import UIKit

public protocol EAPISInputViewDelegate {
    func didSelectInputView(_ inputView: EAPISInputView)
    func willSelectInputView(_ inputView: EAPISInputView)
}

extension EAPISInputViewDelegate {
    func didSelectInputView(_ inputView: EAPISInputView) {
        
    }
    func willSelectInputView(_ inputView: EAPISInputView) {
        
    }
}

public class EAPISInputView: UIView {
    
    //MARK:- enums
    public enum InputState: Int {
        case required   //default value is required
        case optional
        case notEditable
    }
    
    public enum InputType: Int {
        case noImage    //default value is noImage
        case image
    }
    
    public enum InputErrorType: Int {
        case noError    //default value is noError
        case error
    }
    //MARK:- ==========================================
    
    // MARK:- Outlets of the View
    @IBOutlet private weak var titleLbl: UILabel!
    @IBOutlet private weak var starIcon: UILabel!
    @IBOutlet private weak var inputField: UITextField!
    @IBOutlet private weak var fieldImageView: UIImageView!
    @IBOutlet private weak var errorLbl: UILabel!
    @IBOutlet private weak var fieldInputView: UIView!
    
    //MARK:- properties
    public var delegate: EAPISInputViewDelegate?
    
    /// this property is used to set the default values of the custom view based on the state.
    public var fieldState: InputState = InputState.required {
        willSet {
            if newValue == .optional {
                self.starIcon.removeFromSuperview()
                self.inputField.placeholder = ""
            }else if newValue == .notEditable {
                self.inputField.placeholder = "Not Editable"
            }else {
                self.inputField.placeholder = "Required"
            }
        }
        didSet {
            if let placeholderStr = inputField.placeholder {
                let textFieldAttrStr = NSAttributedString(string: placeholderStr, attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(white: 160/255, alpha: 1)])
                inputField.attributedPlaceholder = textFieldAttrStr
            }
        }
    }
    
    /// this property can be used to set the image on right side of the input field or not.
    public var fieldType: InputType = InputType.noImage {
        willSet {
            if newValue == .noImage {
                self.fieldImageView.removeFromSuperview()
            }
        }
    }
    
    /// this property is used to show the error message of the input field.
    public var fieldErrorType: InputErrorType = InputErrorType.noError {
        willSet {
            if newValue == .noError {
                self.fieldInputView.layer.borderColor = UIColor.clear.cgColor
                self.fieldInputView.layer.borderWidth = 0
                self.errorLbl.text = ""
            }else if newValue == .error, (fieldState == .required || fieldState == .notEditable) {
                self.fieldInputView.layer.borderColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
                self.fieldInputView.layer.borderWidth = 1
                self.errorLbl.text = errorMessage
            }
        }
    }
    
    /// this property can be used to set the image of the input field
    public var fieldImage: String = "" {
        willSet {
            if fieldType == .image {
                self.fieldImageView.image = UIImage(named: newValue)
            }
        }
    }
    
    /// developer can acceess this property to change the value of the text.
    public var titleLblText: String = "" {
        willSet { self.titleLbl.text = newValue }
    }
    
    /// developer can acceess this property to change the label text color.
    public var titleLblTextColor: UIColor = UIColor.init(white: 160/255, alpha: 1) {
        willSet { self.titleLbl.textColor = newValue }
    }
    
    /// developer can acceess this property to change the textfield text color.
    public var inputFieldTextColor: UIColor = UIColor.init(white: 240/255, alpha: 1) {
        willSet { self.inputField.textColor = newValue }
    }
    
    public var errorMessage: String = "" {
        willSet {
            if fieldErrorType == .error {
                self.errorLbl.text = newValue
            }
        }
    }
    
    // MARK:- Intitilizers
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        customizeUI()
    }
    
    /// loads the uiview from the xib and adding to the current view as subview
    private func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "EAPISInputView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = bounds
        print(view.frame)
        view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        addSubview(view)
    }
    
    /// customize the colors and fonts of the UI components
    private func customizeUI() -> Void {
        inputField.textColor = inputFieldTextColor
        titleLbl.textColor = titleLblTextColor
        fieldState = .required
        fieldErrorType = .noError
    }
}

extension EAPISInputView: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if fieldState == .notEditable {
            return false
        }else {
            return true
        }
    }
}

