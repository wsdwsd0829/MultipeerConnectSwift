//
//  ViewController.swift
//  MultipeerConnect
//
//  Created by MAX on 7/17/16.
//  Copyright © 2016 MAX. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, UITextFieldDelegate {

    let peerId = MCPeerID(displayName: "Max Sim Peer")
    //"abc-txtchat"
    let serviceType = "abc-txtchat"
    var bvc: MCBrowserViewController? = nil
    var session: MCSession? = nil
    var advAssitance: MCAdvertiserAssistant?
    var advertiser: MCNearbyServiceAdvertiser?
    
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var receiveLabel: UILabel!
    
    var msgHistory: String = ""

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        sendMessageToPeers()
        textField.resignFirstResponder()
        return true
    }
    
    
    func sendMessageToPeers(){
        guard self.session?.connectedPeers.count > 0 else { return }
        if let data = (self.messageField.text ?? "").dataUsingEncoding(NSUTF8StringEncoding) {
            try! self.session?.sendData(data, toPeers: (session?.connectedPeers)!, withMode: MCSessionSendDataMode.Reliable)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        session = MCSession(peer: peerId)
        session?.delegate = self
        advAssitance = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: ["max":"discoverme"], session: session!)
        advAssitance?.delegate = self
        advAssitance!.start()
    }
    
    @IBAction func makeSelfAvailable(){
        advAssitance = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: ["max":"discoverme"], session: session!)
        advAssitance!.start()
    }
    
    @IBAction func showBrowserViewController() {
        let nearbyServiceBrowser = MCNearbyServiceBrowser(peer: peerId, serviceType: "abc-txtchat")
        
        bvc = MCBrowserViewController(browser: nearbyServiceBrowser, session: session!)
        guard bvc != nil else { return }
        bvc?.delegate = self
        self.presentViewController(bvc!, animated: true,completion: nil)
    }
    
}
extension ViewController: MCAdvertiserAssistantDelegate{
    // An invitation will be presented to the user.
    func advertiserAssistantWillPresentInvitation(advertiserAssistant: MCAdvertiserAssistant) {
        print("will present invitation")
    }
    
    // An invitation was dismissed from screen.
     func advertiserAssistantDidDismissInvitation(advertiserAssistant: MCAdvertiserAssistant){
        print("did dismiss invidtation")
    }
}

extension ViewController: MCBrowserViewControllerDelegate {
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ViewController: MCSessionDelegate {
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        dispatch_async(dispatch_get_main_queue()) {
            let message = String(data: data, encoding: NSUTF8StringEncoding) ?? ""
            print("received Data " + message)
            self.msgHistory += message
            self.receiveLabel.text =  self.msgHistory
            self.messageField.becomeFirstResponder()
        }
    }
    
    func session(session: MCSession,
                   didStartReceivingResourceWithName resourceName: String,
                                                     fromPeer peerID: MCPeerID,
                                                              withProgress progress: NSProgress){
        print(peerID)
    }
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        print("didFinishReceivingResourceWithName" )
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("didReceiveStream")

    }
    
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        
       
        switch state {
            case .Connected:
            dispatch_async(dispatch_get_main_queue()) {
                print("connected")
                self.dismissViewControllerAnimated(true, completion: nil)
                self.messageField.becomeFirstResponder()
            }
            case .Connecting: print("connecting")
            default: print("not connected")
        }
       
        print("didChangeState")

    }
    
}



