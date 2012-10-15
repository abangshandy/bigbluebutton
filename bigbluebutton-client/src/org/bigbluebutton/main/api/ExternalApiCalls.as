package org.bigbluebutton.main.api
{
  import flash.external.ExternalInterface;
  
  import org.bigbluebutton.common.LogUtil;
  import org.bigbluebutton.core.EventConstants;
  import org.bigbluebutton.core.events.CoreEvent;
  import org.bigbluebutton.core.managers.UserManager;
  import org.bigbluebutton.main.events.ParticipantJoinEvent;
  import org.bigbluebutton.main.model.users.BBBUser;

  public class ExternalApiCalls
  {   
    public function handleSwitchToNewRoleEvent(event:CoreEvent):void {
      var payload:Object = new Object();
      payload.eventName = EventConstants.NEW_ROLE;
      payload.role = event.message.role;
      LogUtil.debug("Switch to new role [" + payload.role + "]");
      broadcastEvent(payload);        
    }
        
    public function handleGetMyRoleResponse(event:CoreEvent):void {
      var payload:Object = new Object();
      payload.eventName = EventConstants.GET_MY_ROLE_RESP;
      payload.myRole = event.message.myRole;
      broadcastEvent(payload);        
    }
    
    public function handleUserJoinedVoiceEvent():void {
      LogUtil.debug("User has joined voice conference.");
      var payload:Object = new Object();
      payload.eventName = "userHasJoinedVoiceConference";
      broadcastEvent(payload);
    }
    
    public function handleSwitchedLayoutEvent(layoutID:String):void {
      var payload:Object = new Object();
      payload.eventName = "switchedLayoutEvent";
      payload.layoutID = layoutID;
      broadcastEvent(payload);
    }
    
    public function handleParticipantJoinEvent(event:ParticipantJoinEvent):void {
      var payload:Object = new Object();
      var user:BBBUser = UserManager.getInstance().getConference().getUser(event.userID);
      
      if (user == null) {
        LogUtil.warn("[ExternalApiCall:handleParticipantJoinEvent] Cannot find user with ID [" + event.userID + "]");
        return;
      }
      
      if (event.join) {
        payload.eventName = EventConstants.USER_JOINED;
        payload.userID = user.userID;
        payload.userName = user.name;        
      } else {
        payload.eventName = EventConstants.USER_LEFT;
        payload.userID = user.userID;
      }
      
      broadcastEvent(payload);        
    }    
    
    private function broadcastEvent(message:Object):void {
      if (ExternalInterface.available) {
        ExternalInterface.call("BBB.handleFlashClientBroadcastEvent", message);
      }      
    }
  }
}