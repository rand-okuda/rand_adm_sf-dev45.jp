({
    
    doInit : function(component, event, helper) {
        
        var recordId = component.get("v.recordId")
        
        var urlEvent = $A.get("e.force:navigateToURL");
        
        // URLを直接指定して呼び出します。
        urlEvent.setParams({"url":"/apex/InspectionTablePDF?id="+recordId});
        urlEvent.fire();
        
	}
    
})