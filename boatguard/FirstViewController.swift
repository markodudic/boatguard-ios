//
//  FirstViewController.swift
//  boatguard
//
//  Created by bl4z on 10/09/14.
//  Copyright (c) 2014 bl4z. All rights reserved.
//

import UIKit
import AddressBook

class FirstViewController: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate {

    @IBOutlet var txtUser: UITextField!
    @IBOutlet var txtPass: UITextField!
    @IBOutlet var txtObuid: UITextField!
    @IBOutlet var swRemember: UISwitch!
    
    @IBOutlet var viewLoginTitle: UIView!
    @IBOutlet var viewDashboardTitle: UIView!
    @IBOutlet var viewLogin: UIView!
    @IBOutlet var viewDashboard: UIView!
    
    @IBOutlet var tblObusettings: UITableView!
    @IBOutlet var imgLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add gradients
        let gl_login = CAGradientLayer()
        gl_login.colors = [settings.gradientTop, settings.gradientBottom]
        gl_login.locations = [0.0, 1.0]
        let idiom = UIDevice.currentDevice().userInterfaceIdiom
        if idiom == UIUserInterfaceIdiom.Phone {
            gl_login.frame = CGRectMake(0,0,viewLogin.layer.frame.width,10)
        }
        else {
            gl_login.frame = CGRectMake(0,0,viewLogin.layer.frame.width,30)
        
        }
        viewLogin.layer.insertSublayer(gl_login, atIndex: 0)
        
        self.txtUser.delegate = self;
        self.txtPass.delegate = self;
        self.txtObuid.delegate = self;
        
        //test login
        #if DEBUG
            txtUser.text = "test"
            txtPass.text = "test"
            //txtObuid.text = "12345"
        #endif
        if (states.getRemember()) {
            txtUser.text = states.getUser()
            txtPass.text = states.getPass()
            swRemember.on = states.getRemember()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
    }

    //Events
    @IBAction func btnRegister_click(sender: UIButton) {
        let params1 = "&username="+txtUser.text!
        let params2 = "&password="+txtPass.text!
        let params3 = "&obu_sn="+txtObuid.text!
        let urlPath: String = settings.registerUri+params1+params2+params3
        checkLoginRegister(urlPath)
    }

    @IBAction func btnLogin_click(sender: UIButton) {
        let params1 = "&username="+txtUser.text!
        let params2 = "&password="+txtPass.text!
        let params3 = "&obu_sn="+txtObuid.text!
        let urlPath: String = settings.loginUri+params1+params2+params3
        checkLoginRegister(urlPath)
    }
        
