# MultipeerConnectSwift

A simple sample to use multipeer connection frameworkin ios

Notes:
##To see others: Create Session with PeerId and MCNearbyServiceBrowser to present: MCBrowserViewController
  ###let nearbyServiceBrowser = MCNearbyServiceBrowser(peer: peerId, serviceType: "abc-txtchat")
        bvc = MCBrowserViewController(browser: nearbyServiceBrowser, session: session!)
        guard bvc != nil else { return }
        bvc?.delegate = self
        self.presentViewController(bvc!, animated: true,completion: nil)
##To able to cancel(MCBrowserViewController): MCBrowserViewControllerDelegate        
##To make youself see by others:  MCAdvertiserAssistant
  ###advAssitance = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: ["max":"discoverme"], session: session!)
  
##To handle message and status: MCSessionDelegate

##Tricks: 
  ###Need dismiss MCBrowserViewController when connected to let session delegate handle messages received.
  ###Need to hold reference to MCAdvertiserAssistant(e.g. in "view controller") to keep yourself seen/seeable by others.  
