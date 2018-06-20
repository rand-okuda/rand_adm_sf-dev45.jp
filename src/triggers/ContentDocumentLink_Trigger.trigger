trigger ContentDocumentLink_Trigger on ContentDocumentLink (after insert) {
    System.debug('%%% ContentDocumentLink_Trigger');
    
    List<ContentDocumentLink> targetCDLList = new List<ContentDocumentLink>();
    for ( Integer i=0; i<Trigger.New.size(); i++ ){
        if(Trigger.New[i].ShareType == 'V'){
            targetCDLList.add(Trigger.New[i]);
        }
    }
    if(!targetCDLList.isEmpty()){
        ContentDocumentLink_Logic.StampPredict(targetCDLList);
    }
    
}