    func checkLoginRegister(urlPath : String) {
        
        let json = Comm.JSONfromURL(urlPath.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
        
        if (json["error"].isDictionary) {
            let alert = UIAlertController(title: json["error"]["name"].asString, message: json["error"]["msg"].asString, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            states.setLogin(json)
            states.setObuid1(json["obu"]["uid"].asInt!)
            states.setUser1(txtUser.text!)
            states.setPass1(txtPass.text!)
            states.setRemember1(swRemember.on)
            states.setSessionId1(json["sessionId"].asString!)
            getobusettings(states.getObuid())
            setDevice()
        }
    }

    func setDevice() {
        let customer = states.getCustomer()["uid"]
        let appVersion = (NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String)
        let device = UIDevice.currentDevice()
        var deviceJson = "{\"id_obu\":\""+String(states.obuid)
        deviceJson += "\", \"id_customer\":\""+customer.description
        deviceJson += "\", \"phone_model\":\""+device.localizedModel
        deviceJson += "\", \"phone_platform\":\""+device.systemName
        deviceJson += "\", \"phone_platform_version\":\""+device.systemVersion
        deviceJson += "\", \"phone_uuid\":\""+device.identifierForVendor!.UUIDString
        deviceJson += "\", \"app_version\":\""+appVersion+"\"}"
        
        Comm.HTTPPostJSON(settings.deviceUri, jsonObj: deviceJson)
    }

    func getobusettings(obuid: Int) {
        self.tabBarController?.tabBar.hidden = false
        
        //appsettings
        let appsettingsJSON  = Comm.JSONfromURL(settings.settingsUri)
        states.setAppsettings(appsettingsJSON)
        
        //obusettings
        let obusettingsURL   = settings.obusettingsUri+"?format=json&obuid="+String(obuid)
        let obusettingsJSON  = Comm.JSONfromURL(obusettingsURL)
        states.setObusettings(obusettingsJSON)
        
        //obucomponents
        let obucomponentsURL  = settings.obucomponentsUri+"?obuid="+String(obuid)
        let obucomponentsJSON = Comm.JSONfromURL(obucomponentsURL)
        states.setObucomponents(obucomponentsJSON)
        
        //customer
        let customerURL  = settings.customerUri+"?obuid="+String(obuid)
        let customerJSON  = Comm.JSONfromURL(customerURL)
        states.setCustomer(customerJSON)

        //obudata
        let obudataURL        = settings.obudataUri+"?obuid="+String(obuid)
        let obudataJSON       = Comm.JSONfromURL(obudataURL)
        states.setObudata(obudataJSON)
        
        //alarms
        let alarmsURL  = settings.obuAlarmsUri+"?obuid="+String(obuid)
        let alarmsJSON  = Comm.JSONfromURL(alarmsURL)
        states.setAlarms(alarmsJSON)
        
        //history
        let historyURL  = settings.historyUri+"?obuid="+String(obuid)
        let historyJSON  = Comm.JSONfromURL(historyURL)
        states.setHistory(historyJSON)

        //friends
        let friendsURL  = settings.friendsUri+"?customerid="+String(states.customer["uid"].asInt!)
        let friendsJSON  = Comm.JSONfromURL(friendsURL)
        states.setFriends(friendsJSON)
        
        //get contacts from phonebook
        // make sure user hadn't previously denied access
        /*
        let status = ABAddressBookGetAuthorizationStatus()
        if status == .Denied || status == .Restricted {
            let alert = UIAlertController(title: "Phonebook access", message: "Phonebook is not accessable. Enable it in the settings.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        // open it
        var error: Unmanaged<CFError>?
        let addressBook: ABAddressBook? = ABAddressBookCreateWithOptions(nil, &error)?.takeRetainedValue()
        if addressBook == nil {
            print(error?.takeRetainedValue())
            return
        }
        
        // request permission to use it
        ABAddressBookRequestAccessWithCompletion(addressBook) {
            granted, error in
            
            if !granted {
                let alert = UIAlertController(title: "Phonebook access", message: "Phonebook is not accessable. Enable it in the settings.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            
            let allContacts : NSArray = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue()
            for contactRef:ABRecordRef in allContacts {
                let contact: Contact = Contact()

                let uid = ABRecordGetRecordID(contactRef)
                if uid != kABRecordInvalidID{
                    let numberID: NSNumber = NSNumber(int: uid)
                    contact.setUid1(numberID.integerValue)
                }
                
                if (ABRecordCopyValue(contactRef, kABPersonFirstNameProperty) != nil) {
                    if let firstName = ABRecordCopyValue(contactRef, kABPersonFirstNameProperty).takeUnretainedValue() as? NSString {
                        contact.setName1(firstName as String)
                    }
                }

                if (ABRecordCopyValue(contactRef, kABPersonLastNameProperty) != nil) {
                    if let lastName = ABRecordCopyValue(contactRef, kABPersonLastNameProperty).takeUnretainedValue() as? NSString {
                        contact.setLastName1(lastName as String)
                    }
                }
                
                if (ABRecordCopyValue(contactRef, kABPersonPhoneProperty) != nil) {
                    let phones: ABMultiValueRef = ABRecordCopyValue(contactRef, kABPersonPhoneProperty).takeUnretainedValue() as ABMultiValueRef
                
                    for var index = 0; index < ABMultiValueGetCount(phones); ++index{
                        let currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phones, index).takeUnretainedValue() as CFStringRef as CFString
                        let currentPhoneValue = ABMultiValueCopyValueAtIndex(phones, index).takeUnretainedValue() as! CFStringRef as String
                    
                        if currentPhoneLabel == kABPersonPhoneMobileLabel {
                            contact.setPhoneNum1(currentPhoneValue)
                        }
                    }
                }
                
                if (ABRecordCopyValue(contactRef, kABPersonEmailProperty) != nil) {
                    if let email = ABRecordCopyValue(contactRef, kABPersonEmailProperty).takeUnretainedValue() as? NSString {
                        contact.setEmail1(email as String)
                    }
                }
                
                states.contacts.append(contact)
            }

        }*/

        //open storyboard
        var storyboard = UIStoryboard(name: "Main_ipad", bundle: nil)
        let idiom = UIDevice.currentDevice().userInterfaceIdiom
        if idiom == UIUserInterfaceIdiom.Phone {
            storyboard = UIStoryboard(name: "Main", bundle: nil)
        }
        let tabController = storyboard.instantiateViewControllerWithIdentifier("TabController") as? UIViewController
        presentViewController(tabController!, animated:false, completion:nil)
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //tole je za skrivanje tipkovnice ob prijavi
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
