trigger ContentVersionTrigger on ContentVersion (after insert, after update) {

    if(Trigger.isAfter && Trigger.isInsert){
        System.debug('%%%ContentVersionTrigger isAfter isInsert');
        List<ContentVersion> contentVersionList = new List<ContentVersion>();
        for(ContentVersion cv : Trigger.new){
            if(cv.Origin == 'C' && cv.PublishStatus == 'R'){
                contentVersionList.add(cv);
            }
        }
        if(contentVersionList.size() > 0){
            ContentVersionLogic.QRcodeImageSearch(contentVersionList);
        }
    }

    if(Trigger.isAfter && Trigger.isUpdate){
        System.debug('%%%ContentVersionTrigger isAfter isUpdate');
        List<ContentVersion> contentVersionList = new List<ContentVersion>();
        for ( Integer i=0; i<Trigger.New.size(); i++ ){
            if(Trigger.New[i].Title != Trigger.Old[i].Title && Trigger.New[i].Origin == 'C' && Trigger.New[i].PublishStatus == 'P'){
                contentVersionList.add(Trigger.New[i]);
            }
        }
        if(contentVersionList.size() > 0){
            ContentVersionLogic.QRcodeImageSearch(contentVersionList);
        }
    }

}